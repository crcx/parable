# parable
# copyright (c) 2012 - 2014, charles childers
# =============================================================

# Known issues/remaining to-do:
#
# - source is poorly commented at this point


# =============================================================
# Configuration

MAX_SLICES = 64000     # The maximum number of slices
SLICE_LEN = 1000       # The maximum length of a slice


# =============================================================
# Add some new functionality to String and Array objects

if (typeof String::startsWith != 'function')
  String::startsWith = (str) ->
    return this.slice(0, str.length) == str

if (typeof String::endsWith != 'function')
  String::endsWith = (str) ->
    return this.slice(-str.length) == str

if (typeof String::trim != 'function')
  String::trim = ->
    this.replace(/^\s+|\s+$/g, '')

Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output


# =============================================================
# Constants for data types

TYPE_NUMBER = 100
TYPE_STRING = 200
TYPE_CHARACTER= 300
TYPE_FUNCTION = 400
TYPE_FLAG = 500


# =============================================================
# Constants for byte codes

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


# =============================================================
# error log
log = []

report_error = (text) ->
    log.push text


# =============================================================
# stack implementation
#
# notes:
# - TOS is at [sp - 1]
# - NOS is at [sp - 2]

stack = []     # Array; holds stack values
types = []     # Array; holds type constants for values
sp = 0         # Stack Pointer


# stack_push(value, type)
# Push a value with the specified type to the stack.
stack_push = (v, t) ->
    stack[sp] = v
    types[sp] = t
    sp++


# stack_pop()
# Remove (and return) a value on the stack.
stack_pop = ->
    sp--
    stack[sp]


# stack_depth()
# Push the current number of items on the stack to the stack.
stack_depth = ->
    stack_push sp, TYPE_NUMBER


# stack_swap()
# Exchange the positions of TOS and NOS.
stack_swap = ->
    sp--
    ta = stack[sp]
    va = types[sp]
    sp--
    tb = stack[sp]
    vb = types[sp]
    stack_push ta, va
    stack_push tb, vb


# stack_dup()
# Duplicate the top value on the stack. If top value is of
# TYPE_STRING it makes a copy of the string as opposed to
# a copy of the pointer.
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


# stack_over()
#
stack_over = ->
    ta = stack[sp - 2]
    va = types[sp - 2]
    stack_push ta, va


# stack_tuck()
#
stack_tuck = ->
    stack_dup()
    ta = stack[sp - 1]
    va = types[sp - 1]
    stack_pop()
    stack_swap()
    stack_push ta, va


# stack_convert_type(type)
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
            stack_push string_to_slice(stack_pop().toString()), TYPE_STRING
        else if types[sp - 1] == TYPE_CHARACTER
            stack_push string_to_slice(String.fromCharCode(stack_pop())), TYPE_STRING
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


# =============================================================
# memory regions
#
# notes:
# - p_map[sliceid] == 1 for allocated, 0 for unused


p_slices = []        # array of slices
p_map = []           # array indicating which slices in the
                     # p_slices are in use


# copy_slice(source, dest)
# Copy the contents of the source slice into the destination
# slice.
copy_slice = (source, dest) ->
    i = 0
    while i < SLICE_LEN
        v = fetch source, i
        store v, dest, i
        i++

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


# =============================================================
# garbage collector

# gather_references(slice)
# return an array of all values contained in a given slice
gather_references = (s) ->
    refs = []
    i = 0
    while i < SLICE_LEN
        p = fetch s, i
        if p >= 0
            if refs.indexOf(p) == -1
                refs.push p
        i++
    refs.push s
    refs


# seek_all_references()
# return an array of all identified possibly used slices
seek_all_references = ->
    maybe = []
    for s in dictionary_slices
        for k in gather_references s
            if maybe.indexOf(k) == -1
                maybe.push k
    maybe


# collect_garbage()
# a conservative garbage collector
# scans all named slices for values that might correspond to a
# an allocated slice. frees anything that is allocated but not
# referred to.
collect_unused_slices = ->
    refs = seek_all_references().sort()
    i = 0
    while i < MAX_SLICES
        if (p_map[i] == 1) && (refs.indexOf(i) == -1)
            release_slice i
        i++


# =============================================================
# compiler

# compile(source, slice)
# parse and compile the code in *source* into the specified
# slice
compile = (src, s) ->
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
            store(BC_PUSH_F, slice, offset)
            offset++
            if lookup_pointer(src[i].substring(1)) == -1
                store parseFloat(src[i].substring(1)), slice, offset
            else
                store lookup_pointer(src[i].substring(1)), slice, offset
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
                report_error src[i] + ' not found in dictionary'
            else
                store BC_FLOW_CALL, slice, offset
                offset++
                store lookup_pointer(src[i]), slice, offset
                offset++
        i++
    store BC_FLOW_RETURN, slice, offset
    slice


# =============================================================
# dictionary

dictionary_names = []
dictionary_slices = []


# add_definition(name, slice)
# Add a name for a given slice to the dictionary. If the name
# is already present, replaces its definition with the code in
# the new slice.
add_definition = (name, ptr) ->
    if lookup_pointer(name) == -1
        dictionary_names.push(name)
        dictionary_slices.push(ptr)
    else
        copy_slice ptr, lookup_pointer name
    return 0


