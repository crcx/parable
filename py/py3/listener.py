#!/usr/bin/env python

# Copyright (c) 2013  Charles Childers
#
# This implements a pretty minimal user interface for parable. It
# allows code (or a couple of commands) to be typed in, compiled,
# and run.
#
# Commands recognized are:
#
# show-stack (= .s in forth)            display the stack
# show-named (= words in forth)   display all named elements
# bye                                              exit listener
#
# Anything else is treated as parable code.
#
# kiy finds this more convenient than legend.py 
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
        elif types[i] == TYPE_FUNCTION:
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
    elif types[i] == TYPE_FUNCTION:
        sys.stdout.write('&' + str(stack[i]))
    elif types[i] == TYPE_FLAG:
        if stack[i] == -1:
            sys.stdout.write("true")
        elif stack[i] == 0:
            sys.stdout.write("false")
        else:
            sys.stdout.write("malformed flag")


def opcodes(slice, offset, opcode):
    if opcode == 1000:
        display_value()
        stack_pop()
    elif opcode == 1010:
        dump_stack()
    elif opcode == 1020:
        exit()
    elif opcode == 1030:
        dump_dict()

    return offset



if __name__ == '__main__':
    sys.stdout.write("parable (listener 2013-05-24)\n")
    sys.stdout.write("Type bye to exit, show-named for a list of functions, or")
    sys.stdout.write(" show-stack for a stack display\n")
    prepare_slices()
    prepare_dictionary()
    parse_bootstrap(open('bootstrap.p').readlines())

    interpret(compile("[ `1000 ] '.' define", request_slice()))
    interpret(compile("[ `1010 ] 'show-stack' define", request_slice()))
    interpret(compile("[ `1020 ] 'bye' define", request_slice()))
    interpret(compile("[ `1030 ] 'show-named' define", request_slice()))

    while 1 == 1:
        sys.stdout.write("\n> ")
        sys.stdout.flush()

        src = sys.stdin.readline()

        if len(src) > 1:
            interpret(compile(src, request_slice()), opcodes)
            
        for e in errors:
            sys.stdout.write(e)

        clear_errors()
        sys.stdout.flush()
