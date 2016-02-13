# parable
# Copyright (c) 2012-2016, Charles Childers
# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
# coding: utf-8

#
# Dependencies
#
import math
import random
import sys

#
# Memory Configuration
#

MAX_SLICES = 100000

#
# Constants for data types
#

TYPE_NUMBER = 100
TYPE_STRING = 200
TYPE_CHARACTER = 300
TYPE_POINTER = 400
TYPE_FLAG = 500
TYPE_BYTECODE = 600
TYPE_REMARK = 700
TYPE_FUNCTION_CALL = 800

#
# Constants for byte codes
# These are loosely grouped by type
#

BC_SET_TYPE = 100
BC_GET_TYPE = 101
BC_ADD = 200
BC_SUBTRACT = 201
BC_MULTIPLY = 202
BC_DIVIDE = 203
BC_REMAINDER = 204
BC_FLOOR = 205
BC_POW = 206
BC_LOG = 207
BC_LOG10 = 208
BC_LOGN = 209
BC_BITWISE_SHIFT = 210
BC_BITWISE_AND = 211
BC_BITWISE_OR = 212
BC_BITWISE_XOR = 213
BC_RANDOM = 214
BC_SQRT = 215
BC_ROUND = 216
BC_COMPARE_LT = 220
BC_COMPARE_GT = 221
BC_COMPARE_LTEQ = 222
BC_COMPARE_GTEQ = 223
BC_COMPARE_EQ = 224
BC_COMPARE_NEQ = 225
BC_FLOW_IF = 300
BC_FLOW_WHILE = 301
BC_FLOW_UNTIL = 302
BC_FLOW_TIMES = 303
BC_FLOW_CALL = 304
BC_FLOW_CALL_F = 305
BC_FLOW_DIP = 306
BC_FLOW_SIP = 307
BC_FLOW_BI = 308
BC_FLOW_TRI = 309
BC_FLOW_ABORT = 398
BC_FLOW_RETURN = 399
BC_MEM_COPY = 400
BC_MEM_FETCH = 401
BC_MEM_STORE = 402
BC_MEM_REQUEST = 403
BC_MEM_RELEASE = 404
BC_MEM_COLLECT = 405
BC_MEM_GET_LAST = 406
BC_MEM_SET_LAST = 407
BC_MEM_SET_TYPE = 408
BC_MEM_GET_TYPE = 409
BC_STACK_DUP = 500
BC_STACK_DROP = 501
BC_STACK_SWAP = 502
BC_STACK_DEPTH = 503
BC_QUOTE_NAME = 600
BC_FUNCTION_EXISTS = 601
BC_FUNCTION_LOOKUP = 602
BC_FUNCTION_HIDE = 603
BC_FUNCTION_NAME = 604
BC_STRING_SEEK = 700
BC_SLICE_SUBSLICE = 701
BC_STRING_NUMERIC = 702
BC_SLICE_REVERSE = 703
BC_TO_LOWER = 800
BC_TO_UPPER = 801
BC_REPORT = 900
BC_TRIG_SIN = 1000
BC_TRIG_COS = 1001
BC_TRIG_TAN = 1002
BC_TRIG_ASIN = 1003
BC_TRIG_ACOS = 1004
BC_TRIG_ATAN = 1005
BC_TRIG_ATAN2 = 1006


#
# Support code
#

def is_number(s):
    """return True if s is a number, or False otherwise"""
    try:
        float(s)
        return True
    except ValueError:
        return False


def condense_lines(code):
    """Take an array of code, join lines ending with a \, and return"""
    """the new array"""
    m = len(code)
    s = ''
    r = []
    i = 0
    c = 0
    while i < m:
        if code[i].endswith(' \\\n'):
            s = s + ' ' + code[i][:-2].strip()
            c = 1
        else:
            c = 0
            s = s + ' ' + code[i]
        if c == 0:
            if s != '' and s != ' \n':
                r.append(s.strip())
            s = ''
        i = i + 1
    return r


#
# logging of errors
#
# errors are stored in an array, with helper functions to
# record and clear them
#

errors = []


def clear_errors():
    """remove all errors from the error log"""
    global errors
    errors = []


def report(text):
    """report an error"""
    global errors
    errors.append(text)


def check_depth(slice, offset, cells):
    """returns True if the stack has at least *cells* number of items, or"""
    """False otherwise. If False, reports an underflow error."""
    global stack
    if len(stack) < cells:
        details = 'Slice ' + str(slice) + ' Offset: ' + str(offset)
        expected = str(cells) + ' values required'
        report('E01: Stack underflow: ' + details + ': ' + expected)
        return False
    else:
        return True


#
# Byte code interpreter
#

current_slice = 0
should_abort = False


