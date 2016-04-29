# Parable

This is the heart of Parable. It provides the compiler, byte code
interpreter, and minimal fundamentals to build a complete language.

### Preamble


````
# Parable, Copyright (c) 2012-2016 Charles Childers
# coding: utf-8
````

### Configuration

This is where we setup some constants related to the memory model.

**INITIAL_SLICES** is the number of slices to allocate initially.

**PREALLOCATE** is the number of slices to allocate when out of memory.

If you're running on a memory constrained target, reducing these may help
save some memory.

````
INITIAL_SLICES = 9250
PREALLOCATE = 1250
````

### Dependencies

Parable has two fundamental dependencies: **math** and **random** or **os**.

It uses various functions from **math**. From **random** it uses
**SystemRandom()**, or **urandom()** from **os** if **random** can't be
loaded.

*Note: the os.urandom() approach is a fallback for use with micropython.**

````
import math

try:
    import random
except:
    import os
````


### Constants

Parable has a *lot* of constants. These are used for data types and byte
code numbers.

First up, the fundamental data types:

````
TYPE_NUMBER = 100
TYPE_STRING = 200
TYPE_CHARACTER = 300
TYPE_POINTER = 400
TYPE_FLAG = 500
TYPE_BYTECODE = 600
TYPE_REMARK = 700
TYPE_FUNCALL = 800
````

For **precheck()**, we also allow matching against some *generic* types:

````
TYPE_ANY = 0
TYPE_ANY_PTR = 1
````

And then the biggest set are the individual byte codes:

````
BC_NOP = 0
BC_SET_TYPE = 1
BC_GET_TYPE = 2
BC_ADD = 3
BC_SUBTRACT = 4
BC_MULTIPLY = 5
BC_DIVIDE = 6
BC_REMAINDER = 7
BC_POW = 8
BC_LOGN = 9
BC_BITWISE_SHIFT = 10
BC_BITWISE_AND = 11
BC_BITWISE_OR = 12
BC_BITWISE_XOR = 13
BC_RANDOM = 14
BC_SQRT = 15
BC_COMPARE_LT = 16
BC_COMPARE_GT = 17
BC_COMPARE_LTEQ = 18
BC_COMPARE_GTEQ = 19
BC_COMPARE_EQ = 20
BC_COMPARE_NEQ = 21
BC_FLOW_IF = 22
BC_FLOW_WHILE = 23
BC_FLOW_UNTIL = 24
BC_FLOW_TIMES = 25
BC_FLOW_CALL = 26
BC_FLOW_DIP = 27
BC_FLOW_SIP = 28
BC_FLOW_BI = 29
BC_FLOW_TRI = 30
BC_FLOW_ABORT = 31
BC_MEM_COPY = 32
BC_MEM_FETCH = 33
BC_MEM_STORE = 34
BC_MEM_REQUEST = 35
BC_MEM_RELEASE = 36
BC_MEM_COLLECT = 37
BC_MEM_GET_LAST = 38
BC_MEM_SET_LAST = 39
BC_MEM_SET_TYPE = 40
BC_MEM_GET_TYPE = 41
BC_STACK_DUP = 42
BC_STACK_DROP = 43
BC_STACK_SWAP = 44
BC_STACK_DEPTH = 45
BC_QUOTE_NAME = 46
BC_FUNCTION_HIDE = 47
BC_STRING_SEEK = 48
BC_SLICE_SUBSLICE = 49
BC_STRING_NUMERIC = 50
BC_SLICE_REVERSE = 51
BC_TO_LOWER = 52
BC_TO_UPPER = 53
BC_REPORT = 54
BC_VM_NAMES = 55
BC_VM_SLICES = 56
BC_TRIG_SIN = 57
BC_TRIG_COS = 58
BC_TRIG_TAN = 59
BC_TRIG_ASIN = 60
BC_TRIG_ACOS = 61
BC_TRIG_ATAN = 62
BC_TRIG_ATAN2 = 63
BC_VM_MEM_MAP = 64
BC_VM_MEM_SIZES = 65
BC_VM_MEM_ALLOC = 66
````


### Support Code

Here Parable has a few functions that are used later, in various places.

**is_number()** determines if a string can be treated as a number.

````
def is_number(s):
    """return True if s is a number, or False otherwise"""
    try:
        float(s)
        return True
    except ValueError:
        return False
````

**is_balanced()** determines if a list of tokens contains a balanced
number of brackets.

````
def is_balanced(tokens):
    braces = 0
    for t in tokens:
        if t == '[':  braces = braces + 1
        if t == ']':  braces = braces - 1
    if braces == 0:
        return True
    else:
        return False
````

