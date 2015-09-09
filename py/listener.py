#!/usr/bin/env python

# Copyright (c) 2013, 2015  Charles Childers
#
# This implements a pretty minimal user interface for parable. It
# allows code (or a couple of commands) to be typed in, compiled,
# and run.
#
# Commands recognized are:
#
# .              display the top value on the stack
# show-stack     display the stack
# show-named     display all named elements
# bye            exit listener
#
# Anything else is treated as parable code.
#
# For a nicer interface, try legend.py
#

import sys
from parable import *

def dump_stack():
    """display the stack"""
    global stack
    i = 0
    while i < len(stack):
        sys.stdout.write("\t" + str(i))
        if types[i] == TYPE_NUMBER:
            sys.stdout.write("\t#" + str(stack[i]))
        elif types[i] == TYPE_CHARACTER:
            sys.stdout.write("\t$" + str(chr(stack[i])))
        elif types[i] == TYPE_STRING:
            sys.stdout.write("\t'" + slice_to_string(stack[i]) +"'")
        elif types[i] == TYPE_POINTER:
            sys.stdout.write("\t&" + str(stack[i]))
        elif types[i] == TYPE_FLAG:
            if stack[i] == -1:
                sys.stdout.write("true")
            elif stack[i] == 0:
                sys.stdout.write("false")
            else:
                sys.stdout.write("malformed flag")
        else:
            sys.stdout.write("unmatched type on stack!")
        sys.stdout.write("\n")
        i += 1


def dump_dict():
    """display named items"""
    l = ''
    for w in dictionary_names:
        l = l + w + ' '
    sys.stdout.write(l)
    sys.stdout.write("\n")


def display_value():
    global stack, types
    i = len(stack) - 1
    if types[i] == TYPE_NUMBER:
        sys.stdout.write(str(stack[i]))
    elif types[i] == TYPE_CHARACTER:
        sys.stdout.write(str(chr(stack[i])))
    elif types[i] == TYPE_STRING:
        sys.stdout.write(slice_to_string(stack[i]))
    elif types[i] == TYPE_POINTER:
        sys.stdout.write('&' + str(stack[i]))
    elif types[i] == TYPE_FLAG:
        if stack[i] == -1:
            sys.stdout.write("true")
        elif stack[i] == 0:
            sys.stdout.write("false")
        else:
            sys.stdout.write("malformed flag")


def opcodes(slice, offset, opcode):
    if opcode == 9000:
        display_value()
        stack_pop()
    elif opcode == 9010:
        dump_stack()
    elif opcode == 9020:
        exit()
    elif opcode == 9030:
        dump_dict()

    return offset



if __name__ == '__main__':
    sys.stdout.write("parable (listener 2015-05-22)\n")
    sys.stdout.write('?              display the top value on the stack\n')
    sys.stdout.write('show-stack     display the stack\n')
    sys.stdout.write('show-named     display all named elements\n')
    sys.stdout.write('bye            exit listener\n')
    prepare_slices()
    prepare_dictionary()
    parse_bootstrap(open('stdlib.p').readlines())

    interpret(compile("[ `9000 ] '?' define", request_slice()))
    interpret(compile("[ `9010 ] 'show-stack' define", request_slice()))
    interpret(compile("[ `9020 ] 'bye' define", request_slice()))
    interpret(compile("[ `9030 ] 'show-named' define", request_slice()))

    while 1 == 1:
        sys.stdout.write("\nok ")
        sys.stdout.flush()

        src = sys.stdin.readline()

        if len(src) > 1:
            interpret(compile(src, request_slice()), opcodes)

        for e in errors:
            sys.stdout.write(e)

        clear_errors()
        sys.stdout.flush()
