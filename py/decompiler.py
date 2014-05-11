# parable byte code decompiler
# Copyright (c) 2014, Charles Childers

from parable import *

def pointer_to_name(ptr):
    global dictionary_names, dictionary_slices
    s = ""
    if ptr in dictionary_slices:
        s = dictionary_names[dictionary_slices.index(ptr)]
    return s


def deconstruct(slice):
    global SLICE_LEN
    i = 0
    s = '[ '
    while i < (SLICE_LEN - 1):
        o = fetch(slice, i)
        if o == BC_PUSH_N:
            i += 1
            o = fetch(slice, i)
            s += '#' + str(o)
        elif o == BC_PUSH_C:
            i += 1
            o = fetch(slice, i)
            s += '$' + str(chr(o))
        elif o == BC_PUSH_S:
            i += 1
            o = fetch(slice, i)
            s += "'" + slice_to_string(o) + "'"
        elif o == BC_PUSH_COMMENT:
            i += 1
            o = fetch(slice, i)
            s += '"' + slice_to_string(o) + '"'
        elif o == BC_PUSH_F:
            i += 1
            o = fetch(slice, i)
            x = pointer_to_name(o)
            if len(x) == 0:
                s += deconstruct(o)
            else:
                s += '&' + x
        elif o == BC_FLOW_CALL:
            i += 1
            o = fetch(slice, i)
            x = pointer_to_name(o)
            if len(x) == 0:
                s += '&' + str(o) + ' invoke'
            else:
                s += x
        elif o == BC_FLOW_RETURN:
            i = SLICE_LEN
        else:
            s += '`' + str(o)
        s += ' '
        i += 1
    s += ']'
    return s


def trace(s):
    deps = set()
    deps.add(s)
    for x in find_references(s):
        deps.add(x)
        for i in find_references(x):
            deps.add(i)
    return deps


def generate_source(x):
    global dictionary_names, dictionary_slices
    src = ""
    for s in sorted(trace(x)):
        if pointer_to_name(s) != 'define':
            if pointer_to_name(s) != '':
                src += "[ ] '" + pointer_to_name(s) + "' define\n"
                src += deconstruct(s)
                src += " '" + pointer_to_name(s)
                src += "' define\n"
    return src + "\n"

def generate_full_source():
    global dictionary_names, dictionary_slices
    src = ""
    for s in dictionary_slices:
        if pointer_to_name(s) != 'define':
            src += "[ ] '" + pointer_to_name(s) + "' define\n"
            src += deconstruct(s)
            src += " '" + pointer_to_name(s)
            src += "' define\n"
    return src + "\n"