def interpret(slice, more=None):
    """Interpret the byte codes contained in a slice."""
    global current_slice
    global should_abort
    offset = 0
    size = get_last_index(int(slice))
    if current_slice == 0:
        current_slice = slice
    while offset <= size and should_abort is not True:
        opcode = fetch(slice, offset)
        optype = fetch_type(slice, offset)

        if optype != TYPE_BYTECODE:
            stack_push(opcode, optype)
            if optype == TYPE_REMARK:
                stack_pop()
            if optype == TYPE_FUNCTION_CALL:
                interpret(stack_pop(), more)
        else:
            if opcode == BC_SET_TYPE:
                if check_depth(slice, offset, 2):
                    a = stack_pop()
                    stack_change_type(a)
                else:
                    offset = size
            elif opcode == BC_GET_TYPE:
                if check_depth(slice, offset, 1):
                    stack_push(stack_type(), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_ADD:
                if check_depth(slice, offset, 2):
                    x = stack_type()
                    a = stack_pop()
                    y = stack_type()
                    b = stack_pop()
                    if x == TYPE_STRING and y == TYPE_STRING:
                        a = slice_to_string(a)
                        b = slice_to_string(b)
                        stack_push(string_to_slice(b + a), TYPE_STRING)
                    elif x == TYPE_REMARK and y == TYPE_REMARK:
                        a = slice_to_string(a)
                        b = slice_to_string(b)
                        stack_push(string_to_slice(b + a), TYPE_REMARK)
                    elif x == TYPE_POINTER and y == TYPE_POINTER:
                        c = request_slice()
                        d = get_last_index(b) + get_last_index(a) + 1
                        set_slice_last_index(c, d)
                        memory_values[c] = memory_values[b] + memory_values[a]
                        memory_types[c] = memory_types[b] + memory_types[a]
                        stack_push(c, TYPE_POINTER)
                    else:
                        stack_push(a + b, TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_SUBTRACT:
                if check_depth(slice, offset, 2):
                    a = stack_pop()
                    b = stack_pop()
                    stack_push(b - a, TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_MULTIPLY:
                if check_depth(slice, offset, 2):
                    a = stack_pop()
                    b = stack_pop()
                    stack_push(a * b, TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_DIVIDE:
                if check_depth(slice, offset, 2):
                    a = stack_pop()
                    b = stack_pop()
                    if a == 0 or b == 0:
                        stack_push(float('nan'), TYPE_NUMBER)
                        report('E04: Divide by Zero')
                    else:
                        stack_push(b / a, TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_REMAINDER:
                if check_depth(slice, offset, 2):
                    a = stack_pop()
                    b = stack_pop()
                    stack_push(b % a, TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_FLOOR:
                if check_depth(slice, offset, 1):
                    stack_push(math.floor(float(stack_pop())), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_POW:
                if check_depth(slice, offset, 2):
                    a = stack_pop()
                    b = stack_pop()
                    stack_push(math.pow(b, a), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_LOG:
                if check_depth(slice, offset, 1):
                    a = stack_pop()
                    stack_push(math.log(a), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_LOG10:
                if check_depth(slice, offset, 1):
                    a = stack_pop()
                    stack_push(math.log10(a), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_LOGN:
                if check_depth(slice, offset, 2):
                    a = stack_pop()
                    b = stack_pop()
                    stack_push(math.log(b, a), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_BITWISE_SHIFT:
                if check_depth(slice, offset, 2):
                    a = int(stack_pop())
                    b = int(stack_pop())
                    if a < 0:
                        stack_push(b << abs(a), TYPE_NUMBER)
                    else:
                        stack_push(b >> a, TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_BITWISE_AND:
                if check_depth(slice, offset, 2):
                    a = int(stack_pop())
                    b = int(stack_pop())
                    stack_push(b & a, TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_BITWISE_OR:
                if check_depth(slice, offset, 2):
                    a = int(stack_pop())
                    b = int(stack_pop())
                    stack_push(b | a, TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_BITWISE_XOR:
                if check_depth(slice, offset, 2):
                    a = int(stack_pop())
                    b = int(stack_pop())
                    stack_push(b ^ a, TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_RANDOM:
                stack_push(random.SystemRandom().random(), TYPE_NUMBER)
            elif opcode == BC_SQRT:
                if check_depth(slice, offset, 1):
                    stack_push(math.sqrt(stack_pop()), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_ROUND:
                if check_depth(slice, offset, 1):
                    stack_push(round(stack_pop()), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_COMPARE_LT:
                if check_depth(slice, offset, 2):
                    x = stack_type()
                    a = stack_pop()
                    y = stack_type()
                    b = stack_pop()
                    if x == TYPE_NUMBER and y == TYPE_NUMBER:
                        if b < a:
                            stack_push(-1, TYPE_FLAG)
                        else:
                            stack_push(0, TYPE_FLAG)
                    else:
                        offset = size
                        details = 'Slice ' + str(slice)
                        details = details + ' Offset: ' + str(offset)
                        report('E02: Type mismatch: ' + details)
                else:
                    offset = size
            elif opcode == BC_COMPARE_GT:
                if check_depth(slice, offset, 2):
                    x = stack_type()
                    a = stack_pop()
                    y = stack_type()
                    b = stack_pop()
                    if x == TYPE_NUMBER and y == TYPE_NUMBER:
                        if b > a:
                            stack_push(-1, TYPE_FLAG)
                        else:
                            stack_push(0, TYPE_FLAG)
                    else:
                        offset = size
                        details = 'Slice ' + str(slice)
                        details = details + ' Offset: ' + str(offset)
                        report('E02: Type mismatch: ' + details)
                else:
                    offset = size
            elif opcode == BC_COMPARE_LTEQ:
                if check_depth(slice, offset, 2):
                    x = stack_type()
                    a = stack_pop()
                    y = stack_type()
                    b = stack_pop()
                    if x == TYPE_NUMBER and y == TYPE_NUMBER:
                        if b <= a:
                            stack_push(-1, TYPE_FLAG)
                        else:
                            stack_push(0, TYPE_FLAG)
                    else:
                        offset = size
                        details = 'Slice ' + str(slice)
                        details = details + ' Offset: ' + str(offset)
                        report('E02: Type mismatch: ' + details)
                else:
                    offset = size
            elif opcode == BC_COMPARE_GTEQ:
                if check_depth(slice, offset, 2):
                    x = stack_type()
                    a = stack_pop()
                    y = stack_type()
                    b = stack_pop()
                    if x == TYPE_NUMBER and y == TYPE_NUMBER:
                        if b >= a:
                            stack_push(-1, TYPE_FLAG)
                        else:
                            stack_push(0, TYPE_FLAG)
                    else:
                        offset = size
                        details = 'Slice ' + str(slice)
                        details = details + ' Offset: ' + str(offset)
                        report('E02: Type mismatch: ' + details)
                else:
                    offset = size
            elif opcode == BC_COMPARE_EQ:
                if check_depth(slice, offset, 2):
                    x = stack_type()
                    a = stack_pop()
                    y = stack_type()
                    b = stack_pop()
                    if x == y and x != TYPE_STRING:
                        if b == a:
                            stack_push(-1, TYPE_FLAG)
                        else:
                            stack_push(0, TYPE_FLAG)
                    elif x == y and x == TYPE_STRING:
                        if slice_to_string(b) == slice_to_string(a):
                            stack_push(-1, TYPE_FLAG)
                        else:
                            stack_push(0, TYPE_FLAG)
                    else:
                        offset = size
                        details = 'Slice ' + str(slice)
                        details = details + ' Offset: ' + str(offset)
                        report('E02: Type mismatch: ' + details)
                else:
                    offset = size
            elif opcode == BC_COMPARE_NEQ:
                if check_depth(slice, offset, 2):
                    x = stack_type()
                    a = stack_pop()
                    y = stack_type()
                    b = stack_pop()
                    if x == y and x != TYPE_STRING:
                        if b != a:
                            stack_push(-1, TYPE_FLAG)
                        else:
                            stack_push(0, TYPE_FLAG)
                    elif x == y and x == TYPE_STRING:
                        if slice_to_string(b) != slice_to_string(a):
                            stack_push(-1, TYPE_FLAG)
                        else:
                            stack_push(0, TYPE_FLAG)
                    else:
                        offset = size
                        details = 'Slice ' + str(slice)
                        details = details + ' Offset: ' + str(offset)
                        report('E02: Type mismatch: ' + details)
                else:
                    offset = size
            elif opcode == BC_FLOW_IF:
                if check_depth(slice, offset, 3):
                    a = stack_pop()  # false
                    b = stack_pop()  # true
                    c = stack_pop()  # flag
                    if c == -1:
                        interpret(b, more)
                    else:
                        interpret(a, more)
                else:
                    offset = size
            elif opcode == BC_FLOW_WHILE:
                if check_depth(slice, offset, 1):
                    quote = stack_pop()
                    a = -1
                    while a == -1:
                        interpret(quote, more)
                        a = stack_pop()
                else:
                    offset = size
            elif opcode == BC_FLOW_UNTIL:
                if check_depth(slice, offset, 1):
                    quote = stack_pop()
                    a = 0
                    while a == 0:
                        interpret(quote, more)
                        a = stack_pop()
                else:
                    offset = size
            elif opcode == BC_FLOW_TIMES:
                if check_depth(slice, offset, 2):
                    quote = stack_pop()
                    count = stack_pop()
                    while count > 0:
                        interpret(quote, more)
                        count -= 1
                else:
                    offset = size
            elif opcode == BC_FLOW_CALL:
                offset += 1
                interpret(int(fetch(slice, offset)), more)
            elif opcode == BC_FLOW_CALL_F:
                if check_depth(slice, offset, 1):
                    a = stack_pop()
                    interpret(a, more)
                else:
                    offset = size
            elif opcode == BC_FLOW_DIP:
                if check_depth(slice, offset, 2):
                    quote = stack_pop()
                    vtype = stack_type()
                    value = stack_pop()
                    interpret(quote, more)
                    stack_push(value, vtype)
                else:
                    offset = size
            elif opcode == BC_FLOW_SIP:
                if check_depth(slice, offset, 2):
                    quote = stack_pop()
                    stack_dup()
                    vtype = stack_type()
                    value = stack_pop()
                    interpret(quote, more)
                    stack_push(value, vtype)
                else:
                    offset = size
            elif opcode == BC_FLOW_BI:
                if check_depth(slice, offset, 3):
                    a = stack_pop()
                    b = stack_pop()
                    stack_dup()
                    x = stack_type()
                    y = stack_pop()
                    interpret(b, more)
                    stack_push(y, x)
                    interpret(a, more)
                else:
                    offset = size
            elif opcode == BC_FLOW_TRI:
                if check_depth(slice, offset, 4):
                    a = stack_pop()
                    b = stack_pop()
                    c = stack_pop()
                    stack_dup()
                    x = stack_type()
                    y = stack_pop()
                    stack_dup()
                    m = stack_type()
                    q = stack_pop()
                    interpret(c, more)
                    stack_push(q, m)
                    interpret(b, more)
                    stack_push(y, x)
                    interpret(a, more)
                else:
                    offset = size
            elif opcode == BC_FLOW_ABORT:
                should_abort = True
            elif opcode == BC_FLOW_RETURN:
                offset = size
            elif opcode == BC_MEM_COPY:
                if check_depth(slice, offset, 2):
                    a = stack_pop()
                    b = stack_pop()
                    copy_slice(b, a)
                else:
                    offset = size
            elif opcode == BC_MEM_FETCH:
                if check_depth(slice, offset, 2):
                    a = stack_pop()
                    b = stack_pop()
                    stack_push(fetch(b, a), fetch_type(b, a))
                else:
                    offset = size
            elif opcode == BC_MEM_STORE:
                if check_depth(slice, offset, 3):
                    a = stack_pop()   # offset
                    b = stack_pop()   # slice
                    t = stack_type()  # type
                    c = stack_pop()   # value
                    store(c, b, a, t)
                else:
                    offset = size
            elif opcode == BC_MEM_REQUEST:
                stack_push(request_slice(), TYPE_POINTER)
            elif opcode == BC_MEM_RELEASE:
                if check_depth(slice, offset, 1):
                    release_slice(stack_pop())
                else:
                    offset = size
            elif opcode == BC_MEM_COLLECT:
                collect_garbage()
            elif opcode == BC_MEM_GET_LAST:
                if check_depth(slice, offset, 1):
                    a = stack_pop()
                    stack_push(get_last_index(a), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_MEM_SET_LAST:
                if check_depth(slice, offset, 2):
                    a = stack_pop()
                    b = stack_pop()
                    set_slice_last_index(a, b)
                else:
                    offset = size
            elif opcode == BC_MEM_SET_TYPE:
                if check_depth(slice, offset, 3):
                    a = stack_pop()  # offset
                    b = stack_pop()  # slice
                    c = stack_pop()  # type
                    store_type(b, a, c)
                else:
                    offset = size
            elif opcode == BC_MEM_GET_TYPE:
                if check_depth(slice, offset, 1):
                    a = stack_pop()
                    b = stack_pop()
                    c = fetch_type(b, a)
                    stack_push(int(c), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_STACK_DUP:
                if check_depth(slice, offset, 1):
                    stack_dup()
                else:
                    offset = size
            elif opcode == BC_STACK_DROP:
                if check_depth(slice, offset, 1):
                    stack_drop()
                else:
                    offset = size
            elif opcode == BC_STACK_SWAP:
                if check_depth(slice, offset, 2):
                    stack_swap()
                else:
                    offset = size
            elif opcode == BC_STACK_DEPTH:
                stack_push(len(stack), TYPE_NUMBER)
            elif opcode == BC_QUOTE_NAME:
                if check_depth(slice, offset, 2):
                    name = slice_to_string(stack_pop())
                    ptr = stack_pop()
                    add_definition(name, ptr)
                else:
                    offset = size
            elif opcode == BC_FUNCTION_EXISTS:
                if check_depth(slice, offset, 1):
                    name = slice_to_string(stack_pop())
                    if lookup_pointer(name) != -1:
                        stack_push(-1, TYPE_FLAG)
                    else:
                        stack_push(0, TYPE_FLAG)
                else:
                    offset = size
            elif opcode == BC_FUNCTION_LOOKUP:
                if check_depth(slice, offset, 1):
                    name = slice_to_string(stack_pop())
                    if lookup_pointer(name) != -1:
                        stack_push(lookup_pointer(name), TYPE_POINTER)
                    else:
                        stack_push(-1, TYPE_POINTER)
                else:
                    offset = size
            elif opcode == BC_FUNCTION_HIDE:
                if check_depth(slice, offset, 1):
                    name = slice_to_string(stack_pop())
                    if lookup_pointer(name) != -1:
                        remove_name(name)
                else:
                    offset = size
            elif opcode == BC_FUNCTION_NAME:
                if check_depth(slice, offset, 1):
                    a = pointer_to_name(stack_pop())
                    stack_push(string_to_slice(a), TYPE_STRING)
                else:
                    offset = size
            elif opcode == BC_STRING_SEEK:
                if check_depth(slice, offset, 2):
                    a = slice_to_string(stack_pop())
                    b = slice_to_string(stack_pop())
                    stack_push(b.find(a), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_SLICE_SUBSLICE:
                if check_depth(slice, offset, 3):
                    a = int(stack_pop())
                    b = int(stack_pop())
                    s = int(stack_pop())
                    c = memory_values[s]
                    d = c[b:a]
                    dt = memory_types[s]
                    dt = dt[b:a]
                    e = request_slice()
                    i = 0
                    while i < len(d):
                        store(d[i], e, i, dt[i])
                        i = i + 1
                    stack_push(e, TYPE_POINTER)
                else:
                    offset = size
            elif opcode == BC_STRING_NUMERIC:
                if check_depth(slice, offset, 1):
                    a = slice_to_string(stack_pop())
                    if is_number(a):
                        stack_push(-1, TYPE_FLAG)
                    else:
                        stack_push(0, TYPE_FLAG)
                else:
                    offset = size
            elif opcode == BC_SLICE_REVERSE:
                if check_depth(slice, offset, 1):
                    a = stack_pop()
                    memory_values[int(a)] = memory_values[int(a)][::-1]
                    stack_push(a, TYPE_POINTER)
                else:
                    offset = size
            elif opcode == BC_TO_UPPER:
                if check_depth(slice, offset, 1):
                    t = stack_type()
                    if t == TYPE_STRING:
                        ptr = stack_pop()
                        a = slice_to_string(ptr).upper()
                        stack_push(string_to_slice(a), TYPE_STRING)
                    elif t == TYPE_CHARACTER:
                        a = stack_pop()
                        b = ''.join(chr(a))
                        a = b.upper()
                        stack_push(ord(a[0].encode('utf-8')), TYPE_CHARACTER)
                    else:
                        details = 'Slice ' + str(slice)
                        details = details + ' Offset: ' + str(offset)
                        report('E02: Type mismatch: ' + details)
                else:
                    offset = size
            elif opcode == BC_TO_LOWER:
                if check_depth(slice, offset, 1):
                    t = stack_type()
                    if t == TYPE_STRING:
                        ptr = stack_pop()
                        a = slice_to_string(ptr).lower()
                        stack_push(string_to_slice(a), TYPE_STRING)
                    elif t == TYPE_CHARACTER:
                        a = stack_pop()
                        b = ''.join(chr(a))
                        a = b.lower()
                        stack_push(ord(a[0].encode('utf-8')), TYPE_CHARACTER)
                    else:
                        details = 'Slice ' + str(slice)
                        details = details + ' Offset: ' + str(offset)
                        report('E02: Type mismatch: ' + details)
                else:
                    offset = size
            elif opcode == BC_REPORT:
                if check_depth(slice, offset, 1):
                    if stack_type() == TYPE_STRING:
                        a = slice_to_string(stack_pop())
                        report(a)
                offset = size
            elif opcode == BC_TRIG_SIN:
                if check_depth(slice, offset, 1):
                    a = stack_pop()
                    stack_push(math.sin(a), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_TRIG_COS:
                if check_depth(slice, offset, 1):
                    a = stack_pop()
                    stack_push(math.cos(a), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_TRIG_TAN:
                if check_depth(slice, offset, 1):
                    a = stack_pop()
                    stack_push(math.tan(a), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_TRIG_ASIN:
                if check_depth(slice, offset, 1):
                    a = stack_pop()
                    stack_push(math.asin(a), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_TRIG_ACOS:
                if check_depth(slice, offset, 1):
                    a = stack_pop()
                    stack_push(math.acos(a), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_TRIG_ATAN:
                if check_depth(slice, offset, 1):
                    a = stack_pop()
                    stack_push(math.atan(a), TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_TRIG_ATAN2:
                if check_depth(slice, offset, 2):
                    a = stack_pop()
                    b = stack_pop()
                    stack_push(math.atan2(b, a), TYPE_NUMBER)
                else:
                    offset = size
            if more is not None:
                offset = more(slice, offset, opcode)

        offset += 1
    current_slice = 0


#
# Data stack implementation
#

stack = []
types = []


def stack_clear():
    """remove all values from the stack"""
    global stack, types
    i = 0
    while i < len(stack):
        stack.pop()
        types.pop()


def stack_push(value, type):
    """push a value to the stack"""
    global stack, types
    stack.append(value)
    types.append(type)


def stack_drop():
    """remove a value from the stack"""
    global stack, types
    stack.pop()
    types.pop()


def stack_pop():
    """remove and return a value from the stack"""
    global stack, types
    types.pop()
    return stack.pop()


def tos():
    """return a pointer to the top element in the stack"""
    global stack, types
    return len(stack) - 1


def stack_type():
    """return the type identifier for the top item on the stack"""
    global stack, types
    return types[tos()]


def stack_swap():
    """switch the positions of the top items on the stack"""
    at = stack_type()
    av = stack_pop()
    bt = stack_type()
    bv = stack_pop()
    stack_push(av, at)
    stack_push(bv, bt)


def stack_dup():
    """duplicate the top item on the stack"""
    """if the value is a string, makes a copy of it"""
    at = stack_type()
    av = stack_pop()
    stack_push(av, at)
    if at == TYPE_STRING:
        s = request_slice()
        copy_slice(av, s)
        stack_push(s, at)
    else:
        stack_push(av, at)


def stack_change_type(desired):
    """convert the type of an item on the stack to a different type"""
    global types, stack
    original = stack_type()
    if desired == TYPE_BYTECODE:
        if original == TYPE_NUMBER:
            types.pop()
            types.append(TYPE_BYTECODE)
    elif desired == TYPE_NUMBER:
        if original == TYPE_STRING:
            if is_number(slice_to_string(stack[tos()])):
                stack_push(float(slice_to_string(stack_pop())), TYPE_NUMBER)
            else:
                stack_pop()
                stack_push(float('nan'), TYPE_NUMBER)
        else:
            types.pop()
            types.append(TYPE_NUMBER)
    elif desired == TYPE_STRING:
        if original == TYPE_NUMBER:
            stack_push(string_to_slice(str(stack_pop())), TYPE_STRING)
        elif original == TYPE_CHARACTER:
            stack_push(string_to_slice(str(chr(stack_pop()))), TYPE_STRING)
        elif original == TYPE_FLAG:
            s = stack_pop()
            if s == -1:
                stack_push(string_to_slice('true'), TYPE_STRING)
            elif s == 0:
                stack_push(string_to_slice('false'), TYPE_STRING)
            else:
                stack_push(string_to_slice('malformed flag'), TYPE_STRING)
        elif original == TYPE_POINTER or original == TYPE_REMARK:
            types.pop()
            types.append(TYPE_STRING)
        else:
            return 0
    elif desired == TYPE_CHARACTER:
        if original == TYPE_STRING:
            s = slice_to_string(stack_pop())
            stack_push(ord(s[0].encode('utf-8')), TYPE_CHARACTER)
        else:
            s = stack_pop()
            stack_push(int(s), TYPE_CHARACTER)
    elif desired == TYPE_POINTER:
        types.pop()
        types.append(TYPE_POINTER)
    elif desired == TYPE_FLAG:
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
    elif desired == TYPE_FUNCTION_CALL:
        if original == TYPE_NUMBER or original == TYPE_POINTER:
            a = stack_pop()
            stack_push(a, TYPE_FUNCTION_CALL)
    else:
        a = stack_pop()
        stack_push(a, desired)          


#
# Parable's dictionary consists of two related arrays.
# The first contains the names. The second contains pointers
# to the slices for each named item.
#

dictionary_names = []
dictionary_slices = []
dictionary_hidden_slices = []

def in_dictionary(s):
    global dictionary_names, dictionary_slices
    return s in dictionary_names


def lookup_pointer(name):
    global dictionary_names, dictionary_slices
    if in_dictionary(name) is False:
        return -1
    else:
        return dictionary_slices[dictionary_names.index(name)]


def add_definition(name, slice):
    global dictionary_names, dictionary_slices
    if in_dictionary(name) is False:
        dictionary_names.append(name)
        dictionary_slices.append(slice)
    else:
        target = dictionary_slices[dictionary_names.index(name)]
        copy_slice(slice, target)
    return dictionary_names.index(name)


def remove_name(name):
    global dictionary_names, dictionary_slices, dictionary_hidden_slices
    if in_dictionary(name) is not False:
        i = dictionary_names.index(name)
        del dictionary_names[i]
        dictionary_hidden_slices.append(dictionary_slices[i])
        del dictionary_slices[i]


#
# in parable, memory is divided into regions called slices
# compiled code, strings, and other data are stored in these.
#

memory_values = []
memory_types = []
memory_map = []
memory_size = []


def request_slice(attempts=1):
    """request a new memory slice"""
    global memory_values, memory_types, memory_map, memory_size, MAX_SLICES
    i = 0
    while i < MAX_SLICES:
        if memory_map[i] == 0:
            memory_map[i] = 1
            memory_values[i] = [0]
            memory_types[i] = [TYPE_NUMBER]
            memory_size[i] = 0
            return i
        else:
            i += 1
    if attempts == 1:
        collect_garbage()
        return request_slice(2)
    else:
        return -1


def release_slice(slice):
    """release a slice. the slice should not be used after this is done"""
    global memory_map
    memory_map[int(slice)] = 0


def copy_slice(source, dest):
    """copy the contents of one slice to another"""
    global memory_values, memory_map, memory_size
    i = 0
    l = memory_size[int(source)]
    while i <= l:
        v = fetch(int(source), i)
        t = fetch_type(int(source), i)
        store(v, int(dest), i, t)
        i += 1
    memory_size[int(dest)] = memory_size[int(source)]


def prepare_slices():
    """prepare the initial set of slices for use"""
    global memory_values, memory_types, memory_map, memory_size, MAX_SLICES
    memory_map = [0 for x in range(MAX_SLICES)]
    memory_values = [0 for x in range(MAX_SLICES)]
    memory_types = [0 for x in range(MAX_SLICES)]
    memory_size = [0 for x in range(MAX_SLICES)]


def fetch(slice, offset):
    """obtain a value stored in a slice"""
    global memory_values, memory_map
    if get_last_index(slice) < offset:
        set_slice_last_index(slice, offset)
    return memory_values[int(slice)][int(offset)]


def fetch_type(slice, offset):
    """obtain a value stored in a slice"""
    global memory_types, memory_map
    if get_last_index(slice) < offset:
        set_slice_last_index(slice, offset)
    return memory_types[int(slice)][int(offset)]


def store_type(slice, offset, type):
    global memory_values, memory_types, memory_map
    if get_last_index(slice) < offset:
        set_slice_last_index(slice, offset)
    memory_types[int(slice)][int(offset)] = type


def store(value, slice, offset, type=100):
    """store a value into a slice"""
    global memory_values, memory_types, memory_map
    if get_last_index(slice) < offset:
        set_slice_last_index(slice, offset)
    memory_values[int(slice)][int(offset)] = value
    memory_types[int(slice)][int(offset)] = type


def get_last_index(slice):
    """get the length of a slice"""
    global memory_size
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


def slice_to_string(slice):
    """convert a slice into a string"""
    s = []
    i = 0
    size = get_last_index(int(slice))
    while i <= size:
        s.append(chr(int(fetch(slice, i))))
        i += 1
    return ''.join(s)


#
# unused slices can be reclaimed either manually using release_slice(),
# or parable can attempt to identify them and reclaim them automatically.
# the code here implements the garbage collector.
#

def is_pointer(type):
    flag = False
    if type == TYPE_POINTER or \
       type == TYPE_STRING or \
       type == TYPE_REMARK or \
       type == TYPE_FUNCTION_CALL:
        flag = True
    else:
        flag = False
    return flag


def find_references(s):
    """given a slice, return a list of all references in it"""
    ptrs = []
    i = 0
    if s < 0:
        return []
    if get_last_index(s) <= 0:
        type = fetch_type(s, 0)
        if is_pointer(type):
            if not fetch(s, 0) in ptrs:
                ptrs.append(int(fetch(s, 0)))
        if type == TYPE_POINTER or type == TYPE_FUNCTION_CALL:
            for xt in find_references(int(fetch(s, 0))):
                if not fetch(s, 0) in ptrs:
                    ptrs.append(int(xt))
    else:
        while i < get_last_index(s):
            type = fetch_type(s, i)
            if is_pointer(type):
                if not fetch(s, i) in ptrs:
                    ptrs.append(int(fetch(s, i)))
            if type == TYPE_POINTER or type == TYPE_FUNCTION_CALL:
                for xt in find_references(int(fetch(s, i))):
                    if not xt in ptrs:
                        ptrs.append(int(xt))
            i += 1
    return list(set(ptrs))


def seek_all_references():
    """return a list of all references in all named slices and stack items"""
    global dictionary_slices, stack, types, current_slice
    sources = []

    # Named items
    for s in dictionary_slices:
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
        if is_pointer(types[i]):
            sources.append(stack[i])
        i = i - 1

    refs = sources
    for s in sources:
        for x in find_references(s):
            if not x in refs:
                refs.append(x)

    return refs


def collect_garbage():
    """scan memory, and collect unused slices"""
    global MAX_SLICES, memory_map
    i = 0
    refs = seek_all_references()
    while i < MAX_SLICES:
        if not i in refs and memory_map[i] == 1:
            release_slice(i)
        i = i + 1

#
# the compiler is pretty trivial.
# we take a string, break it into tokens, then lay down bytecode based on
# single character prefixes.
#
# #  Numbers
# $  Characters
# &  Pointers
# `  Bytecodes
# '  Strings
# "  Comments
#
# the bytecode forms are kept simple:
#
# type           stored         type
# ==========     ============================
# Functions      pointer        function call
# Strings        pointer        string
# Numbers        VALUE          number
# Characters     ASCII_VALUE    character
# Pointers       pointer        pointer
# Bytecodes      bytecode       bytecode
# Comments       pointer        comment
#
# for two functions ([ and ]), new quotes are started or closed. These are
# the only case where the corresponding action is run automatically rather
# than being compiled.
#
# bytecodes get wrapped into named functions. At this point they are not
# inlined. This hurts performance, but makes the implementation much simpler.
#

# The compile_ functions take a parameter, a slice, and the current offset
# in that slice. They lay down the appropriate byte codes for the type of
# item they are compiling. When done, they return the new offset.


def compile_string(string, slice, offset):
    store(string_to_slice(string), slice, offset, TYPE_STRING)
    offset += 1
    return offset


def compile_comment(string, slice, offset):
    store(string_to_slice(string), slice, offset, TYPE_REMARK)
    offset += 1
    return offset


def compile_character(character, slice, offset):
    store(character, slice, offset, TYPE_CHARACTER)
    offset += 1
    return offset


def compile_pointer(name, slice, offset):
    if is_number(name):
        store(float(name), slice, offset, TYPE_POINTER)
    else:
        if lookup_pointer(name) != -1:
            store(lookup_pointer(name), slice, offset, TYPE_POINTER)
        else:
            store(0, slice, offset, TYPE_POINTER)
            report('E03: Compile Error: Unable to map ' +
                   name + ' to a pointer')
    offset += 1
    return offset


def compile_number(number, slice, offset):
    if is_number(number):
        store(float(number), slice, offset, TYPE_NUMBER)
    else:
        store(float('nan'), slice, offset, TYPE_NUMBER)
        report("E03: Compile Error: Unable to convert " +
               number + " to a number")
    offset += 1
    return offset


def compile_bytecode(bytecode, slice, offset):
    store(float(bytecode), slice, offset, TYPE_BYTECODE)
    offset += 1
    return offset


def compile_function_call(name, slice, offset):
    if lookup_pointer(name) != -1:
        store(lookup_pointer(name), slice, offset, TYPE_FUNCTION_CALL)
        offset += 1
    else:
        report('E03: Compile Error: Unable to map ' + name + ' to a pointer')
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
    return i, s.replace("\\", "")


def compile(str, slice):
    global should_abort
    should_abort = False
    nest = []
    tokens = ' '.join(str.split()).split(' ')
    count = len(tokens)
    i = 0
    offset = 0
    current = ""
    prefix = ""
    while i < count:
        current = tokens[i]
        prefix = tokens[i][:1]
        s = ""
        if prefix == '"':
            i, s = parse_string(tokens, i, count, '"')
            offset = compile_comment(s[1:-1], slice, offset)
        elif prefix == "'":
            i, s = parse_string(tokens, i, count, '\'')
            offset = compile_string(s[1:-1], slice, offset)
        elif prefix == "$":
            v = ord(current[1:][0].encode('utf-8'))
            offset = compile_character(v, slice, offset)
        elif prefix == "&":
            offset = compile_pointer(current[1:], slice, offset)
        elif prefix == "#":
            offset = compile_number(current[1:], slice, offset)
        elif prefix == "`":
            offset = compile_bytecode(current[1:], slice, offset)
        elif prefix == "@":
            offset = compile_pointer(current[1:], slice, offset)
            offset = compile_number(0, slice, offset)
            offset = compile_bytecode(BC_MEM_FETCH, slice, offset)
        elif prefix == "!":
            offset = compile_pointer(current[1:], slice, offset)
            offset = compile_number(0, slice, offset)
            offset = compile_bytecode(BC_MEM_STORE, slice, offset)
        elif current == "[":
            nest.append(slice)
            nest.append(offset)
            slice = request_slice()
            offset = 0
        elif current == "]":
            old = slice
            if offset == 0:
                store(BC_FLOW_RETURN, slice, offset, TYPE_BYTECODE)
            offset = nest.pop()
            slice = nest.pop()
            store(old, slice, offset, TYPE_POINTER)
            offset += 1
        else:
            if is_number(current):
                offset = compile_number(current, slice, offset)
            else:
                offset = compile_function_call(current, slice, offset)
        i += 1
        if offset == 0:
            store(BC_FLOW_RETURN, slice, offset, TYPE_BYTECODE)
    return slice


def parse_bootstrap(f):
    """compile the bootstrap package it into memory"""
    for line in condense_lines(f):
        if len(line) > 0:
            interpret(compile(line, request_slice()))


#
# some parts of the language (prefixes, brackets) are understood as part of
# the parser. but one important bit, the ability to give a name to an item,
# is not. this routine sets up an initial dictionary containing the *define*
# function. with this loaded, all else can be built.
#

def prepare_dictionary():
    """setup the initial dictionary"""
    s = request_slice()
    store(BC_QUOTE_NAME, s, 0, TYPE_BYTECODE)
    add_definition('define', s)


def pointer_to_name(ptr):
    """given a parable pointer, return the corresponding name, or"""
    """an empty string"""
    global dictionary_names, dictionary_slices
    s = ""
    if ptr in dictionary_slices:
        s = dictionary_names[dictionary_slices.index(ptr)]
    return s
