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

import sys
import console

def dump_stack():
    """display the stack"""
    global stack
    i = 0
    while i < len(stack):
        console.set_color(0, 0, 0)
        print "\t" + str(i),
        if types[i] == TYPE_NUMBER:
            console.set_color(141/255, 182/255, 205/255)
            print "\t#" + str(stack[i])
        elif types[i] == TYPE_CHARACTER:
            console.set_color(139/255, 168/255, 112/255)
            print "\t$" + str(chr(stack[i]))
        elif types[i] == TYPE_STRING:
            console.set_color(140/255, 120/255, 83/255)
            print "\t'" + slice_to_string(stack[i]) +"'"
            console.set_color(0, 0, 0)
            print "\t\tstored at: " + str(stack[i])
        elif types[i] == TYPE_FUNCTION:
            console.set_color(143/255, 143/255, 188/255)
            print "\t&" + str(stack[i])
            if pointer_to_name(stack[i]) != "":
                console.set_color(0, 0, 0)
                print "\t\tpointer to: " + pointer_to_name(stack[i])
        elif types[i] == TYPE_FLAG:
            console.set_color(142/255, 35/255, 107/255)
            if stack[i] == -1:
                print "true"
            elif stack[i] == 0:
                print "false"
            else:
                print "malformed flag"
        else:
            print "unmatched type on stack!"
        i += 1


def dump_dict():
    """display named items"""
    l = ''
    for w in dictionary_names:
        l = l + w + ' '
    print l



def interface():
    global bootstrap

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

        console.set_color(0, 0, 0)

        print '- - - - - - - - - -'

        for e in errors:
            console.set_color(214/255, 111/255, 98/255)
            print e

        if (len(errors) > 0):
            print '- - - - - - - - - -'

        clear_errors()

        sys.stdout.flush()

        src = sys.stdin.readline()

        if ' '.join(src.split()) == ':quit':
            completed = 1
        elif ' '.join(src.split()) == ':defined':
            dump_dict()
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
