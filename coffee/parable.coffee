# parable
# copyright (c) 2012 - 2014, charles childers
#

MAX_SLICES = 64000
SLICE_LEN = 1000


#
# Constants for data types
#

TYPE_NUMBER = 100
TYPE_STRING = 200
TYPE_CHARACTER= 300
TYPE_FUNCTION = 400
TYPE_FLAG = 500


#
# Constants for byte codes
#

BC_PUSH_N = 100
BC_PUSH_S = 101
BC_PUSH_C = 102
BC_PUSH_F = 103
BC_PUSH_COMMENT = 104
BC_TYPE_N = 110
BC_TYPE_S = 111
BC_TYPE_C = 112
BC_TYPE_F = 113
BC_TYPE_FLAG = 114
BC_GET_TYPE = 120
BC_ADD = 200
BC_SUBTRACT = 201
BC_MULTIPLY = 202
BC_DIVIDE = 203
BC_REMAINDER = 204
BC_FLOOR = 205
BC_BITWISE_SHIFT = 210
BC_BITWISE_AND = 211
BC_BITWISE_OR = 212
BC_BITWISE_XOR = 213
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
BC_STACK_DUP = 500
BC_STACK_DROP = 501
BC_STACK_SWAP = 502
BC_STACK_OVER = 503
BC_STACK_TUCK = 504
BC_STACK_NIP = 505
BC_STACK_DEPTH = 506
BC_STACK_CLEAR = 507
BC_QUOTE_NAME = 600
BC_STRING_SEEK = 700
BC_STRING_SUBSTR = 701
BC_STRING_NUMERIC= 702
BC_TO_LOWER = 800
BC_TO_UPPER = 801
BC_LENGTH = 802
BC_REPORT_ERROR = 900


if (typeof String::startsWith != 'function')
  String::startsWith = (str) ->
    return this.slice(0, str.length) == str

if (typeof String::endsWith != 'function')
  String::endsWith = (str) ->
    return this.slice(-str.length) == str

if (typeof String::trim != 'function')
  String::trim = ->
    this.replace(/^\s+|\s+$/g, '')


# stack implementation

stack = []
types = []
sp = 0

stack_push = (v, t) ->
    stack[sp] = v
    types[sp] = t
    sp++

stack_pop = ->
    sp--
    stack[sp]

stack_depth = ->
    stack_push sp, TYPE_NUMBER

stack_swap = ->
    sp--
    ta = stack[sp]
    va = types[sp]
    sp--
    tb = stack[sp]
    vb = types[sp]
    stack_push ta, va
    stack_push tb, vb

stack_dup = ->
    if types[sp] == TYPE_STRING
        tb = stack[sp - 1]
        ta = slice_to_string tb
        tb = string_to_slice ta
        stack_push tb, TYPE_STRING
    else
        tb = stack[sp - 1]
        vb = types[sp - 1]
        stack_push tb, vb

stack_over = ->
    ta = stack[sp - 2]
    va = types[sp - 2]
    stack_push ta, va

stack_tuck = ->
    stack_dup()
    ta = stack[sp - 1]
    va = types[sp - 1]
    stack_pop()
    stack_swap()
    stack_push ta, va

#
# TODO: this is one of the larger functions (apart from
#       the compiler and interpreter)
#

stack_convert_type = (type) ->
    if type == TYPE_NUMBER
        if types[sp - 1] == TYPE_STRING
            s = slice_to_string stack[sp - 1]
            if !isNaN(parseFloat(s, 10)) && isFinite(s)
                stack_push parseFloat(slice_to_string stack_pop()), TYPE_NUMBER
            else
                stack_pop()
                stack_push 0, TYPE_NUMBER
        else
            types[sp - 1] = TYPE_NUMBER
    else if type == TYPE_STRING
        if types[sp - 1] == TYPE_NUMBER
            console.log stack[sp - 1]
            stack_push string_to_slice(stack_pop().toString()), TYPE_STRING
        else if types[sp - 1] == TYPE_CHARACTER
            stack_push string_to_slice('' + chr(stack_pop())), TYPE_STRING
        else if types[sp - 1] == TYPE_FLAG
            s = stack_pop()
            if s == -1
                stack_push string_to_slice('true'), TYPE_STRING
            else if s == 0
                stack_push string_to_slice('false'), TYPE_STRING
            else
                stack_push string_to_slice('malformed flag'), TYPE_STRING
        else if types[sp - 1] == TYPE_FUNCTION
            types[sp - 1] = TYPE_STRING
        else
            return 0
    else if type == TYPE_CHARACTER
        if types[sp - 1] == TYPE_STRING
            s = slice_to_string stack_pop()
            stack_push s.charCodeAt(0), TYPE_CHARACTER
        else
            s = stack_pop()
            stack_push parseFloat(s), TYPE_CHARACTER
    else if type == TYPE_FUNCTION
        types[sp - 1] = TYPE_FUNCTION
    else if type == TYPE_FLAG
        if types[sp - 1] == TYPE_STRING
            s = slice_to_string stack_pop()
            if s == 'true'
                stack_push -1, TYPE_FLAG
            else if s == 'false'
                stack_push 0, TYPE_FLAG
            else
                stack_push 1, TYPE_FLAG
        else
            s = stack_pop()
            stack_push s, TYPE_FLAG
    else
        return