**tokenize()** breaks a string into a series of tokens. The resulting list
is used with **is_balanced()** and **condense_lines()**. Tokenization is
mostly just splitting on spaces, but this also accounts for strings
(delimited by ') and remarks (delimited by ").

````
def tokenize(str):
    tokens = ' '.join(str.strip().split()).split(' ')
    cleaned = []
    i = 0
    while i < len(tokens):
        current = tokens[i]
        prefix = tokens[i][:1]
        s = ""
        if prefix == '"':
            i, s = parse_string(tokens, i, len(tokens), '"')
        elif prefix == "'":
            i, s = parse_string(tokens, i, len(tokens), '\'')
        if s != "":
            cleaned.append(s)
        elif current != '':
            cleaned.append(current)
        i = i + 1
    return cleaned
````

The Parable compiler expects each function to be on a single line of
source. This routine, **condense_lines()** takes an array of lines,
tokenizes them, checks for balanced brackets, and merges them as needed.
It then returns a new array with one line per function.

*Note: this currently also allows use of a trailing \ to merge lines. This
is deprecated and will be removed in a future release.*

````
def condense_lines(code):
    """Take an array of code, join lines ending with a \, and return"""
    """the new array"""
    s = ''
    r = []
    for line in code:
        if line.endswith(' \\\n'):
            s = s + ' ' + line[:-2].strip()
        else:
            s = s + ' ' + line.strip()
        if is_balanced(tokenize(s)):
            r.append(s.strip())
            s = ''
    return r
````


### Byte Codes

The Parable virtual machine is byte coded; each byte code corresponds to a
single instruction. In this section we assign each byte code a symbolic
name and value, provide an implementation for each (with one exception:
see **interpet()** for details on this), and then build a dispatch table
that maps each instuction to its handler.

Some commentary will be provided for each byte code.

First, we have a couple of things that are used to help catch type errors
and gracefully abort execution when issues are detected.

````
should_abort = False        # Used to indicate if an error was detected during
                            # the current run.

def abort_run(opcode, offset):
    global should_abort
    report("E05: Invalid Types or Stack Underflow")
    report("Error processing `{0} at offset {1} in slice {2}".format(opcode, offset, current_slice))
    should_abort = True


def precheck(req):
    flag = True
    if stack_depth() < len(req):
        flag = False
    i = stack_depth() - 1
    if flag:
        for t in reversed(req):
            if t == TYPE_ANY_PTR:
                if stack_type_for(i) != TYPE_POINTER and \
                   stack_type_for(i) != TYPE_STRING and \
                   stack_type_for(i) != TYPE_REMARK and \
                   stack_type_for(i) != TYPE_FUNCALL:
                    flag = False
            elif t != stack_type_for(i) and t != TYPE_ANY:
                flag = False
            i = i - 1
    return flag
````


The simplest instruction is **BC_NOP** which does nothing. It's useful for
padding things.

````
def bytecode_nop(opcode, offset, more):
    return
````

**BC\_SET\_TYPE** allows for setting the type for a value on the stack.
You can use any value, but only the ones corresponding to a **TYPE_**
constant have any real meaning to Parable. This uses
**stack\_change\_type()** to do the conversions.

````
def bytecode_set_type(opcode, offset, more):
    if precheck([TYPE_ANY, TYPE_NUMBER]):
        a = stack_pop()
        stack_change_type(a)
    else:
        abort_run(opcode, offset)
````

**BC\_GET\_TYPE** pushes a number repesenting the type constant for the
top item on the stack.

````
def bytecode_get_type(opcode, offset, more):
    if precheck([TYPE_ANY]):
        stack_push(stack_type(), TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

The most complex of the byte codes is **BC_ADD**. The complexity arises
from the number of types this deals with. The **BC_ADD** instruction can:

* add two numbers
* merge two strings, remarks, or slices into a new string, remark, or slice
* combine two characters to a string
* append or prepend characters to a string or remark

We implement each specific combination as a separate function and then
wrap them all up in a single top level function.

````
# --[ Factor out specific conversions for BC_ADD ]--

def bytecode_add_NN():
    a = stack_pop()
    b = stack_pop()
    stack_push(b + a, TYPE_NUMBER)

def bytecode_add_SS():
    a = slice_to_string(stack_pop())
    b = slice_to_string(stack_pop())
    stack_push(string_to_slice(b + a), TYPE_STRING)

def bytecode_add_CC():
    a = chr(int(stack_pop()))
    b = chr(int(stack_pop()))
    stack_push(string_to_slice(b + a), TYPE_STRING)

def bytecode_add_CS():
    a = slice_to_string(stack_pop())
    b = chr(int(stack_pop()))
    stack_push(string_to_slice(b + a), TYPE_STRING)

def bytecode_add_SC():
    a = chr(int(stack_pop()))
    b = slice_to_string(stack_pop())
    stack_push(string_to_slice(b + a), TYPE_STRING)

def bytecode_add_RR():
    a = slice_to_string(stack_pop())
    b = slice_to_string(stack_pop())
    stack_push(string_to_slice(b + a), TYPE_REMARK)

def bytecode_add_PP():
    a = stack_pop()
    b = stack_pop()
    c = request_slice()
    d = get_last_index(b) + get_last_index(a) + 1
    set_slice_last_index(c, d)
    memory_values[c] = memory_values[b] + memory_values[a]
    memory_types[c] = memory_types[b] + memory_types[a]
    stack_push(c, TYPE_POINTER)

def bytecode_add_CR():
    a = slice_to_string(stack_pop())
    b = chr(int(stack_pop()))
    stack_push(string_to_slice(b + a), TYPE_REMARK)

def bytecode_add_RC():
    a = chr(int(stack_pop()))
    b = slice_to_string(stack_pop())
    stack_push(string_to_slice(b + a), TYPE_REMARK)

# --[ Finished specific conversions for BC_ADD ]--

def bytecode_add(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        bytecode_add_NN()
    elif precheck([TYPE_STRING, TYPE_STRING]):
        bytecode_add_SS()
    elif precheck([TYPE_CHARACTER, TYPE_CHARACTER]):
        bytecode_add_CC()
    elif precheck([TYPE_CHARACTER, TYPE_STRING]):
        bytecode_add_CS()
    elif precheck([TYPE_STRING, TYPE_CHARACTER]):
        bytecode_add_SC()
    elif precheck([TYPE_REMARK, TYPE_REMARK]):
        bytecode_add_RR()
    elif precheck([TYPE_POINTER, TYPE_POINTER]):
        bytecode_add_PP()
    elif precheck([TYPE_CHARACTER, TYPE_REMARK]):
        bytecode_add_CR()
    elif precheck([TYPE_REMARK, TYPE_CHARACTER]):
        bytecode_add_RC()
    else:
        abort_run(opcode, offset)
````

And with that taken care of, we can move on to the rest of the byte codes.

**BC_SUBTRACT** subtracts one number from another.

````
def bytecode_subtract(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        a = stack_pop()
        b = stack_pop()
        stack_push(b - a, TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

**BC_MULTIPLY** multiplies two numbers.

````
def bytecode_multiply(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        a = stack_pop()
        b = stack_pop()
        stack_push(b * a, TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

**BC_DIVIDE** divides two numbers. Errors in division will push *#nan* to
the stack and abort with a divide by zero error.

````
def bytecode_divide(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        a = stack_pop()
        b = stack_pop()
        try:
            stack_push(float(b / a), TYPE_NUMBER)
        except:
            stack_push(float('nan'), TYPE_NUMBER)
            report('E04: Divide by Zero')
            abort_run(opcode, offset)
    else:
        abort_run(opcode, offset)
````

**BC_REMAINDER** divdes two numbers and returns the remainder. Like the
**BC_DIVIDE**, errors will push *#nan* and abort with an error.

````
def bytecode_remainder(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        a = stack_pop()
        b = stack_pop()
        try:
            stack_push(float(b % a), TYPE_NUMBER)
        except:
            stack_push(float('nan'), TYPE_NUMBER)
            report('E04: Divide by Zero')
            abort_run(opcode, offset)
    else:
        abort_run(opcode, offset)
````

**BC_POW** raises a number to a specific power.

````
def bytecode_pow(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        a = stack_pop()
        b = stack_pop()
        stack_push(math.pow(b, a), TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

**BC\_LOG\_N** returns the logarithm of a number in the specified base.

````
def bytecode_logn(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        a = stack_pop()
        b = stack_pop()
        if a > 0 and b > 0:
            stack_push(math.log(b, a), TYPE_NUMBER)
        else:
            abort_run(opcode, offset)
    else:
        abort_run(opcode, offset)
````

**BC\_BITWISE\_SHIFT** performs a bitwise shift. If the second number is
negative this does a left shift. If positive, it does a right shift
instead.

````
def bytecode_bitwise_shift(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        a = int(stack_pop())
        b = int(stack_pop())
        if a < 0:
            stack_push(b << abs(a), TYPE_NUMBER)
        else:
            stack_push(b >> a, TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

**BC\_BITWISE\_AND** performs a bitwise AND operation on numbers or flags.

````
def bytecode_bitwise_and(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        a = int(stack_pop())
        b = int(stack_pop())
        stack_push(b & a, TYPE_NUMBER)
    elif precheck([TYPE_FLAG, TYPE_FLAG]):
        a = int(stack_pop())
        b = int(stack_pop())
        stack_push(b & a, TYPE_FLAG)
    else:
        abort_run(opcode, offset)
````

**BC\_BITWISE\_OR** performs a bitwise OR operation on numbers or flags.

````
def bytecode_bitwise_or(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        a = int(stack_pop())
        b = int(stack_pop())
        stack_push(b | a, TYPE_NUMBER)
    elif precheck([TYPE_FLAG, TYPE_FLAG]):
        a = int(stack_pop())
        b = int(stack_pop())
        stack_push(b | a, TYPE_FLAG)
    else:
        abort_run(opcode, offset)
````

**BC\_BITWISE\_XOR** performs a bitwise XOR operation on numbers or flags.

````
def bytecode_bitwise_xor(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        a = int(stack_pop())
        b = int(stack_pop())
        stack_push(b ^ a, TYPE_NUMBER)
    elif precheck([TYPE_FLAG, TYPE_FLAG]):
        a = int(stack_pop())
        b = int(stack_pop())
        stack_push(b ^ a, TYPE_FLAG)
    else:
        abort_run(opcode, offset)
````

Random number generation: we have two approaches. The better one is to
just use Python's **random.SystemRandom().random()**. But *micropython*
lacks the **random** module at this point (*2016.04*), so we have a
fallback using **os.urandom()** instead.

````
def bytecode_random(opcode, offset, more):
    try:
        stack_push(random.SystemRandom().random(), TYPE_NUMBER)
    except:
        rand = (int.from_bytes(os.urandom(7), 'big') >> 3) / (1 << 53)
        stack_push(rand, TYPE_NUMBER)
````

**BC_SQRT** returns the square root of a number.

````
def bytecode_sqrt(opcode, offset, more):
    if precheck([TYPE_NUMBER]):
        stack_push(math.sqrt(stack_pop()), TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

**BC\_COMPARE\_LT** compares two numbers for a condition of less than.

````
def bytecode_compare_lt(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        a = stack_pop()
        b = stack_pop()
        if b < a:
            stack_push(-1, TYPE_FLAG)
        else:
            stack_push(0, TYPE_FLAG)
    else:
        abort_run(opcode, offset)
````

**BC\_COMPARE\_GT** compares two numbers for a condition of greater than.

````
def bytecode_compare_gt(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        a = stack_pop()
        b = stack_pop()
        if b > a:
            stack_push(-1, TYPE_FLAG)
        else:
            stack_push(0, TYPE_FLAG)
    else:
        abort_run(opcode, offset)
````

**BC\_COMPARE\_LTEQ** compares two numbers for a condition of less than or
equal to.

````
def bytecode_compare_lteq(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        a = stack_pop()
        b = stack_pop()
        if b <= a:
            stack_push(-1, TYPE_FLAG)
        else:
            stack_push(0, TYPE_FLAG)
    else:
        abort_run(opcode, offset)
````

**BC\_COMPARE\_GTEQ** compares two numbers for a condition of greater than or
equal to.

````
def bytecode_compare_gteq(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        a = stack_pop()
        b = stack_pop()
        if b >= a:
            stack_push(-1, TYPE_FLAG)
        else:
            stack_push(0, TYPE_FLAG)
    else:
        abort_run(opcode, offset)
````

**BC\_COMPARE\_EQ** compares two values for equality.

````
def bytecode_compare_eq(opcode, offset, more):
    if precheck([TYPE_STRING, TYPE_STRING]) or \
       precheck([TYPE_REMARK, TYPE_REMARK]):
        a = slice_to_string(stack_pop())
        b = slice_to_string(stack_pop())
    elif precheck([TYPE_ANY, TYPE_ANY]):
        a = stack_pop()
        b = stack_pop()
    if b == a:
        stack_push(-1, TYPE_FLAG)
    else:
        stack_push(0, TYPE_FLAG)
````

**BC\_COMPARE\_NEQ** compares two values for inequality.

````
def bytecode_compare_neq(opcode, offset, more):
    if precheck([TYPE_STRING, TYPE_STRING]) or \
       precheck([TYPE_REMARK, TYPE_REMARK]):
        a = slice_to_string(stack_pop())
        b = slice_to_string(stack_pop())
    elif precheck([TYPE_ANY, TYPE_ANY]):
        a = stack_pop()
        b = stack_pop()
    if b != a:
        stack_push(-1, TYPE_FLAG)
    else:
        stack_push(0, TYPE_FLAG)
````

**BC\_FLOW\_IF** implements conditional calls based on two pointers and a
flag. When the flag is true it'll run the first quote (NOS) and when false
it runs the second (TOS).

````
def bytecode_flow_if(opcode, offset, more):
    if precheck([TYPE_FLAG, TYPE_POINTER, TYPE_POINTER]):
        a = stack_pop()  # false
        b = stack_pop()  # true
        c = stack_pop()  # flag
        if c == -1:
            interpret(b, more)
        else:
            interpret(a, more)
    else:
        abort_run(opcode, offset)
````

**BC\_FLOW\_WHILE** is one of three looping functions. It executes a quote
(which needs to return a flag). As long as the flag is true, the quote is
executed again. When false, execution ends.

````
def bytecode_flow_while(opcode, offset, more):
    if precheck([TYPE_POINTER]):
        quote = stack_pop()
        a = -1
        while a == -1:
            interpret(quote, more)
            if precheck([TYPE_FLAG]):
                a = stack_pop()
            else:
                if abort_run == False:
                    abort_run(opcode, offset)
                a = 0
    else:
        abort_run(opcode, offset)
````

**BC\_FLOW\_UNTIL** is one of three looping functions. It executes a quote
(which needs to return a flag). As long as the flag is false, the quote is
executed again. When true, execution ends. *This is the inverse of the
**BC\_FLOW\_WHILE** instruction*.

````
def bytecode_flow_until(opcode, offset, more):
    if precheck([TYPE_POINTER]):
        quote = stack_pop()
        a = 0
        while a == 0:
            interpret(quote, more)
            if precheck([TYPE_FLAG]):
                a = stack_pop()
            else:
                if abort_run == False:
                    abort_run(opcode, offset)
                a = -1
    else:
        abort_run(opcode, offset)
````

The last of the looping instructions is **BC\_FLOW\_TIMES** which takes a
pointer and a count. It then executes the quote the specified number of times.

````
def bytecode_flow_times(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_POINTER]):
        quote = stack_pop()
        count = int(stack_pop())
        for i in range(0, count):
            interpret(quote, more)
    else:
        abort_run(opcode, offset)
````

The **BC\_FLOW\_CALL** instruction invokes a function. Pass the pointer on the
stack.

*Note: it's technically possible to execute any slice, but we don't allow for
direct execution of strings and remarks: convert them to pointers first if you
need this.*

````
def bytecode_flow_call(opcode, offset, more):
    if precheck([TYPE_POINTER]) or precheck([TYPE_FUNCALL]):
        a = stack_pop()
        interpret(a, more)
    else:
        abort_run(opcode, offset)
````

**BC\_FLOW\_DIP** is a handy combinator: it takes a quote and a value and
moves the value off the stack before invoking the quote. It then restores the
value.

````
def bytecode_flow_dip(opcode, offset, more):
    if precheck([TYPE_ANY, TYPE_POINTER]):
        quote = stack_pop()
        v, t = stack_pop(type = True)
        interpret(quote, more)
        stack_push(v, t)
    else:
        abort_run(opcode, offset)
````

**BC\_FLOW\_SIP** is similar to **BC\_FLOW\_DIP** in that it takes a value and
a quote. But it leaves the original value on the stack and pushes a copy back
once the quote has finished executing.

````
def bytecode_flow_sip(opcode, offset, more):
    if precheck([TYPE_ANY, TYPE_POINTER]):
        quote = stack_pop()
        stack_dup()
        v, t = stack_pop(type = True)
        interpret(quote, more)
        stack_push(v, t)
    else:
        abort_run(opcode, offset)
````

**BC\_FLOW\_BI** takes a value and two quotes. It then pushes the value and
the first quote to the stack, executes this, then repeats with a copy of the
value and the second quote.

````
def bytecode_flow_bi(opcode, offset, more):
    if precheck([TYPE_ANY, TYPE_POINTER, TYPE_POINTER]):
        a = stack_pop()
        b = stack_pop()
        stack_dup()
        y, x = stack_pop(type = True)
        interpret(b, more)
        stack_push(y, x)
        interpret(a, more)
    else:
        abort_run(opcode, offset)
````

**BC\_FLOW\_TRI** takes a value and three quotes. It then pushes the value and
the first quote to the stack, executes this, then repeats with a copy of the
value and the second quote. The process is repeated once more with the final
quote.

````
def bytecode_flow_tri(opcode, offset, more):
    if precheck([TYPE_ANY, TYPE_POINTER, TYPE_POINTER, TYPE_POINTER]):
        a = stack_pop()
        b = stack_pop()
        c = stack_pop()
        stack_dup()
        y, x = stack_pop(type = True)
        stack_dup()
        q, m = stack_pop(type = True)
        interpret(c, more)
        stack_push(q, m)
        interpret(b, more)
        stack_push(y, x)
        interpret(a, more)
    else:
        abort_run(opcode, offset)
````

**BC\_FLOW\_ABORT** stops executing a slice and all of its ancestors. It
sets the global **should_abort** flag, which ends all **interpret()**
loops. The next compilation will reset the flag, or the interface layer
can manually reset it as needed.

````
def bytecode_flow_abort(opcode, offset, more):
    global should_abort
    should_abort = True
````

**BC\_MEM\_COPY** copies the contents of one slice to another. This doesn't do
partial copies: use **BC\_SUBSLICE** to extract a copy of a subset if you need
this.

````
def bytecode_mem_copy(opcode, offset, more):
    if precheck([TYPE_ANY_PTR, TYPE_ANY_PTR]):
        a = stack_pop()
        b = stack_pop()
        copy_slice(b, a)
    else:
        abort_run(opcode, offset)
````

**BC\_MEM\_FETCH** retrieves a stored value from a slice.

````
def bytecode_mem_fetch(opcode, offset, more):
    if precheck([TYPE_ANY_PTR, TYPE_NUMBER]):
        a = stack_pop()     # offset
        b = stack_pop()     # slice
        if math.isnan(a) or math.isinf(a):
            abort_run(opcode, offset)
        else:
            v, t = fetch(b, a)
            stack_push(v, t)
    else:
        abort_run(opcode, offset)
````

**BC\_MEM\_STORE** stores a value into a slice.

````
def bytecode_mem_store(opcode, offset, more):
    if precheck([TYPE_ANY, TYPE_ANY_PTR, TYPE_NUMBER]):
        a = stack_pop()     # offset
        b = stack_pop()     # slice
        c, t = stack_pop(type = True)   # value
        if math.isnan(a) or math.isinf(a):
            abort_run(opcode, offset)
        else:
            store(c, b, a, t)
    else:
        abort_run(opcode, offset)
````

Need a slice? Use **BC\_MEM\_REQUEST** to allocate one and push the slice
number to the stack.

````
def bytecode_mem_request(opcode, offset, more):
    stack_push(request_slice(), TYPE_POINTER)
````

Don't need a slice anymore? **BC\_MEM\_RELEASE** will use
**release_slice()** to return it to the pool of unused slices.

````
def bytecode_mem_release(opcode, offset, more):
    if precheck([TYPE_POINTER]):
        release_slice(stack_pop())
    else:
        abort_run(opcode, offset)
````

While Parable attempts to collect garbage automatically, it's sometimes a
good idea to manually trigger a collection cycle. You can do this with
**BC\_MEM\_COLLECT**.

````
def bytecode_mem_collect(opcode, offset, more):
    collect_garbage()
````

**BC\_MEM\_GET\_LAST** returns the last index into a slice. This can be used
to check the *length* of the slice.

````
def bytecode_mem_get_last(opcode, offset, more):
    if precheck([TYPE_POINTER]) or \
       precheck([TYPE_STRING]) or \
       precheck([TYPE_REMARK]):
        a = stack_pop()
        stack_push(get_last_index(a), TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

**BC\_MEM\_SET\_LAST** sets the last index into a slice. This can be used to
grow or shrink a slice.

````
def bytecode_mem_set_last(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_POINTER]):
        a = stack_pop()
        b = stack_pop()
        set_slice_last_index(a, b)
    else:
        abort_run(opcode, offset)
````

**BC\_MEM\_SET\_TYPE** sets the stored type constant for a value without going
through a conversion process.

*This may be removed in a later Parable release*

````
def bytecode_mem_set_type(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_POINTER, TYPE_NUMBER]):
        a = stack_pop()  # offset
        b = stack_pop()  # slice
        c = stack_pop()  # type
        store_type(b, a, c)
    else:
        abort_run(opcode, offset)
````

**BC\_MEM\_GET\_TYPE** fetches the stored type constant for a value.

*This may be removed in a later Parable release*

````
def bytecode_mem_get_type(opcode, offset, more):
    if precheck([TYPE_POINTER, TYPE_NUMBER]):
        a = stack_pop()
        b = stack_pop()
        v, t = fetch(b, a)
        stack_push(int(t), TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

**BC\_STACK\_DUP** duplicates the top item on the stack. If this is a string
or remark, it'll make a copy of the string or remark and not just duplicate
the pointer.

````
def bytecode_stack_dup(opcode, offset, more):
    if precheck([TYPE_ANY]):
        stack_dup()
    else:
        abort_run(opcode, offset)
````

**BC\_STACK\_DROP** discards the top item on the stack.

````
def bytecode_stack_drop(opcode, offset, more):
    if precheck([TYPE_ANY]):
        stack_drop()
    else:
        abort_run(opcode, offset)
````

**BC\_STACK\_SWAP** switches the locations of the top and secondary items on
the stack.

````
def bytecode_stack_swap(opcode, offset, more):
    if precheck([TYPE_ANY, TYPE_ANY]):
        stack_swap()
    else:
        abort_run(opcode, offset)
````

**BC\_STACK\_DEPTH** returns the number of items currently on the stack.

````
def bytecode_stack_depth(opcode, offset, more):
    stack_push(stack_depth(), TYPE_NUMBER)
````

**BC\_QUOTE\_NAME** attaches a name to a slice.

````
def bytecode_quote_name(opcode, offset, more):
    if precheck([TYPE_ANY_PTR, TYPE_STRING]):
        name = slice_to_string(stack_pop())
        ptr = stack_pop()
        add_definition(name, ptr)
    else:
        abort_run(opcode, offset)
````

To remove something from the dictionary, use **BC\_FUNCTION\_HIDE**. It takes
a string and removes the header.

````
def bytecode_function_hide(opcode, offset, more):
    if precheck([TYPE_STRING]):
        name = slice_to_string(stack_pop())
        if lookup_pointer(name) != -1:
            remove_name(name)
    else:
        abort_run(opcode, offset)
````

````
def bytecode_string_seek(opcode, offset, more):
    if precheck([TYPE_STRING, TYPE_STRING]):
        a = slice_to_string(stack_pop())
        b = slice_to_string(stack_pop())
        stack_push(b.find(a), TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

````
def bytecode_slice_subslice(opcode, offset, more):
    if precheck([TYPE_POINTER, TYPE_NUMBER, TYPE_NUMBER]) or \
       precheck([TYPE_STRING, TYPE_NUMBER, TYPE_NUMBER]) or \
       precheck([TYPE_REMARK, TYPE_NUMBER, TYPE_NUMBER]):
        a = int(stack_pop())  # end
        b = int(stack_pop())  # start
        s, t = stack_pop(type=True)  # pointer
        s = int(s)
        c = memory_values[s]
        d = c[b:a]
        dt = memory_types[s]
        dt = dt[b:a]
        e = request_slice()
        i = 0
        while i < len(d):
            store(d[i], e, i, dt[i])
            i = i + 1
        stack_push(e, t)
    else:
        abort_run(opcode, offset)
````

**BC\_STRING\_NUMERIC** will return a flag indicating true if a string can
be converted to a number or false otherwise.

````
def bytecode_string_numeric(opcode, offset, more):
    if precheck([TYPE_STRING]):
        a = slice_to_string(stack_pop())
        if is_number(a):
            stack_push(-1, TYPE_FLAG)
        else:
            stack_push(0, TYPE_FLAG)
    else:
        abort_run(opcode, offset)
````

**BC\_SLICE\_REVERSE** will invert the order of values stored in a slice.
This modifies the contents of the original slice:

````
def bytecode_slice_reverse(opcode, offset, more):
    if precheck([TYPE_POINTER]) or \
       precheck([TYPE_STRING]) or \
       precheck([TYPE_REMARK]):
        a, t = stack_pop(type = True)
        a = int(a)
        memory_values[a] = memory_values[a][::-1]
        memory_types[a] = memory_types[a][::-1]
        stack_push(a, t)
    else:
        abort_run(opcode, offset)
````

**BC\_TO\_UPPER** converts a character or string to uppercase.

*Note: this currently assumes an ASCII character set.*

````
def bytecode_to_upper(opcode, offset, more):
    if precheck([TYPE_STRING]):
        ptr = stack_pop()
        a = slice_to_string(ptr).upper()
        stack_push(string_to_slice(a), TYPE_STRING)
    elif precheck([TYPE_CHARACTER]):
        a = stack_pop()
        if a >= 32 and a <= 128:
            b = ''.join(chr(a))
            a = b.upper()
            stack_push(ord(a[0].encode('utf-8')), TYPE_CHARACTER)
        else:
            report('CHARACTER not in valid range (32 .. 128)')
            abort_run(opcode, offset)
    else:
        abort_run(opcode, offset)
````

**BC\_TO\_LOWER** convers a character or string to lowercase.

*Note: this currently assumes an ASCII character set.*

````
def bytecode_to_lower(opcode, offset, more):
    if precheck([TYPE_STRING]):
        ptr = stack_pop()
        a = slice_to_string(ptr).lower()
        stack_push(string_to_slice(a), TYPE_STRING)
    elif precheck([TYPE_CHARACTER]):
        a = stack_pop()
        if a >= 32 and a <= 128:
            b = ''.join(chr(a))
            a = b.lower()
            stack_push(ord(a[0].encode('utf-8')), TYPE_CHARACTER)
        else:
            report('CHARACTER not in valid range (32 .. 128)')
            abort_run(opcode, offset)
    else:
        abort_run(opcode, offset)
````

**BC_REPORT** appends a string to the error log.

````
def bytecode_report(opcode, offset, more):
    if precheck([TYPE_STRING]):
        report(slice_to_string(stack_pop()))
    else:
        abort_run(opcode, offset)
````

**BC\_VM\_NAMES** constructs a slice containing strings for the names of each
word in the dictionary.

````
def bytecode_vm_names(opcode, offset, more):
    s = request_slice()
    i = 0
    for word in dictionary_names():
        value = string_to_slice(word)
        store(value, s, i, TYPE_STRING)
        i = i + 1
    stack_push(s, TYPE_POINTER)
````

**BC\_VM\_SLICES** constructs a slice containing pointers to the slice of each
word in the dictionary.

````
def bytecode_vm_slices(opcode, offset, more):
    s = request_slice()
    i = 0
    for ptr in dictionary_slices():
        store(ptr, s, i, TYPE_POINTER)
        i = i + 1
    stack_push(s, TYPE_POINTER)
````

And now we have a bunch of byte codes for mathmatic functions. I'm hoping to
eventually have Parable code for these, though byte coded variants are likely
to remain much faster.

````
def bytecode_trig_sin(opcode, offset, more):
    if precheck([TYPE_NUMBER]):
        a = stack_pop()
        stack_push(math.sin(a), TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

````
def bytecode_trig_cos(opcode, offset, more):
    if precheck([TYPE_NUMBER]):
        a = stack_pop()
        stack_push(math.cos(a), TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

````
def bytecode_trig_tan(opcode, offset, more):
    if precheck([TYPE_NUMBER]):
        a = stack_pop()
        stack_push(math.tan(a), TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

````
def bytecode_trig_asin(opcode, offset, more):
    if precheck([TYPE_NUMBER]):
        a = stack_pop()
        stack_push(math.asin(a), TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

````
def bytecode_trig_acos(opcode, offset, more):
    if precheck([TYPE_NUMBER]):
        a = stack_pop()
        stack_push(math.acos(a), TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

````
def bytecode_trig_atan(opcode, offset, more):
    if precheck([TYPE_NUMBER]):
        a = stack_pop()
        stack_push(math.atan(a), TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

````
def bytecode_trig_atan2(opcode, offset, more):
    if precheck([TYPE_NUMBER, TYPE_NUMBER]):
        a = stack_pop()
        b = stack_pop()
        stack_push(math.atan2(b, a), TYPE_NUMBER)
    else:
        abort_run(opcode, offset)
````

And then a final couple of byte codes for intropsection.

**BC\_VM\_MEM\_MAP** constructs a slice containing a copy of the internal
memory map and pushes a pointer to this to the stack.

````
def bytecode_vm_mem_map(opcode, offset, more):
    s = request_slice()
    i = 0
    for a in memory_map:
        store(a, s, i, TYPE_NUMBER)
        i = i + 1
    stack_push(s, TYPE_POINTER)
````

**BC\_VM\_MEM\_SIZES** constructs a slice containing the length of each slice
and pushes a pointer to this to the stack.

````
def bytecode_vm_mem_sizes(opcode, offset, more):
    s = request_slice()
    i = 0
    for a in memory_size:
        store(a, s, i, TYPE_NUMBER)
        i = i + 1
    stack_push(s, TYPE_POINTER)
````

**BC\_VM\_MEM\_ALLOC** allocates a slice and populates it the slice
numbers for each allocated slice.

````
def bytecode_vm_mem_alloc(opcode, offset, more):
    s = request_slice()
    i = 0
    n = 0
    while i < len(memory_map):
        if memory_map[i] == 1:
            store(i, s, n, TYPE_POINTER)
            n = n + 1
        i = i + 1
    stack_push(s, TYPE_POINTER)
````

Now that all of the byte codes are implemented, we construct a map of byte
code numbers to their implementations. This will be used by
**interpret()** to call the handlers.

````
bytecodes = {
    BC_NOP:            bytecode_nop,
    BC_SET_TYPE:       bytecode_set_type,
    BC_GET_TYPE:       bytecode_get_type,
    BC_ADD:            bytecode_add,
    BC_SUBTRACT:       bytecode_subtract,
    BC_MULTIPLY:       bytecode_multiply,
    BC_DIVIDE:         bytecode_divide,
    BC_REMAINDER:      bytecode_remainder,
    BC_POW:            bytecode_pow,
    BC_LOGN:           bytecode_logn,
    BC_BITWISE_SHIFT:  bytecode_bitwise_shift,
    BC_BITWISE_AND:    bytecode_bitwise_and,
    BC_BITWISE_OR:     bytecode_bitwise_or,
    BC_BITWISE_XOR:    bytecode_bitwise_xor,
    BC_RANDOM:         bytecode_random,
    BC_SQRT:           bytecode_sqrt,
    BC_COMPARE_LT:     bytecode_compare_lt,
    BC_COMPARE_GT:     bytecode_compare_gt,
    BC_COMPARE_LTEQ:   bytecode_compare_lteq,
    BC_COMPARE_GTEQ:   bytecode_compare_gteq,
    BC_COMPARE_EQ:     bytecode_compare_eq,
    BC_COMPARE_NEQ:    bytecode_compare_neq,
    BC_FLOW_IF:        bytecode_flow_if,
    BC_FLOW_WHILE:     bytecode_flow_while,
    BC_FLOW_UNTIL:     bytecode_flow_until,
    BC_FLOW_TIMES:     bytecode_flow_times,
    BC_FLOW_CALL:      bytecode_flow_call,
    BC_FLOW_DIP:       bytecode_flow_dip,
    BC_FLOW_SIP:       bytecode_flow_sip,
    BC_FLOW_BI:        bytecode_flow_bi,
    BC_FLOW_TRI:       bytecode_flow_tri,
    BC_FLOW_ABORT:     bytecode_flow_abort,
    BC_MEM_COPY:       bytecode_mem_copy,
    BC_MEM_FETCH:      bytecode_mem_fetch,
    BC_MEM_STORE:      bytecode_mem_store,
    BC_MEM_REQUEST:    bytecode_mem_request,
    BC_MEM_RELEASE:    bytecode_mem_release,
    BC_MEM_COLLECT:    bytecode_mem_collect,
    BC_MEM_GET_LAST:   bytecode_mem_get_last,
    BC_MEM_SET_LAST:   bytecode_mem_set_last,
    BC_MEM_SET_TYPE:   bytecode_mem_set_type,
    BC_MEM_GET_TYPE:   bytecode_mem_get_type,
    BC_STACK_DUP:      bytecode_stack_dup,
    BC_STACK_DROP:     bytecode_stack_drop,
    BC_STACK_SWAP:     bytecode_stack_swap,
    BC_STACK_DEPTH:    bytecode_stack_depth,
    BC_QUOTE_NAME:     bytecode_quote_name,
    BC_FUNCTION_HIDE:  bytecode_function_hide,
    BC_STRING_SEEK:    bytecode_string_seek,
    BC_SLICE_SUBSLICE: bytecode_slice_subslice,
    BC_STRING_NUMERIC: bytecode_string_numeric,
    BC_SLICE_REVERSE:  bytecode_slice_reverse,
    BC_TO_LOWER:       bytecode_to_lower,
    BC_TO_UPPER:       bytecode_to_upper,
    BC_REPORT:         bytecode_report,
    BC_VM_NAMES:       bytecode_vm_names,
    BC_VM_SLICES:      bytecode_vm_slices,
    BC_TRIG_SIN:       bytecode_trig_sin,
    BC_TRIG_COS:       bytecode_trig_cos,
    BC_TRIG_TAN:       bytecode_trig_tan,
    BC_TRIG_ASIN:      bytecode_trig_asin,
    BC_TRIG_ACOS:      bytecode_trig_acos,
    BC_TRIG_ATAN:      bytecode_trig_atan,
    BC_TRIG_ATAN2:     bytecode_trig_atan2,
    BC_VM_MEM_MAP:     bytecode_vm_mem_map,
    BC_VM_MEM_SIZES:   bytecode_vm_mem_sizes,
    BC_VM_MEM_ALLOC:   bytecode_vm_mem_alloc,
}
````

### Error Log

Errors are stored in an array, with a couple of helper functions to record
and clear them.

The interface layer should provide access to the the log (displaying when
appropriate).

````
errors = []


def clear_errors():
    """remove all errors from the error log"""
    global errors
    errors = []


def report(text):
    """report an error"""
    global errors
    errors.append(text)
````


### The Byte Code Interpreter

This is the heart of the virtual machine: it's responsible for actually
running the code stored in a slice.

````
current_slice = 0           # This is set by interpret() to the slice being run
                            # It's used for error reports, and as a guard to
                            # prevent garbage collection of a slice being run.
````

The **interpret()** function handles:

* pushing values to the stack (based on stored type)
* invoking the handler for each byte code
* sets / clears the **current_slice** variable

````
def interpret(slice, more=None):
    """Interpret the byte codes contained in a slice."""
    global current_slice
    global should_abort
    offset = 0
    size = get_last_index(int(slice))
    if current_slice == 0:
        current_slice = slice
    while offset <= size and should_abort is not True:
        opcode, optype = fetch(slice, offset)
        if optype != TYPE_BYTECODE:
            stack_push(opcode, optype)
            if optype == TYPE_REMARK:
                stack_pop()
            if optype == TYPE_FUNCALL:
                interpret(stack_pop(), more)
        else:
            if math.isnan(opcode):
                opcode == BC_NOP
            else:
                opcode = int(opcode)
            if opcode in bytecodes:
                bytecodes[opcode](opcode, offset, more)
            if more is not None:
                offset = more(slice, offset, opcode)
        offset += 1
    if should_abort:
        if pointer_to_name(slice) == '':
            report('BT: &{0}\t#{1}'.format(slice, offset - 1))
        else:
            report('BT: &{0}\t#{1}\t{2}'.format(slice, offset - 1, pointer_to_name(slice)))
    current_slice = 0
````

### Data Stack

The data stack holds all non-permanent items. It's a basic, Forth-style
last-in, first-out (LIFO) model. But it does track types as well as the
raw values.

````
stack = []
````

Until the 2016.04 release, Parable interfaces have had to construct code
to render the stack items in a human readable format. The current release
provides a few functions for doing this and generating a list of the
parsed values.

This isn't essential, and not all interfaces will use it, but I've found
it handy to have. If using on a constrained memory target it might be
worth removing this bit unless you need it.

````
def format_item(prefix, value):
    return  prefix + str(value)


def parsed_item(i):
    r = ""
    tos = stack_value_for(i)
    type = stack_type_for(i)
    if type == TYPE_NUMBER:
        r = format_item('#', tos)
    elif type == TYPE_BYTECODE:
        r = format_item('`', tos)
    elif type == TYPE_CHARACTER:
        r = format_item('$', chr(tos))
    elif type == TYPE_STRING:
        r = format_item('\'', slice_to_string(tos) + '\'')
    elif type == TYPE_POINTER:
        r = format_item('&', tos)
    elif type == TYPE_FUNCALL:
        r = format_item('|', tos)
    elif type == TYPE_REMARK:
        r = format_item('"', slice_to_string(tos) + '"')
    elif type == TYPE_FLAG:
        if tos == -1:
            r = "true"
        elif tos == 0:
            r = "false"
        else:
            r = "malformed flag"
    else:
        r = "unmatched type on the stack"
    return r


def parsed_stack():
    r = []
    for i in range(0, stack_depth()):
        r.append(parsed_item(i))
    return r
````

Ok, so with that aside taken care of, here's the actual code that
implements the data stack.

First up: some stuff to separate values and types:

````
def stack_values():
    r = []
    for w in stack:
        r.append(w[0])
    return r


def stack_types():
    r = []
    for w in stack:
        r.append(w[1])
    return r
````

Then on to wrappers to aid in readability:

````
def stack_depth():
    return len(stack)


def stack_type_for(d):
    return stack[d][1]


def stack_value_for(d):
    return stack[d][0]
````

So now we enter the meat of the stack implementation. The next few are all
pretty simple:

````
def stack_clear():
    """remove all values from the stack"""
    global stack
    stack = []


def stack_push(value, type):
    """push a value to the stack"""
    global stack
    stack.append((value, type))


def stack_drop():
    """remove a value from the stack"""
    global stack
    stack.pop()
````

And then for something longer. The function to remove a value from the stack
has is written to be fairly flexible in that it supports both LIFO (the model
used by Parable) and optionally FIFO.

(I have plans to eventually experiment with FIFO in the future.)

````
def stack_pop(type = False, fifo = False):
    """remove and return a value from the stack"""
    global stack
    if fifo:
        if type:
            return stack.pop(0)
        else:
            return stack.pop(0)[0]
    else:
        if type:
            return stack.pop()
        else:
            return stack.pop()[0]
````

More simple functions follow.

I'm not sure that I like the naming of **tos()**; it's likely to change in the
future.

````
def tos():
    """return a pointer to the top element in the stack"""
    return stack_depth() - 1


def stack_type():
    """return the type identifier for the top item on the stack"""
    return stack_type_for(tos())


def stack_swap():
    """switch the positions of the top items on the stack"""
    av, at = stack_pop(type = True)
    bv, bt = stack_pop(type = True)
    stack_push(av, at)
    stack_push(bv, bt)


def stack_dup():
    """duplicate the top item on the stack"""
    """if the value is a string, makes a copy of it"""
    av, at = stack_pop(type = True)
    stack_push(av, at)
    if at == TYPE_STRING:
        s = request_slice()
        copy_slice(av, s)
        stack_push(s, at)
    else:
        stack_push(av, at)
````

The most complicated bit of code in the stack is the
**stack\_change\_type()** function. This is responsible for a lot of what
makes Parable useful. Each conversion mode has a separate handler.

| Short    | Means     |
| -------- | --------- |
| `B`      | Bytecode  |
| `N`      | Number    |
| `C`      | Character |
| `S`      | String    |
| `R`      | Remark    |
| `P`      | Pointer   |
| `F`      | Flag      |
| `X`      | Funcall   |

With that, here's a quick reference for converting between types:

| Original | Converts To |
| -------- | ----------- |
| `B`      | ` NC     `  |
| `N`      | `B CSRPFX`  |
| `C`      | ` N SPPFX`  |
| `S`      | ` NC RPF `  |
| `R`      | `   S P  `  |
| `P`      | ` N SR  X`  |
| `F`      | ` N S    `  |
| `X`      | ` N   P  `  |

````
def convert_to_bytecode(original):
    global stack
    if original == TYPE_NUMBER:
        a = stack_pop()
        stack_push(a, TYPE_BYTECODE)


def convert_to_number(original):
    global stack
    if original == TYPE_STRING:
        a = stack_pop()
        if is_number(slice_to_string(a)):
            stack_push(float(slice_to_string(a)), TYPE_NUMBER)
        else:
            stack_push(float('nan'), TYPE_NUMBER)
    else:
        a = stack_pop()
        stack_push(a, TYPE_NUMBER)


def convert_to_string(original):
    global stack
    if original == TYPE_NUMBER:
        stack_push(string_to_slice(str(stack_pop())), TYPE_STRING)
    elif original == TYPE_CHARACTER:
        v = stack_pop()
        if (v >= 32 and v <= 128) or v == 10 or v == 13:
            stack_push(string_to_slice(str(chr(v))), TYPE_STRING)
        else:
            stack_push(string_to_slice(str(chr(0))), TYPE_STRING)
    elif original == TYPE_FLAG:
        s = stack_pop()
        if s == -1:
            stack_push(string_to_slice('true'), TYPE_STRING)
        elif s == 0:
            stack_push(string_to_slice('false'), TYPE_STRING)
        else:
            stack_push(string_to_slice('malformed flag'), TYPE_STRING)
    elif original == TYPE_POINTER or original == TYPE_REMARK:
        a = stack_pop()
        stack_push(a, TYPE_STRING)
    else:
        return 0


def convert_to_character(original):
    global stack
    if original == TYPE_STRING:
        s = slice_to_string(stack_pop())
        stack_push(ord(s[0].encode('utf-8')), TYPE_CHARACTER)
    else:
        s = stack_pop()
        stack_push(int(s), TYPE_CHARACTER)


def convert_to_pointer(original):
    global stack
    a = stack_pop()
    stack_push(a, TYPE_POINTER)


def convert_to_flag(original):
    global stack
    if original == TYPE_STRING:
        s = slice_to_string(stack_pop())
        if s == 'true':
            stack_push(-1, TYPE_FLAG)
        elif s == 'false':
            stack_push(0, TYPE_FLAG)
        else:
            stack_push(1, TYPE_FLAG)
    else:
        s = stack_pop()
        stack_push(s, TYPE_FLAG)


def convert_to_funcall(original):
    global stack
    if original == TYPE_NUMBER or original == TYPE_POINTER:
        a = stack_pop()
        stack_push(a, TYPE_FUNCALL)
````

With the type-specific conversions above, **stack_change_type()** just needs
to choose which one to invoke.

**Future: use a dispatch table instead of the multiple if blocks**

````
def stack_change_type(desired):
    """convert the type of an item on the stack to a different type"""
    global stack
    original = stack_type()
    if desired == TYPE_BYTECODE:
        convert_to_bytecode(original)
    elif desired == TYPE_NUMBER:
        convert_to_number(original)
    elif desired == TYPE_STRING:
        convert_to_string(original)
    elif desired == TYPE_CHARACTER:
        convert_to_character(original)
    elif desired == TYPE_POINTER:
        convert_to_pointer(original)
    elif desired == TYPE_FLAG:
        convert_to_flag(original)
    elif desired == TYPE_FUNCALL:
        convert_to_funcall(original)
    else:
        a = stack_pop()
        stack_push(a, desired)
````

### The Dictionary

Like Forth, Parable uses a dictionary to map names to pointers. Ours
consists of a list of tuples. Each tuple has a name and corresponding
slice number.

(We also maintain a second list with the slices that used to be named but
have since been hidden by the user.)

````
dictionary_warnings = False     # Used to trigger a warning if a name is redefined
dictionary_hidden_slices = []   # Holds a list of slices that previously had names
dictionary = []
````

Ok, first up are some quick helpers to return a list of the names and a
separate list of the slice numbers they correspond to.

````
def dictionary_names():
    r = []
    for w in dictionary:
        r.append(w[0])
    return r


def dictionary_slices():
    r = []
    for w in dictionary:
        r.append(w[1])
    return r
````

The **in_dictionary()** function looks for a name in the dictionary and
returns a flag inidicating whether or not it was found.

````
def in_dictionary(s):
    for w in dictionary_names():
        if w == s:
            return True
    return False
````

This function returns the slice a name corresponds to.

````
def dict_entry(name):
    for i in dictionary:
        if i[0] == name:
            return i[1]
    return -1
````

And this one returns the index of a dictionary entry.

````
def dict_index(name):
    n = 0
    for i in dictionary:
        if i[0] == name:
            return n
        n = n + 1
    return -1
````

Use **lookup_pointer()** to get the slice a word corresponds to or -1 if not
found. This is just a bit of a wrapper over **in_dictionary()** and
**dict_entry()**.

````
def lookup_pointer(name):
    if in_dictionary(name) is False:
        return -1
    else:
        return dict_entry(name)
````

This next function adds a name to the dictionary. Typically this is pretty
easy: just append the tuple to the dictionary list. But sometimes an
existing name is passed. In this case we need to copy the contents of the
passed slice in place of the original one.

````
def add_definition(name, slice):
    global dictionary
    if in_dictionary(name) is False:
        dictionary.append((name, slice))
    else:
        if dictionary_warnings:
            report('W10: {0} redefined'.format(name))
        target = lookup_pointer(name)
        copy_slice(slice, target)
````

Removal of a name is next. This is pretty easy: we copy the slice number
to the list of hidden slices, then delete it from the list of tuples.

````
def remove_name(name):
    global dictionary, dictionary_hidden_slices
    if in_dictionary(name) is not False:
        i = dict_index(name)
        if not dictionary[i][1] in dictionary_hidden_slices:
            dictionary_hidden_slices.append(dictionary[i][1])
        del dictionary[i]
````

This next function maps a pointer to its corresponding name. It'll return the
first name found for a pointer. (You can have multiple names pointing to the
same slice).

````
def pointer_to_name(ptr):
    """given a parable pointer, return the corresponding name, or"""
    """an empty string"""
    for i in dictionary:
        if i[1] == ptr:
            return i[0]
    return ''
````

### Memory

Parable has a segmented memory model. Memory is divided into regions
called slices. Each slice stores values, and has a shadow slice which
stores the associated types.

At present this is implemented using multiple arrays.

*It is intended that this be replaced with something simpler.*

````
memory_values = []    # Contains the slices for storing data
memory_types = []     # Contains the slices for storing types
memory_map = []       # A simple structure for indicating which slices are in use
memory_size = []      # A simple structure for indicating the number of items
                      # in each slice
````

**request_slice()** allocates a new slice and returns the slice number. It
is actually pretty involved. The full process is:

* scan the memory map for a non allocated slice
* if one is found, mark it as allocated, then return the slice number
* if one isn't found and the stack is empty, perform a garbage collection
* then, add **PREALLOCATE** number of slices to the map and other arrays
* and return a pointer to the first of these new slices

````
def request_slice():
    """request a new memory slice"""
    global memory_values, memory_types, memory_map, memory_size
    i = 0
    while i < len(memory_map):
        if memory_map[i] == 0:
            memory_map[i] = 1
            memory_values[i] = [0]
            memory_types[i] = [0]
            memory_size[i] = 0
            return i
        else:
            i += 1
    if stack_depth() == 0:
        collect_garbage()
    x = 0
    while x < PREALLOCATE:
        memory_map.append(0)
        memory_values.append([0])
        memory_types.append([0])
        memory_size.append(0)
        x = x + 1
    memory_map[i] = 1
    memory_values[i] = [0]
    memory_types[i] = [0]
    memory_size[i] = 0
    return i
````

Next up is **release_slice()**. This is pretty straightforward: mark the slice as free, and store empty values in the appropriate other arrays.

````
def release_slice(slice):
    """release a slice. the slice should not be used after this is done"""
    global memory_map, memory_size, memory_values, memory_types
    slice = int(slice)
    memory_map[slice] = 0
    memory_size[slice] = 0
    memory_values[slice] = [0]
    memory_types[slice] = [0]
````

````
def copy_slice(source, dest):
    """copy the contents of one slice to another"""
    global memory_size
    i = 0
    l = memory_size[int(source)]
    while i <= l:
        v, t = fetch(int(source), i)
        store(v, int(dest), i, t)
        i += 1
    memory_size[int(dest)] = memory_size[int(source)]


def prepare_slices():
    """prepare the initial set of slices for use"""
    global memory_values, memory_types, memory_map, memory_size, INITIAL_SLICES
    memory_map = [0 for x in range(INITIAL_SLICES)]
    memory_values = [0 for x in range(INITIAL_SLICES)]
    memory_types = [0 for x in range(INITIAL_SLICES)]
    memory_size = [0 for x in range(INITIAL_SLICES)]


def fetch(slice, offset):
    """return a stored value and type"""
    if get_last_index(slice) < abs(offset):
        set_slice_last_index(slice, abs(offset))
    return memory_values[int(slice)][int(offset)], memory_types[int(slice)][int(offset)]


def store_type(slice, offset, type):
    global memory_types
    if get_last_index(slice) < abs(offset):
        set_slice_last_index(slice, abs(offset))
    memory_types[int(slice)][int(offset)] = type


def store(value, slice, offset, type=100):
    """store a value into a slice"""
    global memory_values, memory_types
    if get_last_index(slice) < abs(offset):
        set_slice_last_index(slice, abs(offset))
    memory_values[int(slice)][int(offset)] = value
    memory_types[int(slice)][int(offset)] = type


def get_last_index(slice):
    """get the length of a slice"""
    return memory_size[int(slice)]


def set_slice_last_index(slice, size):
    """set the length of a slice"""
    global memory_values, memory_types, memory_size
    old_size = memory_size[int(slice)]
    grow_by = size - old_size
    if grow_by > 0:
        memory_values[int(slice)].extend(list(range(int(grow_by))))
        memory_types[int(slice)].extend(list(range(int(grow_by))))
    if grow_by < 0:
        while grow_by < 0:
            grow_by = grow_by + 1
            del memory_values[int(slice)][-1]
            del memory_types[int(slice)][-1]
    memory_size[int(slice)] = size
````

Strings in Parable are stored as a series of characters within a slice. This
function converts a Python string into a Parable string.

````
def string_to_slice(string):
    """convert a string into a slice"""
    s = request_slice()
    if string != '':
        i = 0
        for char in list(string):
            store(ord(char.encode('utf-8')), s, i, TYPE_CHARACTER)
            i += 1
    else:
        set_slice_last_index(s, -1)
    return s
````

It's also necessary to translate Parable strings to Python strings. The
following function handles this.

````
def slice_to_string(slice):
    """convert a slice into a string"""
    return ''.join(map(lambda x: chr(int(x)), memory_values[slice]))
````

### Garbage Collection

Parable's memory model is flexible, but prone to wasting memory due to the
existance of short-lived allocations. This isn't generally a problem, but
it's useful to be able to reclaim memory if/when the memory space begins
getting restricted.

The solution to this is the garbage collector. It's a piece of code that
scans memory for slices that aren't referenced, and reclaims them.

The first piece is a little something to determine if the value is a pointer. Parable considers pointers to be of types **TYPE_POINTER**,
**TYPE_STRING**, **TYPE_REMARK**, **TYPE_FUNCALL**.

````
def is_pointer(type):
    flag = False
    if type == TYPE_POINTER or \
       type == TYPE_STRING or \
       type == TYPE_REMARK or \
       type == TYPE_FUNCALL:
        flag = True
    else:
        flag = False
    return flag
````

Next is a function to scan a slice, returning a list of all pointers it
contains.

````
def scan_slice(s):
    ptrs = []
    i = get_last_index(s)
    while i >= 0:
        try:
            v, t = fetch(s, i)
            v = int(v)
        except:
            t = 0
            v = 0
        if is_pointer(t):
            if not v in ptrs:
                ptrs.append(v)
        i = i - 1
    return ptrs
````

We then have a function which uses this repeatedly, scanning a slice for
pointers, then scanning each pointer in turn for more pointers. This
repeats until the final list stops growing.

*Note: we used to have this as a recursive approach, but that proved
problematic with larger programs. This is a little less elegant, but
works consistently.*

````
def find_references(s):
    ptrs = scan_slice(s)
    l = len(ptrs)
    ln = 0
    while l != ln:
        l = len(ptrs)
        for x in ptrs:
            new = scan_slice(x)
            for n in new:
                if not n in ptrs:
                    ptrs.append(n)
        ln = len(ptrs)
    return ptrs
````

Our next routine is intended to collect a master list of all references.
We have to pull values from several sources: the stack, the dictionary,
named items that have been hidden, and the current slice.

````
def seek_all_references():
    """return a list of all references in all named slices and stack items"""
    global dictionary, stack, types, current_slice
    sources = []

    # Named items
    for s in dictionary_slices():
        if not s in sources:
            sources.append(s)

    # Previously named but now hidden items
    for s in dictionary_hidden_slices:
        if not s in sources:
            sources.append(s)

    # The current slice
    if not current_slice in sources:
        sources.append(current_slice)

    # Strings, comments, pointers, function calls on the stack
    i = tos()
    while i >= 0:
        if is_pointer(stack_type_for(i)):
            sources.append(stack_value_for(i))
        i = i - 1

    refs = sources
    for s in sources:
        for x in find_references(s):
            if not x in refs:
                refs.append(x)

    return refs
````

And finally tie it all together. This collects all references and then
releases any slices not in the list.

````
def collect_garbage():
    """scan memory, and collect unused slices"""
    i = 0
    refs = seek_all_references()
    while i < INITIAL_SLICES:
        if not i in refs and memory_map[i] == 1:
            release_slice(i)
        i = i + 1
````

### The Compiler

This is the core of the user-facing language. It takes a string, breaks it
into tokens, then lays down code based on the prefix each token has.

| Prefix | Token is...    |
| ------ | -------------- |
|  #     |  Numbers       |
|   $    | Characters     |
|   &    | Pointers       |
|   `    | Bytecodes      |
|   '    | Strings        |
|   "    | Comments       |
|   \|   | Function Calls |

To aid in readability, the compiler also allows for use of number and
functions calls without the prefixes in most cases.

The bytecode forms are kept simple:

| type         | stored       | type          |
| ------------ | ------------ | ------------- |
| Functions    | pointer      | function call |
| Strings      | pointer      | string        |
| Numbers      | VALUE        | number        |
| Characters   | ASCII_VALUE  | character     |
| Pointers     | pointer      | pointer       |
| Bytecodes    | bytecode     | bytecode      |
| Comments     | pointer      | comment       |

The compiler recognizes two special prefixes: @ and !

| Example | Equivalent to... |
| ------- | ---------------- |
| @Base   | &Base #1 fetch   |
| !Base   | &Base #1 store   |

There are two additional implicit pieces of syntax: [ and ]. These form
the basis of *quotations*. A quotation is an anonymous function. **[**
marks the start of a quotation and **]** ends one.

Each prefix has a function to handle it. These functions (which start with
**compile_**) each take a parameter, a slice number, and the current
offset. They are responsible for laying down the appropriate byte codes
for their corresponding data. They each return the new offset into the
slice.

*Note: there is some redundancy here. We could merge some of them, but
prefer keeping them separate to better map them to the individual
prefixes.*

First up are strings and remarks. Since these can contain spaces, there is
also a **parse_string** function which returns a new index into the token
stream and the complete string.

````
def compile_string(string, slice, offset):
    store(string_to_slice(string), slice, offset, TYPE_STRING)
    offset += 1
    return offset


def compile_comment(string, slice, offset):
    store(string_to_slice(string), slice, offset, TYPE_REMARK)
    offset += 1
    return offset


def parse_string(tokens, i, count, delimiter):
    s = ""
    a = tokens[i].endswith(delimiter)
    b = tokens[i] != delimiter
    c = tokens[i].endswith("\\" + delimiter)
    if a and b and not c:
        s = tokens[i]
    else:
        j = i + 1
        s = tokens[i]
        while j < count:
            s += " "
            s += tokens[j]
            a = tokens[j].endswith(delimiter)
            b = tokens[j].endswith("\\" + delimiter)
            if a and not b:
                i = j
                j = count
            j += 1
    final = s.replace("\\n", "\n").replace("\\t", "\t")
    return i, final.replace("\\", "")
````

Now on to some simpler types: bytecodes, characters, and numbers.

````
def compile_character(character, slice, offset):
    store(character, slice, offset, TYPE_CHARACTER)
    offset += 1
    return offset


def compile_number(number, slice, offset):
    if is_number(number):
        store(float(number), slice, offset, TYPE_NUMBER)
    else:
        store(float('nan'), slice, offset, TYPE_NUMBER)
        report("E03: Compile Error: Unable to convert {0} to a number".format(number))
    offset += 1
    return offset


def compile_bytecode(bytecode, slice, offset):
    store(float(bytecode), slice, offset, TYPE_BYTECODE)
    offset += 1
    return offset
````

Pointers are a little more complex. A pointer can either be a name or a
slice number, so we have to check for both. If it's not a number or a
name, this will report an error.

````
def compile_pointer(name, slice, offset):
    if is_number(name):
        store(float(name), slice, offset, TYPE_POINTER)
    else:
        if lookup_pointer(name) != -1:
            store(lookup_pointer(name), slice, offset, TYPE_POINTER)
        else:
            store(0, slice, offset, TYPE_POINTER)
            report('E03: Compile Error: Unable to map {0} to a pointer'.format(name))
    offset += 1
    return offset
````

Function calls. There are two cases here: name only, with no prefix, and
calls that have a **|** prefix. Calls with a prefix can be either named or
numbered, so like pointers, we have to handle both forms.

````
def compile_function_call(name, slice, offset):
    if lookup_pointer(name) != -1:
        store(lookup_pointer(name), slice, offset, TYPE_FUNCALL)
        offset += 1
    else:
        if name != "":
           report('E03: Compile Error: Unable to map `{0}` to a pointer'.format(name))
    return offset


def compile_function_call_prefixed(name, slice, offset):
    if lookup_pointer(name) != -1:
        store(lookup_pointer(name), slice, offset, TYPE_FUNCALL)
        offset += 1
    else:
        if is_number(name):
            store(int(name), slice, offset, TYPE_FUNCALL)
            offset += 1
        else:
           report('E03: Compile Error: Unable to map `{0}` to a pointer'.format(name))
    return offset
````

And that wraps up the individual prefix handlers. All that's left is to
tie it all together. Oh, and handle the **[** and **]** for quotations and
the **!** and **@** prefixes for variable access shorthand.

*Note: this really should be cleaned up further. It'd be beneficial to use
a table for mapping the prefixes to their handlers instead of the nasty
multipart conditional block used here.*

````
def compile(str, slice=None):
    global should_abort
    should_abort = False
    if slice == None:  slice = request_slice()
    prefixes = { '`', '#', '$', '&', '\'', '"', '@', '!', '|' }
    nest = []
    tokens = tokenize(str)
    offset = 0
    if tokens == []:
        store(BC_NOP, slice, offset, TYPE_BYTECODE)
        return slice
    for token in tokens:
        prefix = token[:1]
        if prefix in prefixes:
            current = token[1:]
        else:
            current = token
        if prefix == '"':
            offset = compile_comment(current[:-1], slice, offset)
        elif prefix == "'":
            offset = compile_string(current[:-1], slice, offset)
        elif prefix == "$":
            v = ord(current[0].encode('utf-8'))
            offset = compile_character(v, slice, offset)
        elif prefix == "&":
            offset = compile_pointer(current, slice, offset)
        elif prefix == "#":
            offset = compile_number(current, slice, offset)
        elif prefix == "`":
            offset = compile_bytecode(current, slice, offset)
        elif prefix == "@":
            offset = compile_pointer(current, slice, offset)
            offset = compile_number(1, slice, offset)
            offset = compile_bytecode(BC_MEM_FETCH, slice, offset)
        elif prefix == "!":
            offset = compile_pointer(current, slice, offset)
            offset = compile_number(1, slice, offset)
            offset = compile_bytecode(BC_MEM_STORE, slice, offset)
        elif prefix == "|":
            offset = compile_function_call_prefixed(current, slice, offset)
        elif current == "[":
            nest.append((slice, offset))
            slice = request_slice()
            offset = 0
        elif current == "]":
            if len(nest) == 0:
                report('E03: Compile Error - quotations not balanced')
                return slice
            else:
                old = slice
                if offset == 0:
                    store(BC_NOP, slice, offset, TYPE_BYTECODE)
                slice, offset = nest.pop()
                store(old, slice, offset, TYPE_POINTER)
                offset += 1
        else:
            if is_number(current):
                offset = compile_number(current, slice, offset)
            else:
                offset = compile_function_call(current, slice, offset)
        if offset == 0:
            store(BC_NOP, slice, offset, TYPE_BYTECODE)
    if len(nest) != 0:
        report('E03: Compile Error - quotations not balanced')
    return slice
````


### Final Bits

A few things to help get the initial environment up and running.

````
def parse_bootstrap(f):
    """compile the bootstrap package it into memory"""
    for line in condense_lines(f):
        if len(line) > 0: interpret(compile(line))
````

Some parts of the language (prefixes, brackets) are understood as part of
the parser. but one important bit, the ability to give a name to an item,
is not. this routine sets up an initial dictionary containing the **define**
function. with this loaded, all else can be built.

````
def prepare_dictionary():
    """setup the initial dictionary"""
    add_definition(':', compile('"ps-" `{0} "Attach a name to a pointer"'.format(BC_QUOTE_NAME)))
````
