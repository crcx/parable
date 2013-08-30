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
    global bootstrap
    console.clear()
    sys.stdout.write("parable for pythonista\n\n")
    prepare_slices()
    prepare_dictionary()
    parse_bootstrap(bootstrap)
    collect_unused_slices()

    completed = 0
    counter = 0

    while completed == 0:
        console.set_color(.16, .128, .112)
        sys.stdout.write("\n>> ")
        sys.stdout.flush()
        console.set_color(0, 0, 0)

        src = sys.stdin.readline()

        if ' '.join(src.split()) == ':quit':
            completed = 1
        elif ' '.join(src.split()) == ':defined':
            dump_dict()
        elif ' '.join(src.split()) == ':stack':
            dump_stack()
        else:
            if len(src) > 1:
                interpret(compile(src, request_slice()))

        for e in errors:
            sys.stdout.write(e)

        clear_errors()

        counter += 1
        if counter > 100:
            if len(stack) == 0:
                collect_unused_slices()
                counter = 0

        console.set_color(0, 0, 0)
        sys.stdout.flush()
