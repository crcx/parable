#!/usr/bin/env python

# Listener: a basic UI for Parable
# Copyright (c) 2013, 2015  Charles Childers
#

import os
import sys
import parable


def display_item(prefix, value):
    sys.stdout.write('\t' + prefix + str(value))

def dump_stack():
    """display the stack"""
    i = 0
    while i < len(parable.stack):
        tos = parable.stack[i]
        type = parable.types[i]
        sys.stdout.write("\t" + str(i))
        if type == parable.TYPE_NUMBER:
            display_item('#', tos)
        elif type == parable.TYPE_CHARACTER:
            display_item('$', chr(tos))
        elif type == parable.TYPE_STRING:
            display_item('\'', parable.slice_to_string(tos) + '\'')
        elif type == parable.TYPE_POINTER:
            display_item('&', tos)
        elif type == parable.TYPE_COMMENT:
            display_item('"', parable.slice_to_string(tos) + '"')
        elif type == parable.TYPE_FLAG:
            if tos == -1:
                display_item("", "true")
            elif tos == 0:
                display_item("", "false")
            else:
                display_item("", "malformed flag")
        else:
            display_item("", "unmatched type on the stack")
        sys.stdout.write("\n")
        i += 1


def dump_dict():
    """display named items"""
    l = ''
    for w in parable.dictionary_names:
        l = l + w + ' '
    sys.stdout.write(l)
    sys.stdout.write("\n")


def opcodes(slice, offset, opcode):
    if opcode == 9000:
        dump_stack()
    elif opcode == 9001:
        exit()
    elif opcode == 9002:
        dump_dict()
    elif opcode == 9003:
        name = parable.slice_to_string(parable.stack_pop())
        if os.path.exists(name):
            lines = parable.condense_lines(open(name).readlines())
            for l in lines:
                slice = parable.request_slice()
                parable.interpret(parable.compile(l, slice), opcodes)

    return offset


def evaluate(s):
    parable.interpret(parable.compile(s, parable.request_slice()))


def get_input():
    done = 0
    s = ''
    while done == 0:
        s = s + sys.stdin.readline()
        if s.endswith(' \\\n'):
            s = s[:-2].strip() + ' '
        else:
            done = 1
    return s


if __name__ == '__main__':
    print 'Parable Listener, (c) 2013-2016 Charles Childers'
    print '------------------------------------------------'
    print '.s       Display Stack'
    print 'bye      Exit Listener'
    print 'words    Display a list of all named items'
    print '------------------------------------------------\n'

    parable.prepare_slices()
    parable.prepare_dictionary()
    parable.parse_bootstrap(open('stdlib.p').readlines())

    evaluate("[ \"-\"   `9000 ] '.s' define")
    evaluate("[ \"-\"   `9001 ] 'bye' define")
    evaluate("[ \"-\"   `9002 ] 'words' define")
    evaluate("[ \"s-\"   `9003 ] 'include' define")

    while 1 == 1:
        sys.stdout.write("\ninput> ")
        sys.stdout.flush()

        src = get_input()

        if len(src) > 1:
            slice = parable.request_slice()
            parable.interpret(parable.compile(src, slice), opcodes)

        for e in parable.errors:
            sys.stdout.write(e)

        parable.clear_errors()
        sys.stdout.flush()
