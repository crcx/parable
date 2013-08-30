# This implements a pretty minimal user interface for parable. It
# allows code (or a couple of commands) to be typed in, compiled,
# and run.
#
# Commands recognized are:
#
# :stack  display the stack
# :defined  display all named elements
# :quit  exit listener
#

import console
import sys

def dump_stack():
    """display the stack"""
    global stack
    i = 0
    while i < len(stack):
        console.set_color(0, 0, 0)
        print "\t" + str(i),
        if types[i] == TYPE_NUMBER:
            console.set_color(141/255.0, 182/255.0, 205/255.0)
            print "\t#" + str(stack[i])
        elif types[i] == TYPE_CHARACTER:
            console.set_color(139/255.0, 168/255.0, 112/255.0)
            print "\t$" + str(chr(stack[i]))
        elif types[i] == TYPE_STRING:
            console.set_color(140/255.0, 120/255.0, 83/255.0)
            print "\t'" + slice_to_string(stack[i]) +"'"
            console.set_color(0, 0, 0)
            print "\t\tstored at: " + str(stack[i])
        elif types[i] == TYPE_FUNCTION:
            console.set_color(143/255.0, 143/255.0, 188/255.0)
            print "\t&" + str(stack[i])
            if pointer_to_name(stack[i]) != "":
                console.set_color(0, 0, 0)
                print "\t\tpointer to: " + pointer_to_name(stack[i])
        elif types[i] == TYPE_FLAG:
            console.set_color(142/255.0, 35/255.0, 107/255.0)
            if stack[i] == -1:
                print "\ttrue"
            elif stack[i] == 0:
                print "\tfalse"
            else:
                print "\tmalformed flag"
        else:
            print "unmatched type on stack!"
        i += 1


def interface():
    global bootstrap
    global errors

    prepare_slices()
    prepare_dictionary()
    parse_bootstrap(bootstrap)
    collect_unused_slices()

    console.clear()

    completed = 0
    counter = 0

    while completed == 0:

        console.clear()

        dump_stack()

        for e in errors:
            console.set_color(214/255.0, 111/255.0, 98/255.0)
            print e

        clear_errors()

        console.set_color(0, 0, 0)

        src = sys.stdin.readline()

        if ' '.join(src.split()) == ':quit':
            completed = 1
        else:
            if len(src) > 0:
                interpret(compile(src, request_slice()))

        counter += 1
        if counter > 100:
            if len(stack) == 0:
                collect_unused_slices()
                counter = 0


#
# begin execution
#

interface()
