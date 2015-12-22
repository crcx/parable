# parable
# Copyright (c) 2012-2015, Charles Childers
# ==========================================

#
# Dependencies
#
import math
import random
import sys

#
# Memory Configuration
#

MAX_SLICES = 80000

#
# Constants for data types
#

TYPE_NUMBER = 100
TYPE_STRING = 200
TYPE_CHARACTER = 300
TYPE_POINTER = 400
TYPE_FLAG = 500
TYPE_BYTECODE = 600
TYPE_COMMENT = 700
TYPE_FUNCTION_CALL = 800

#
# Constants for byte codes
# These are loosely grouped by type
#

BC_TYPE_B = 100
BC_TYPE_N = 101
BC_TYPE_S = 102
BC_TYPE_C = 103
BC_TYPE_F = 104
BC_TYPE_FLAG = 105
BC_TYPE_CALL = 106
BC_SET_TYPE = 109
BC_GET_TYPE = 110
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
BC_STACK_OVER = 503
BC_STACK_TUCK = 504
BC_STACK_NIP = 505
BC_STACK_DEPTH = 506
BC_STACK_CLEAR = 507
BC_QUOTE_NAME = 600
BC_FUNCTION_EXISTS = 601
BC_FUNCTION_LOOKUP = 602
BC_FUNCTION_HIDE = 603
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
    i = 0
    while i < len(errors):
        errors.pop()
        i += 1


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


def interpret(slice, more=None):
    """Interpret the byte codes contained in a slice."""
    global current_slice
    offset = 0
    size = get_last_index(int(slice))
    if current_slice == 0:
        current_slice = slice
    while offset <= size:
        opcode = fetch(slice, offset)
        optype = fetch_type(slice, offset)

        if optype != TYPE_BYTECODE:
            stack_push(opcode, optype)
            if optype == TYPE_COMMENT:
                stack_pop()
            if optype == TYPE_FUNCTION_CALL:
                interpret(stack_pop(), more)
        else:
            if opcode == BC_TYPE_B:
                if check_depth(slice, offset, 1):
                    stack_change_type(TYPE_BYTECODE)
                else:
                    offset = size
            elif opcode == BC_TYPE_N:
                if check_depth(slice, offset, 1):
                    stack_change_type(TYPE_NUMBER)
                else:
                    offset = size
            elif opcode == BC_TYPE_S:
                if check_depth(slice, offset, 1):
                    stack_change_type(TYPE_STRING)
                else:
                    offset = size
            elif opcode == BC_TYPE_C:
                if check_depth(slice, offset, 1):
                    stack_change_type(TYPE_CHARACTER)
                else:
                    offset = size
            elif opcode == BC_TYPE_F:
                if check_depth(slice, offset, 1):
                    stack_change_type(TYPE_POINTER)
                else:
                    offset = size
            elif opcode == BC_TYPE_FLAG:
                if check_depth(slice, offset, 1):
                    stack_change_type(TYPE_FLAG)
                else:
                    offset = size
            elif opcode == BC_TYPE_CALL:
                if check_depth(slice, offset, 1):
                    stack_change_type(TYPE_FUNCTION_CALL)
                else:
                    offset = size
            elif opcode == BC_SET_TYPE:
                if check_depth(slice, offset, 2):
                    a = stack_pop()  # type
                    b = stack_pop()  # value
                    stack_push(b, a)
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
                    a = stack_pop()
                    b = stack_pop()
                    c = stack_pop()
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
            elif opcode == BC_STACK_OVER:
                if check_depth(slice, offset, 2):
                    stack_over()
                else:
                    offset = size
            elif opcode == BC_STACK_TUCK:
                if check_depth(slice, offset, 2):
                    stack_tuck()
                else:
                    offset = size
            elif opcode == BC_STACK_NIP:
                if check_depth(slice, offset, 2):
                    stack_swap()
                    stack_drop()
                else:
                    offset = size
            elif opcode == BC_STACK_DEPTH:
                stack_push(len(stack), TYPE_NUMBER)
            elif opcode == BC_STACK_CLEAR:
                stack_clear()
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
                    c = p_slices[s]
                    d = c[b:a]
                    dt = p_types[s]
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
                    p_slices[int(a)] = p_slices[int(a)][::-1]
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
                        b = ''.join(unichr(a))
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
                        b = ''.join(unichr(a))
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


