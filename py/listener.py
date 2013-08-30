# Copyright (c) 2013  Charles Childers
#
# This implements a pretty minimal user interface for parable. It
# allows code (or a couple of commands) to be typed in, compiled,
# and run.
#
# Commands recognized are:
#
# .s     display the stack
# words  display all named elements
# bye    exit listener
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



if __name__ == '__main__':
    sys.stdout.write("parable (listener 2013-05-24)\n")
    sys.stdout.write("Type bye to exit, words for a list of functions, or")
    sys.stdout.write(" .s for a stack display\n")
    prepare_slices()
    prepare_dictionary()
    parse_bootstrap(open('bootstrap.p').readlines())

    while 1 == 1:
        sys.stdout.write("\nok ")
        sys.stdout.flush()

        src = sys.stdin.readline()

        if ' '.join(src.split()) == 'bye':
            exit()
        elif ' '.join(src.split()) == 'words':
            dump_dict()
        elif ' '.join(src.split()) == '.s':
            dump_stack()
        else:
            if len(src) > 1:
                interpret(compile(src, request_slice()))

        for e in errors:
            sys.stdout.write(e)

        clear_errors()
        sys.stdout.flush()
