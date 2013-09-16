# parable
# Copyright (c) 2012, 2013, Charles Childers
# ====================================================================
# a decompiler
# since the compiler only uses a small subset of the byte codes, it is
# pretty easy to generate a (mostly) accurate representation of the
# original source.
#

from parable import *


def pointer_to_name(ptr):
    """given a parable pointer, return the corresponding name, or"""
    """an empty string"""
    global dictionary_names, dictionary_slices
    s = ""
    if ptr in dictionary_slices:
        s = dictionary_names[dictionary_slices.index(ptr)]
    return s


def deconstruct(slice):
    """return a string containing the source code for a given slice"""
    global SLICE_LEN
    i = 0
    s = '[ '
    while i < SLICE_LEN:
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


def generate_source():
    """return a string containing full source code for all named slices and"""
    """their dependencies"""
    global dictionary_names, dictionary_slices
    src = ""
    for s in dictionary_slices:
        src += deconstruct(s)
        src += " '" + pointer_to_name(s)
        src += "' define\n"
    return src + "\n"