def stack_tos():
    """return the top element on the stack"""
    global stack, types
    return stack[tos()]


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


def stack_over():
    """put a copy of the second item on the stack over the top item"""
    """if the value is a string, makes a copy of it"""
    at = stack_type()
    av = stack_pop()
    bt = stack_type()
    bv = stack_pop()
    stack_push(bv, bt)
    stack_push(av, at)
    if bt == TYPE_STRING:
        s = request_slice()
        copy_slice(bv, s)
        stack_push(s, bt)
    else:
        stack_push(bv, bt)


def stack_tuck():
    """put a copy of the top item under the second item"""
    """if the value is a string, makes a copy of it"""
    stack_swap()
    stack_over()


def stack_change_type(type):
    """convert the type of an item on the stack to a different type"""
    global types, stack
    if type == TYPE_BYTECODE:
        if stack_type() == TYPE_NUMBER:
            a = stack_pop()
            stack_push(a, TYPE_BYTECODE)
    elif type == TYPE_NUMBER:
        if stack_type() == TYPE_STRING:
            if is_number(slice_to_string(stack_tos())):
                stack_push(float(slice_to_string(stack_pop())), TYPE_NUMBER)
            else:
                stack_pop()
                stack_push(float('nan'), TYPE_NUMBER)
        else:
            types.pop()
            types.append(TYPE_NUMBER)
    elif type == TYPE_STRING:
        if stack_type() == TYPE_NUMBER:
            stack_push(string_to_slice(unicode(stack_pop())), TYPE_STRING)
        elif stack_type() == TYPE_CHARACTER:
            a = stack_pop()
            stack_push(string_to_slice(''.join(unichr(a))), TYPE_STRING)
        elif stack_type() == TYPE_FLAG:
            s = stack_pop()
            if s == -1:
                stack_push(string_to_slice('true'), TYPE_STRING)
            elif s == 0:
                stack_push(string_to_slice('false'), TYPE_STRING)
            else:
                stack_push(string_to_slice('malformed flag'), TYPE_STRING)
        elif stack_type() == TYPE_POINTER:
            types.pop()
            types.append(TYPE_STRING)
        else:
            return 0
    elif type == TYPE_CHARACTER:
        if stack_type() == TYPE_STRING:
            s = slice_to_string(stack_pop())
            stack_push(ord(s[0].encode('utf-8')), TYPE_CHARACTER)
        else:
            s = stack_pop()
            stack_push(int(s), TYPE_CHARACTER)
    elif type == TYPE_POINTER:
        types.pop()
        types.append(TYPE_POINTER)
    elif type == TYPE_FLAG:
        if stack_type() == TYPE_STRING:
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
    elif type == TYPE_FUNCTION_CALL:
        if stack_type() == TYPE_NUMBER or stack_type() == TYPE_POINTER:
            a = stack_pop()
            stack_push(a, TYPE_FUNCTION_CALL)
    else:
        return


#
# Parable's dictionary consists of two related arrays.
# The first contains the names. The second contains pointers
# to the slices for each named item.
#

dictionary_names = []
dictionary_slices = []


def in_dictionary(s):
    global dictionary_names, dictionary_slices
    return s in dictionary_names


def lookup_pointer(name):
    global dictionary_names, dictionary_slices
    name = name.lower()
    if in_dictionary(name) is False:
        return -1
    else:
        return dictionary_slices[dictionary_names.index(name)]


def add_definition(name, slice):
    global dictionary_names, dictionary_slices
    name = name.lower()
    if in_dictionary(name) is False:
        dictionary_names.append(name)
        dictionary_slices.append(slice)
    else:
        target = dictionary_slices[dictionary_names.index(name)]
        copy_slice(slice, target)
    return dictionary_names.index(name)


def remove_name(name):
    global dictionary_names, dictionary_slices
    name = name.lower()
    if in_dictionary(name) is not False:
        i = dictionary_names.index(name)
        del dictionary_names[i]
        del dictionary_slices[i]


#
# in parable, memory is divided into regions called slices
# compiled code, strings, and other data are stored in these.
# each slice can contain up to SLICE_LEN values
#

