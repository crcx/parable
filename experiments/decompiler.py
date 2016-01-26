# parable byte code decompiler
# Copyright (c) 2014-2015, Charles Childers

import parable
import sys


def pointer_to_name(ptr):
    s = ""
    if ptr in parable.dictionary_slices:
        s = parable.dictionary_names[parable.dictionary_slices.index(ptr)]
    return s


def deconstruct(slice):
    i = 0
    s = '[ '
    while i <= parable.get_last_index(slice):
        o = parable.fetch(slice, i)
        t = parable.fetch_type(slice, i)
        if t == parable.TYPE_NUMBER:
            s += '#' + str(o)
        elif t == parable.TYPE_BYTECODE:
            s += '`' + str(o)
        elif t == parable.TYPE_CHARACTER:
            s += '$' + str(chr(o))
        elif t == parable.TYPE_STRING:
            s += "'" + parable.slice_to_string(o) + "'"
        elif t == parable.TYPE_COMMENT:
            s += "'\"" + parable.slice_to_string(o) + "\""
        elif t == parable.TYPE_POINTER:
            x = pointer_to_name(o)
            if len(x) == 0:
                s += deconstruct(o)
            else:
                s += '&' + x
        elif t == parable.TYPE_FUNCTION_CALL:
            x = pointer_to_name(o)
            if len(x) == 0:
                s += '&' + str(o) + ' invoke'
            else:
                s += x
        else:
            s += '`' + str(o)
        s += ' '
        i += 1
    s += ']'
    return s


def trace(s):
    deps = set()
    deps.add(s)
    for x in parable.find_references(s):
        deps.add(x)
        for i in parable.find_references(x):
            deps.add(i)
    return deps


def generate_source(x):
    src = ""
    for s in sorted(trace(x)):
        if pointer_to_name(s) != 'define':
            if pointer_to_name(s) != '':
                src += deconstruct(s)
                src += " '" + pointer_to_name(s)
                src += "' define\n"
    return src + "\n"


def generate_full_source():
    src = ""
    for s in parable.dictionary_slices:
        if pointer_to_name(s) != 'define':
            src += deconstruct(s)
            src += " '" + pointer_to_name(s)
            src += "' define\n"
    return src + "\n"


if __name__ == '__main__':
    parable.prepare_slices()
    parable.prepare_dictionary()
    parable.parse_bootstrap(open('stdlib.p').readlines())
    parable.collect_garbage()

    print generate_full_source().encode('utf-8')
