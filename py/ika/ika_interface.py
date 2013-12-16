import sys, os

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


def display_errors():
    for e in errors:
        sys.stdout.write("\n" + e)
    clear_errors()

files = []

def opcodes(slice, offset, opcode):
    global files, TYPE_NUMBER
    if opcode == 1000:
        display_value()
        stack_pop()
        sys.stdout.flush()
    elif opcode == 2000:
        slot = 0
        i = 1
        while i < 8:
            if files[i] == 0:
                slot = i
            i = i + 1
        mode = slice_to_string(stack_pop())
        name = slice_to_string(stack_pop())
        if slot != 0:
            files[int(slot)] = open(name, mode)
        stack_push(slot, TYPE_NUMBER)
    elif opcode == 2001:
        slot = int(stack_pop())
        files[slot].close()
        files[slot] = 0
    elif opcode == 2002:
        slot = int(stack_pop())
        stack_push(ord(files[slot].read(1)), TYPE_NUMBER)
    elif opcode == 2003:
        slot = int(stack_pop())
        files[slot].write(chr(int(stack_pop())))
    elif opcode == 2004:
        slot = int(stack_pop())
        stack_push(files[slot].tell(), TYPE_NUMBER)
    elif opcode == 2005:
        slot = int(stack_pop())
        pos = int(stack_pop())
        stack_push(files[slot].seek(pos, 0), TYPE_NUMBER)
    elif opcode == 2006:
        slot = int(stack_pop())
        at = files[slot].tell()
        files[slot].seek(0, 2) # SEEK_END
        stack_push(files[slot].tell(), TYPE_NUMBER)
        files[slot].seek(at, 0) # SEEK_SET
    elif opcode == 2007:
        name = slice_to_string(stack_pop())
        if os.path.exists(name):
            os.remove(name)
    elif opcode == 2008:
        name = slice_to_string(stack_pop())
        if os.path.exists(name):
            stack_push(-1, TYPE_FLAG)
        else:
            stack_push(0, TYPE_FLAG)
    elif opcode == 3000:
        stack_push(len(sys.argv) - 2, TYPE_NUMBER)
    elif opcode == 3001:
        n = int(stack_pop())
        stack_push(string_to_slice(sys.argv[n + 2]), TYPE_STRING)
    return offset


def load_file(file):
    f = open(file).readlines()
    for line in f:
        if len(line) > 1:
            if not line.startswith("#!"):
                s = compile(line, request_slice())
                interpret(s, opcodes)
                display_errors()


if __name__ == '__main__':
    prepare_slices()
    prepare_dictionary()
    parse_bootstrap(bootstrap)
    collect_unused_slices()

    files.append(0)
    files.append(0)
    files.append(0)
    files.append(0)
    files.append(0)
    files.append(0)
    files.append(0)
    files.append(0)

    if len(sys.argv) < 2:
        sys.exit('Usage: %s filename(s) [script arguments]' % sys.argv[0])

    if not os.path.exists(sys.argv[1]):
        sys.exit('ERROR: source file "%s" was not found!' % sys.argv[1])
    load_file(sys.argv[1])
    dump_stack()
#    sys.stdout.write('\n')
