# Copyright (c) 2013, Charles Childers
#
# pre is the "parable runtime", a quick tool for running a parable
# program and displaying the results.
# ===================================================================

# Dependencies
import sys
from parable import *

def display_stack():
    global stack, types
    i = 0
    while i < len(stack):
        if i == len(stack) - 1:
            sys.stdout.write("TOS\t" + str(i))
        else:
            sys.stdout.write("\t" + str(i))

        if types[i] == TYPE_NUMBER:
            sys.stdout.write("\t#" + str(stack[i]))
        elif types[i] == TYPE_CHARACTER:
            sys.stdout.write("\t$" + str(chr(stack[i])))
        elif types[i] == TYPE_STRING:
            sys.stdout.write("\t'" + slice_to_string(stack[i]) + "'")
            sys.stdout.write("\n\t\tstored at: " + str(stack[i]))
        elif types[i] == TYPE_FUNCTION:
            sys.stdout.write("\t&" + str(stack[i]))
            if pointer_to_name(stack[i]) != "":
                sys.stdout.write("\n\t\tpointer to: " + pointer_to_name(stack[i]))
        elif types[i] == TYPE_FLAG:
            if stack[i] == -1:
                sys.stdout.write("\ttrue")
            elif stack[i] == 0:
                sys.stdout.write("\tfalse")
            else:
                sys.stdout.write("\tmalformed flag")
        else:
            sys.stdout.write("\tunmatched type on stack!")
        sys.stdout.write("\n")
        i += 1


def display_errors():
    for e in errors:
        sys.stdout.write("\n" + e)


def display():
    display_stack()
    display_errors()
    clear_errors()


def load_file(file):
    f = open(file).readlines()
    for line in f:
        if len(line) > 1:
            s = compile(line, request_slice())
            interpret(s)


if __name__ == '__main__':
    prepare_slices()
    prepare_dictionary()
    parse_bootstrap(open('bootstrap.p').readlines())
    collect_unused_slices()

    load_file(sys.argv[1])
    display()
    sys.stdout.flush()
