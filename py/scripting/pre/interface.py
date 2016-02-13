import sys, os
from os.path import expanduser

def display_stack(verbose):
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
            sys.stdout.write(("\t'" + slice_to_string(stack[i]) + "'"))
            if verbose == True:
                sys.stdout.write("\n\t\tstored at: " + str(stack[i]))
        elif types[i] == TYPE_POINTER:
            sys.stdout.write("\t&" + str(stack[i]))
            if verbose == True:
                if pointer_to_name(stack[i]) != "":
                    sys.stdout.write("\n\t\tpointer to: " + pointer_to_name(stack[i]))
        elif types[i] == TYPE_FLAG:
            if stack[i] == -1:
                sys.stdout.write("\ttrue")
            elif stack[i] == 0:
                sys.stdout.write("\tfalse")
            else:
                sys.stdout.write("\tmalformed flag")
        elif types[i] == TYPE_BYTECODE:
            sys.stdout.write("\t`" + str(stack[i]))
        elif types[i] == TYPE_REMARK:
            sys.stdout.write(("\t\"" + slice_to_string(stack[i]) + "\""))
            if verbose == True:
                sys.stdout.write("\n\t\tstored at: " + str(stack[i]))
        elif types[i] == TYPE_FUNCTION_CALL:
            sys.stdout.write("\tCALL: " + str(stack[i]))
        else:
            sys.stdout.write("\tunmatched type on stack!")
            if verbose == True:
                sys.stdout.write("\n\tRaw value: " + str(stack[i]))
                sys.stdout.write("\n\tType code: " + str(types[i]))
        sys.stdout.write("\n")
        i += 1


def display_errors():
    for e in errors:
        sys.stdout.write("\n" + e)
    sys.stdout.write("\n")


def display(verbose):
    display_stack(verbose)
    display_errors()
    clear_errors()


def load_file(file):
    if not os.path.exists(file):
        report('P00: File not found: ' + file)
    else:
        f = condense_lines(open(file).readlines())
        for line in f:
            if len(line) > 0:
                if not line.startswith("#!"):
                    s = compile(line, request_slice())
                    try:
                        interpret(s)
                    except:
                        pass


if __name__ == '__main__':
    prepare_slices()
    prepare_dictionary()
    parse_bootstrap(bootstrap)

    try:
        home = expanduser("~")
        src = home + "/.parable"
        parse_bootstrap(open(src).readlines())
    except:
        pass

    verbose = False

    if len(sys.argv) < 2:
        if os.path.exists('source.p'):
            load_file('source.p')
        else:
            sys.exit('Usage: %s filename(s)' % sys.argv[0])
    else:
        for source in sys.argv:
            if not os.path.exists(source) and source != "-v":
                sys.exit('ERROR: source file "%s" was not found!' % source)
            if source != sys.argv[0]:
                if source == "-v":
                    verbose = True
                else:
                    load_file(source)

    display(verbose)
    sys.stdout.flush()
