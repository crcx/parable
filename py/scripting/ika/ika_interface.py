import os
import sys


def dump_stack():
    """display the stack"""
    global stack, types
    i = 0
    while i < len(stack):
        sys.stdout.write("\t" + unicode(i))
        if types[i] == TYPE_NUMBER:
            sys.stdout.write("\t#" + unicode(stack[i]))
        elif types[i] == TYPE_CHARACTER:
            sys.stdout.write("\t$" + unicode(unichr(stack[i])))
        elif types[i] == TYPE_STRING:
            sys.stdout.write(("\t'" + slice_to_string(stack[i]) +"'").encode('utf-8'))
            sys.stdout.write("\n\t\tstored at: " + unicode(stack[i]))
        elif types[i] == TYPE_POINTER:
            sys.stdout.write("\t&" + unicode(stack[i]))
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
            sys.stdout.write("\n\t\tstored at: " + unicode(stack[i]))
        elif types[i] == TYPE_FUNCTION_CALL:
            sys.stdout.write("\tCALL: " + unicode(stack[i]))
        else:
            sys.stdout.write("\tunmatched type on stack!")
            sys.stdout.write("\n\tRaw value: " + unicode(stack[i]))
            sys.stdout.write("\n\tType code: " + unicode(types[i]))
        sys.stdout.write("\n")
        i += 1


def display_value():
    global stack, types
    i = len(stack) - 1
    if types[i] == TYPE_NUMBER:
        sys.stdout.write(unicode(stack[i]))
    elif types[i] == TYPE_CHARACTER:
        sys.stdout.write(unicode(unichr(stack[i])))
    elif types[i] == TYPE_STRING:
        sys.stdout.write(slice_to_string(stack[i]).encode('utf-8'))
    elif types[i] == TYPE_POINTER:
        sys.stdout.write('&' + unicode(stack[i]))
    elif types[i] == TYPE_FLAG:
        if stack[i] == -1:
            sys.stdout.write("true")
        elif stack[i] == 0:
            sys.stdout.write("false")
        else:
            sys.stdout.write("malformed flag")
    elif types[i] == TYPE_COMMENT:
        sys.stdout.write(slice_to_string(stack[i]).encode('utf-8'))
    elif types[i] == TYPE_BYTECODE:
        sys.stdout.write('`' + unicode(stack[i]))
    elif types[i] == TYPE_FUNCTION_CALL:
        sys.stdout.write('CALL: ' + unicode(stack[i]))
    else:
       sys.stdout.write("unknown type")


def display_errors():
    for e in errors:
        sys.stdout.write("\n" + e)
    clear_errors()

files = []


def opcodes(slice, offset, opcode):
    global files, TYPE_NUMBER
    if opcode == 2000:
        display_value()
        stack_pop()
        sys.stdout.flush()
    elif opcode == 3000:
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
    elif opcode == 3001:
        slot = int(stack_pop())
        files[slot].close()
        files[slot] = 0
    elif opcode == 3002:
        slot = int(stack_pop())
        stack_push(ord(files[slot].read(1)), TYPE_NUMBER)
    elif opcode == 3003:
        slot = int(stack_pop())
        files[slot].write(unichr(int(stack_pop())))
    elif opcode == 3004:
        slot = int(stack_pop())
        stack_push(files[slot].tell(), TYPE_NUMBER)
    elif opcode == 3005:
        slot = int(stack_pop())
        pos = int(stack_pop())
        stack_push(files[slot].seek(pos, 0), TYPE_NUMBER)
    elif opcode == 3006:
        slot = int(stack_pop())
        at = files[slot].tell()
        files[slot].seek(0, 2) # SEEK_END
        stack_push(files[slot].tell(), TYPE_NUMBER)
        files[slot].seek(at, 0) # SEEK_SET
    elif opcode == 3007:
        name = slice_to_string(stack_pop())
        if os.path.exists(name):
            os.remove(name)
    elif opcode == 3008:
        name = slice_to_string(stack_pop())
        if os.path.exists(name):
            stack_push(-1, TYPE_FLAG)
        else:
            stack_push(0, TYPE_FLAG)
    elif opcode == 4000:
        stack_push(len(sys.argv) - 2, TYPE_NUMBER)
    elif opcode == 4001:
        n = int(stack_pop())
        stack_push(string_to_slice(sys.argv[n + 2]), TYPE_STRING)
    elif opcode == 9000:
        home = os.path.expanduser("~")
        file = home + "/.parable/library/" + slice_to_string(stack_pop())
        load_file(file)
    return offset


def load_file(file):
    f = open(file).readlines()
    for line in condense_lines(f):
        if len(line) > 1:
            if not line.startswith("#!"):
                s = compile(line, request_slice())
                interpret(s, opcodes)
                display_errors()


if __name__ == '__main__':
    prepare_slices()
    prepare_dictionary()
    parse_bootstrap(bootstrap)
    collect_garbage()

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