p_slices = []
p_types = []
p_map = []
p_sizes = []


def request_slice(attempts=1):
    """request a new memory slice"""
    global p_slices, p_types, p_map, p_sizes, MAX_SLICES
    i = 0
    while i < MAX_SLICES:
        if p_map[i] == 0:
            p_map[i] = 1
            p_slices[i] = [0]
            p_types[i] = [TYPE_NUMBER]
            p_sizes[i] = 0
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
    global p_map
    p_map[int(slice)] = 0


def copy_slice(source, dest):
    """copy the contents of one slice to another"""
    global p_slices, p_map, p_sizes
    i = 0
    l = p_sizes[int(source)]
    while i <= l:
        v = fetch(int(source), i)
        t = fetch_type(int(source), i)
        store(v, int(dest), i, t)
        i += 1
    p_sizes[int(dest)] = p_sizes[int(source)]


def prepare_slices():
    """prepare the initial set of slices for use"""
    global p_slices, p_types, p_map, p_sizes, MAX_SLICES
    p_map = [0 for x in range(MAX_SLICES)]
    p_slices = [0 for x in range(MAX_SLICES)]
    p_types = [0 for x in range(MAX_SLICES)]
    p_sizes = [0 for x in range(MAX_SLICES)]


def fetch(slice, offset):
    """obtain a value stored in a slice"""
    global p_slices, p_map
    if get_last_index(slice) < offset:
        set_slice_last_index(slice, offset)
    return p_slices[int(slice)][int(offset)]


def fetch_type(slice, offset):
    """obtain a value stored in a slice"""
    global p_types, p_map
    if get_last_index(slice) < offset:
        set_slice_last_index(slice, offset)
    return p_types[int(slice)][int(offset)]


def store_type(slice, offset, type):
    global p_slices, p_types, p_map
    if get_last_index(slice) < offset:
        set_slice_last_index(slice, offset)
    p_types[int(slice)][int(offset)] = type


def store(value, slice, offset, type=100):
    """store a value into a slice"""
    global p_slices, p_types, p_map
    if get_last_index(slice) < offset:
        set_slice_last_index(slice, offset)
    p_slices[int(slice)][int(offset)] = value
    p_types[int(slice)][int(offset)] = type


def get_last_index(slice):
    """get the length of a slice"""
    global p_sizes
    return p_sizes[int(slice)]


def set_slice_last_index(slice, size):
    """set the length of a slice"""
    global p_slices, p_types, p_sizes
    old_size = p_sizes[int(slice)]
    grow_by = size - old_size
    if grow_by > 0:
        p_slices[int(slice)].extend(range(int(grow_by)))
        p_types[int(slice)].extend(range(int(grow_by)))
    if grow_by < 0:
        while grow_by < 0:
            grow_by = grow_by + 1
            del p_slices[int(slice)][-1]
            del p_types[int(slice)][-1]
    p_sizes[int(slice)] = size


def string_to_slice(string):
    """convert a string into a slice"""
    s = request_slice()
    i = 0
    for char in list(string):
        store(ord(char.encode('utf-8')), s, i, TYPE_CHARACTER)
        i += 1
    return s


def slice_to_string(slice):
    """convert a slice into a string"""
    s = []
    i = 0
    size = get_last_index(int(slice))
    while i <= size:
        s.append(unichr(int(fetch(slice, i))))
        i += 1
    return ''.join(s)


#
# unused slices can be reclaimed either manually using release_slice(),
# or parable can attempt to identify them and reclaim them automatically.
# the code here implements the garbage collector.
#

def find_references(s):
    """given a slice, return a list of all references in it"""
    ptrs = []
    i = 0
    if s < 0:
        return []
    if get_last_index(s) == 0:
        type = fetch_type(s, 0)
        if type == TYPE_POINTER or type == TYPE_STRING or type == TYPE_COMMENT or type == TYPE_FUNCTION_CALL:
            ptrs.append(int(fetch(s, 0)))
        if type == TYPE_POINTER or type == TYPE_FUNCTION_CALL:
            for xt in find_references(int(fetch(s, 0))):
                ptrs.append(int(xt))
    else:
        while i < get_last_index(s):
            type = fetch_type(s, i)
            if type == TYPE_POINTER or type == TYPE_STRING or type == TYPE_COMMENT or type == TYPE_FUNCTION_CALL:
                ptrs.append(int(fetch(s, i)))
            if type == TYPE_POINTER or type == TYPE_FUNCTION_CALL:
                for xt in find_references(int(fetch(s, i))):
                    ptrs.append(int(xt))
            i += 1
    return list(set(ptrs))