# p_slices contains an array of slices
#
# p_map is an array that indicates which arrays in p_slices
# are being used.

p_slices = []
p_map = []


# request_slice()
# returns a new slice identifier and marks the returned slice
# as being used

request_slice = ->
    i = 0
    while i < MAX_SLICES
        if p_map[i] == 0
            p_map[i] = 1
            return i
        i++
    return -1


# release_slice(identifier)
# marks a slice as no longer in use

release_slice = (s) ->
    p_map[s] = 0


# copy_slice(source, dest)
# copies the contents of the source slice into the destination
# slice

copy_slice = (s, d) ->
    i = 0
    while i < SLICE_LEN
        store fetch(d, i), s, i
        i++


# prepare_slices()
# fill the p_slices with arrays and zero out the p_map

prepare_slices = ->
    i = 0
    while i < MAX_SLICES
        p_slices[i] = []
        p_map[i] = 0
        i++


# store(value, slice, offset)
# store the specified value into the specified offset of the
# specified slice

store = (v, s, o) ->
    p_slices[s][o] = v


# fetch(slice, offset)
# retrieve a stored value from the specified offset of the
# specified slice

fetch = (s, o) ->
    return p_slices[s][o]


# compile(source, slice)
# parse and compile the code in *source* into the specified
# slice

compile = (src, s) ->
    # console.log src + " (in slice #{s})"
    src = src.replace(/(\r\n|\n|\r)/gm, " ")
    src = src.replace(/\s+/g, " ")
    src = src.split(" ")
    slice = s
    quotes = []
    i = 0
    offset = 0
    while i < src.length
        if src[i] == '['
            quotes.push slice
            quotes.push offset
            offset = 0
            slice = request_slice()
        else if src[i] == ']'
            old = slice
            store BC_FLOW_RETURN, slice, offset
            offset = quotes.pop()
            slice = quotes.pop()
            store BC_PUSH_F, slice, offset
            offset++
            store old, slice, offset
            offset++
        else if src[i].startsWith '`'
            store parseFloat(src[i].substring(1)), slice, offset
            offset++
        else if src[i].startsWith '#'
            store BC_PUSH_N, slice, offset
            offset++
            store parseFloat(src[i].substring(1)), slice, offset
            offset++
        else if src[i].startsWith '$'
            store(BC_PUSH_C, slice, offset)
            offset++
            store src[i].substring(1).charCodeAt(0), slice, offset
            offset++
        else if src[i].startsWith '&'
            console.log 'BC_PUSH_F ' + src[i]
            store(BC_PUSH_F, slice, offset)
            offset++
            store(src[i].substring(1), slice, offset)
            offset++
        else if src[i].startsWith "'"
            if src[i].endsWith "'"
                s = src[i]
            else
                s = src[i]
                f = 0
                while f is 0
                    i = i + 1
                    if src[i].endsWith "'"
                        s += " " + src[i]
                        f = 1
                    else
                        s += " " + src[i]
            store BC_PUSH_S, slice, offset
            offset++
            s = s[1 .. s.length - 2]
            m = string_to_slice(s)
            store m, slice, offset
            offset++
        else if src[i].startsWith '"'
            if src[i].endsWith '"'
                s = src[i]
            else
                s = src[i]
                f = 0
                while f is 0
                    i = i + 1
                    if src[i].endsWith '"'
                        s += " " + src[i]
                        f = 1
                    else
                        s += " " + src[i]
            store BC_PUSH_COMMENT, slice, offset
            offset++
            s = s[1 .. s.length - 2]
            m = string_to_slice(s)
            store m, slice, offset
            offset++
        else
            if lookup_pointer(src[i]) == -1
                console.log 'UNHANDLED TOKEN: ' + src[i]
            else
                store BC_FLOW_CALL, slice, offset
                offset++
                store lookup_pointer(src[i]), slice, offset
                offset++
        i++
    store BC_FLOW_RETURN, slice, offset
    slice


#
#
#

dictionary_names = []
dictionary_slices = []


# add_definition(name, slice)
#

add_definition = (name, ptr) ->
    dictionary_names.push(name)
    dictionary_slices.push(ptr)
    return 0


# lookup_pointer(name)
#

