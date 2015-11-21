import sys, os

def condenseLines(code):
    m = len(code)
    s = ''
    r = []
    i = 0
    c = 0
    while i < m:
        if code[i].endswith(' \\\n'):
            s = s + ' ' + code[i][:-2].strip()
            c = 1
        else:
            c = 0
            s = s + ' ' + code[i]
        if c == 0:
            if s != '' and s != ' \n':
                r.append(s.strip())
            s = ''
        i = i + 1
    return r


def display_stack(verbose):
    global stack, types
    i = 0
    while i < len(stack):
        if i == len(stack) - 1:
            sys.stdout.write("TOS\t" + unicode(i))
        else:
            sys.stdout.write("\t" + unicode(i))

        if types[i] == TYPE_NUMBER:
            sys.stdout.write("\t#" + unicode(stack[i]))
        elif types[i] == TYPE_CHARACTER:
            sys.stdout.write("\t$" + unicode(unichr(stack[i])))
        elif types[i] == TYPE_STRING:
            sys.stdout.write(("\t'" + slice_to_string(stack[i]) + "'").encode('utf-8'))
            if verbose == True:
                sys.stdout.write("\n\t\tstored at: " + unicode(stack[i]))
        elif types[i] == TYPE_POINTER:
            sys.stdout.write("\t&" + unicode(stack[i]))
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
            sys.stdout.write("\t`" + unicode(stack[i]))
        elif types[i] == TYPE_COMMENT:
            sys.stdout.write(("\t\"" + slice_to_string(stack[i]) + "\"").encode('utf-8'))
            if verbose == True:
                sys.stdout.write("\n\t\tstored at: " + unicode(stack[i]))
        elif types[i] == TYPE_FUNCTION_CALL:
            sys.stdout.write("\tCALL: " + unicode(stack[i]))
        else:
            sys.stdout.write("\tunmatched type on stack!")
            if verbose == True:
                sys.stdout.write("\n\tRaw value: " + unicode(stack[i]))
                sys.stdout.write("\n\tType code: " + unicode(types[i]))
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
    f = condenseLines(open(file).readlines())
    for line in f:
        if len(line) > 1:
            if not line.startswith("#!"):
                s = compile(line, request_slice())
                interpret(s)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        MAX_SLICES = 8000
    prepare_slices()
    prepare_dictionary()
    parse_bootstrap(bootstrap)
    collect_unused_slices()

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