def seek_all_references():
    """return a list of all references in all named slices and stack items"""
    global dictionary_slices, stack, types, current_slice
    refs = []
    for s in dictionary_slices:
        refs.append(s)
        for x in find_references(s):
            refs.append(x)
    for x in find_references(current_slice):
        refs.append(x)
    i = tos()
    while i > 0:
        if types[i] == TYPE_STRING or types[i] == TYPE_COMMENT or types[i] == TYPE_POINTER or types[i] == TYPE_FUNCTION_CALL:
            refs.append(stack[i])
            for x in find_references(stack[i]):
                refs.append(x)
        i -= 1
    return list(set(refs))


def collect_garbage():
    """scan memory, and collect unused slices"""
    global MAX_SLICES, p_map
    i = 0
    refs = seek_all_references()
    while i < MAX_SLICES:
        if p_map[i] == 1:
            try:
                x = refs.index(i)
            except:
                if i > 0:
                    release_slice(i)
        i += 1


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
    store(string_to_slice(string), slice, offset, TYPE_COMMENT)
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
            report('E03: Compile Error: Unable to map ' + name + ' to a pointer')
    offset += 1
    return offset


def compile_number(number, slice, offset):
    if is_number(number):
        store(float(number), slice, offset, TYPE_NUMBER)
    else:
        store(float('nan'), slice, offset, TYPE_NUMBER)
        report("E03: Compile Error: Unable to convert " + number + " to a number")
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
    if (a and b and not c):
        s = tokens[i]
    else:
        j = i + 1
        s = tokens[i]
        while j < count:
            s += " "
            s += tokens[j]
            a = tokens[j].endswith(delimiter)
            b = tokens[j].endswith("\\" + delimiter)
            if (a and not b):
                i = j
                j = count
            j += 1
    return i, s.replace("\\", "")


def compile(str, slice):
    nest = []
    cleaned = ' '.join(str.split())
    tokens = cleaned.split(' ')
    count = len(tokens)
    i = 0
    offset = 0
    while i < count:
        s = ""
        if (tokens[i].startswith('"') or tokens[i] == '"'):
            i, s = parse_string(tokens, i, count, '"')
            offset = compile_comment(s[1:-1], slice, offset)
        elif (tokens[i].startswith('\'') or tokens[i] == '\''):
            i, s = parse_string(tokens, i, count, '\'')
            offset = compile_string(s[1:-1], slice, offset)
        elif tokens[i].startswith("$"):
            v = ord(tokens[i][1:].encode('utf-8'))
            offset = compile_character(v, slice, offset)
        elif tokens[i].startswith("&"):
            offset = compile_pointer(tokens[i][1:], slice, offset)
        elif tokens[i].startswith("#"):
            offset = compile_number(tokens[i][1:], slice, offset)
        elif tokens[i].startswith("`"):
            offset = compile_bytecode(tokens[i][1:], slice, offset)
        elif tokens[i] == "[":
            nest.append(slice)
            nest.append(offset)
            slice = request_slice()
            offset = 0
        elif tokens[i] == "]":
            old = slice
            if offset == 0:
                store(BC_FLOW_RETURN, slice, offset, TYPE_BYTECODE)
            offset = nest.pop()
            slice = nest.pop()
            store(old, slice, offset, TYPE_POINTER)
            offset += 1
        else:
            if is_number(tokens[i]):
                offset = compile_number(tokens[i], slice, offset)
            else:
                offset = compile_function_call(tokens[i], slice, offset)
        i += 1
        if offset == 0:
            store(BC_FLOW_RETURN, slice, offset, TYPE_BYTECODE)
    return slice


def parse_bootstrap(f):
    """compile the bootstrap package it into memory"""
    f = condense_lines(f)
    for line in f:
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