lookup_pointer = (name) ->
    index = 0
    found = -1
    name = name.toLowerCase()
    while index < dictionary_names.length
      if dictionary_names[index].toLowerCase() == name
        found = index
        index = dictionary_names.length
      index++
    dictionary_slices[found]


string_to_slice = (str) ->
    slice = request_slice()
    i = 0
    while i < str.length
      if str.charCodeAt(i) == '\n'
        store 92, slice, i
        i = i + 1
        store 110, slice, i
      else
        store str.charCodeAt(i), slice, i
      i = i + 1
    store 0, slice, i
    slice


slice_to_string = (slice) ->
    s = ""
    o = 0
    while fetch(slice, o) != 0
      s = s + String.fromCharCode fetch(slice, o)
      o = o + 1
    s.replace /\\n/g, '\n'
    s

# =============================================================

# interpret(slice)
#

interpret = (slice) ->
    offset = 0
    while offset < SLICE_LEN
        opcode = fetch slice, offset
        if opcode == BC_PUSH_N
            offset++
            value = fetch slice, offset
            stack_push value, TYPE_NUMBER
        if opcode == BC_PUSH_S
            offset++
            value = fetch slice, offset
            stack_push value, TYPE_STRING
        if opcode == BC_PUSH_C
            offset++
            value = fetch slice, offset
            stack_push value, TYPE_CHARACTER
        if opcode == BC_PUSH_F
            offset++
            value = fetch slice, offset
            stack_push value, TYPE_FUNCTION
        if opcode == BC_PUSH_COMMENT
            offset++
            value = fetch slice, offset
        if opcode == BC_TYPE_N
            stack_convert_type TYPE_NUMBER
        if opcode == BC_TYPE_S
            stack_convert_type TYPE_STRING
        if opcode == BC_TYPE_C
            stack_convert_type TYPE_CHARACTER
        if opcode == BC_TYPE_F
            stack_convert_type TYPE_FUNCTION
        if opcode == BC_TYPE_FLAG
            stack_convert_type TYPE_FLAG
        if opcode == BC_GET_TYPE
            stack_push types[sp - 1], TYPE_NUMBER
        if opcode == BC_ADD
            todo = 0
        if opcode == BC_SUBTRACT
            a = stack_pop()
            b = stack_pop()
            stack_push b - a, TYPE_NUMBER
        if opcode == BC_MULTIPLY
            a = stack_pop()
            b = stack_pop()
            stack_push b * a, TYPE_NUMBER
        if opcode == BC_DIVIDE
            a = stack_pop()
            b = stack_pop()
            stack_push (b / a), TYPE_NUMBER
        if opcode == BC_REMAINDER
            a = stack_pop()
            b = stack_pop()
            stack_push (b % a), TYPE_NUMBER
        if opcode == BC_FLOOR
            stack_push Math.floor(stack_pop()), TYPE_NUMBER
        if opcode == BC_BITWISE_SHIFT
            a = stack_pop()
            b = stack_pop()
            if a < 0
                stack_push b << a, TYPE_NUMBER
            else
                stack_push b >>= a, TYPE_NUMBER
        if opcode == BC_BITWISE_AND
            a = stack_pop()
            b = stack_pop()
            stack_push a & b, TYPE_NUMBER
        if opcode == BC_BITWISE_OR
            a = stack_pop()
            b = stack_pop()
            stack_push a | b, TYPE_NUMBER
        if opcode == BC_BITWISE_XOR
            a = stack_pop()
            b = stack_pop()
            stack_push a ^ b, TYPE_NUMBER
        if opcode == BC_COMPARE_LT
            a = stack_pop()
            b = stack_pop()
            if b < a
                stack_push -1, TYPE_FLAG
            else
                stack_push 0, TYPE_FLAG
        if opcode == BC_COMPARE_GT
            a = stack_pop()
            b = stack_pop()
            if b > a
                stack_push -1, TYPE_FLAG
            else
                stack_push 0, TYPE_FLAG
        if opcode == BC_COMPARE_LTEQ
            a = stack_pop()
            b = stack_pop()
            if b == a || b < a
                stack_push -1, TYPE_FLAG
            else
                stack_push 0, TYPE_FLAG
        if opcode == BC_COMPARE_GTEQ
            a = stack_pop()
            b = stack_pop()
            if b == a || b > a
                stack_push -1, TYPE_FLAG
            else
                stack_push 0, TYPE_FLAG
        if opcode == BC_COMPARE_EQ
            todo = 0
        if opcode == BC_COMPARE_NEQ
            todo = 0
        if opcode == BC_FLOW_IF
            qt = stack_pop()
            qf = stack_pop()
            f  = stack_pop()
            if f == -1
                interpret qt
            else
                interpret qf
        if opcode == BC_FLOW_WHILE
            qt = stack_pop()
            f  = -1
            while f == -1
                interpret qt
                f = stack_pop()
        if opcode == BC_FLOW_UNTIL
            qt = stack_pop()
            f  = 0
            while f == 0
                interpret qt
                f = stack_pop()
        if opcode == BC_FLOW_TIMES
            qt = stack_pop()
            f  = stack_pop()
            while (f--) > 0
                interpret qt
        if opcode == BC_FLOW_CALL
            offset++
            target = fetch slice, offset
            interpret target
        if opcode == BC_FLOW_CALL_F
            target = stack_pop()
            interpret target
        if opcode == BC_FLOW_DIP
            target = stack_pop()
            vt = types[sp - 1]
            vd = stack_pop()
            interpret target
            stack_push vd, vt
        if opcode == BC_FLOW_SIP
            target = stack_pop()
            stack_dup()
            vt = types[sp - 1]
            vd = stack_pop()
            interpret target
            stack_push vd, vt
        if opcode == BC_FLOW_BI
            q1 = stack_pop()
            q2 = stack_pop()
            stack_dup()
            vt = types[sp - 1]
            vd = stack_pop()
            interpret q2
            stack_push vd, vt
            interpret q1
        if opcode == BC_FLOW_TRI
            q1 = stack_pop()
            q2 = stack_pop()
            q3 = stack_pop()
            stack_dup()
            vt = types[sp - 1]
            vd = stack_pop()
            interpret q3
            stack_push vd, vt
            interpret q2
            stack_push vd, vt
            interpret q1
        if opcode == BC_FLOW_RETURN
            offset = SLICE_LEN
        if opcode == BC_MEM_COPY
            todo = 0
        if opcode == BC_MEM_FETCH
            a = stack_pop()   # offset
            b = stack_pop()   # slice
            stack_push fetch( b, a), TYPE_NUMBER
        if opcode == BC_MEM_STORE
            todo = 0
        if opcode == BC_MEM_REQUEST
            stack_push request_slice(), TYPE_FUNCTION
        if opcode == BC_MEM_RELEASE
            release_slice stack_pop()
        if opcode == BC_MEM_COLLECT
            todo = 0
        if opcode == BC_STACK_DUP
            stack_dup()
        if opcode == BC_STACK_DROP
            stack_pop()
        if opcode == BC_STACK_SWAP
            stack_swap()
        if opcode == BC_STACK_OVER
            stack_over()
        if opcode == BC_STACK_TUCK
            stack_tuck()
        if opcode == BC_STACK_NIP
            stack_swap()
            stack_pop()
        if opcode == BC_STACK_DEPTH
            stack_depth()
        if opcode == BC_STACK_CLEAR
            sp = 0
        if opcode == BC_QUOTE_NAME
            value = stack_pop()
            quote = stack_pop()
            name = slice_to_string value
            add_definition name, quote
        if opcode == BC_STRING_SEEK
            todo = 0
        if opcode == BC_STRING_SUBSTR
            todo = 0
        if opcode == BC_STRING_NUMERIC
            s = stack_pop()
            s = slice_to_string s
            if !isNaN(parseFloat(s, 10)) && isFinite(s)
                stack_push -1, TYPE_FLAG
            else
                stack_push 0, TYPE_FLAG
        if opcode == BC_TO_LOWER
            todo = 0
        if opcode == BC_TO_UPPER
            todo = 0
        if opcode == BC_LENGTH
            f = slice_to_string stack[sp - 1]
            stack_push f.length, TYPE_NUMBER
        if opcode == BC_REPORT_ERROR
            console.log slice_to_string stack_pop()

        offset++
    return 0


# =============================================================

prepare_slices()
s = request_slice()
store BC_QUOTE_NAME, s, 0
store BC_FLOW_RETURN, s, 1
add_definition('define', s)

fs = require 'fs'

array = fs.readFileSync('bootstrap.p').toString().split("\n")
for i in array
    if i.length > 0
        interpret compile i, request_slice()

array = fs.readFileSync('test.p').toString().split("\n")
for i in array
    if i.length > 0
        interpret compile i, request_slice()

# console.log dictionary_names
if sp > 0
    console.log stack[0 .. (sp - 1)]
    console.log types[0 .. (sp - 1)]
    i = sp
    while i > 0
        i = i - 1
        if types[i] == TYPE_STRING
            console.log i, "'" + slice_to_string(stack[i]) + "'"
        else if types[i] == TYPE_CHARACTER
            console.log i, '$' + String.fromCharCode stack[i]
        else if types[i] == TYPE_FLAG
            if stack[i] == -1
                console.log i, 'flag: true'
            else if stack[i] == 0
                console.log i, 'flag: false'
            else
                console.log i, 'flag: malformed'
        else
            console.log i, stack[i]
console.log sp