# lookup_pointer(name)
# Returns a pointer to the slice corresponding to name. If no
# match is found, returns -1
lookup_pointer = (name) ->
    index = 0
    found = -1
    name = name.toLowerCase()
    while index < dictionary_names.length
      if dictionary_names[index].toLowerCase() == name
        found = index
        index = dictionary_names.length
      index++
    if found == -1
        return -1
    else
        return dictionary_slices[found]


# pointer_to_name(ptr)
# Returns a string containing the name corresponding to the
# pointer, or an empty string if no match is found
pointer_to_name = (ptr) ->
    i = 0
    s = ''
    while i < dictionary_names.length
        if dictionary_slices[i] == ptr
            s = dictionary_names[i]
        i++
    s


# prepare_dictionary()
# Sets up an initial dictionary so that the 'define' function
# is available for bootstrap purposes.
prepare_dictionary = ->
    s = request_slice()
    store BC_QUOTE_NAME, s, 0
    store BC_FLOW_RETURN, s, 1
    add_definition('define', s)


# =============================================================

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
      o++
    s.replace /\\n/g, '\n'
    s

# =============================================================
# byte code interpreter

# interpret(slice)
# Interprets the byte codes in a specified slice.
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
            ta = types[sp - 1]
            tb = types[sp - 2]
            va = stack_pop()
            vb = stack_pop()
            if ta == tb && ta == TYPE_STRING
                va = slice_to_string va
                vb = slice_to_string vb
                stack_push string_to_slice(vb + va), TYPE_STRING
            else
                stack_push vb + va, TYPE_NUMBER
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
                stack_push b << Math.abs(a), TYPE_NUMBER
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
            ta = types[sp - 1]
            tb = types[sp - 2]
            va = stack_pop()
            vb = stack_pop()
            if (ta == TYPE_STRING) && (tb == TYPE_STRING)
                va = slice_to_string va
                vb = slice_to_string vb
            if va == vb
                stack_push -1, TYPE_FLAG
            else
                stack_push 0, TYPE_FLAG
        if opcode == BC_COMPARE_NEQ
            ta = types[sp - 1]
            tb = types[sp - 2]
            va = stack_pop()
            vb = stack_pop()
            if (ta == TYPE_STRING) && (tb == TYPE_STRING)
                va = slice_to_string va
                vb = slice_to_string vb
            if va != vb
                stack_push -1, TYPE_FLAG
            else
                stack_push 0, TYPE_FLAG
        if opcode == BC_FLOW_IF
            qf = stack_pop()
            qt = stack_pop()
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
            dest = stack_pop()
            source = stack_pop()
            copy_slice source, dest
        if opcode == BC_MEM_FETCH
            a = stack_pop()   # offset
            b = stack_pop()   # slice
            stack_push fetch( b, a), TYPE_NUMBER
        if opcode == BC_MEM_STORE
            a = stack_pop()   # offset
            b = stack_pop()   # slice
            c = stack_pop()   # value
            store c, b, a
        if opcode == BC_MEM_REQUEST
            stack_push request_slice(), TYPE_FUNCTION
        if opcode == BC_MEM_RELEASE
            release_slice stack_pop()
        if opcode == BC_MEM_COLLECT
            collect_unused_slices()
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
            a = slice_to_string stack_pop()
            b = slice_to_string stack_pop()
            stack_push b.indexOf(a), TYPE_NUMBER
        if opcode == BC_STRING_SUBSTR
            len = stack_pop()
            start = stack_pop()
            s0 = slice_to_string stack_pop()
            s1 = s0.substr start, len
            stack_push string_to_slice(s1), TYPE_STRING
        if opcode == BC_STRING_NUMERIC
            s = stack_pop()
            s = slice_to_string s
            if !isNaN(parseFloat(s, 10)) && isFinite(s)
                stack_push -1, TYPE_FLAG
            else
                stack_push 0, TYPE_FLAG
        if opcode == BC_TO_LOWER
            if types[sp - 1] == TYPE_STRING
                a = slice_to_string stack_pop()
                stack_push string_to_slice(a.toLowerCase()), TYPE_STRING
            if types[sp - 1] == TYPE_CHARACTER
                a = String.fromCharCode stack_pop()
                b = a.toLowerCase()
                stack_push b.charCodeAt(0), TYPE_CHARACTER
        if opcode == BC_TO_UPPER
            if types[sp - 1] == TYPE_STRING
                a = slice_to_string stack_pop()
                stack_push string_to_slice(a.toUpperCase()), TYPE_STRING
            if types[sp - 1] == TYPE_CHARACTER
                a = String.fromCharCode stack_pop()
                b = a.toUpperCase()
                stack_push b.charCodeAt(0), TYPE_CHARACTER
        if opcode == BC_LENGTH
            f = slice_to_string stack[sp - 1]
            stack_push f.length, TYPE_NUMBER
        if opcode == BC_REPORT_ERROR
            report_error slice_to_string stack_pop()

        offset++
    return 0


# =============================================================
# final helper functions

# prepare()
# setup memory and initial dictionary
prepare = ->
    prepare_slices()
    prepare_dictionary()


# compile_source(array)
# compile the source in each line of an array
compile_source = (array) ->
    for i in array
        if i.length > 0
            interpret compile i.trim(), request_slice()
