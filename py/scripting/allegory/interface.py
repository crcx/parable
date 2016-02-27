# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

# allegory interface layer begins here

import json
import os
import sys
from os.path import expanduser

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

try:
    import __builtin__
    input = getattr(__builtin__, 'raw_input')
except (ImportError, AttributeError):
    pass

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def save_snapshot(filename):
    global dictionary_names, \
           dictionary_slices, \
           errors, \
           stack, \
           types, \
           memory_values, \
           memory_types, \
           memory_map, \
           memory_size

    collect_garbage()
    j = json.dumps({"symbols": dictionary_names, \
                    "symbol_map": dictionary_slices, \
                    "errors": errors, \
                    "stack_values": stack, \
                    "stack_types": types, \
                    "memory_contents": memory_values, \
                    "memory_types": memory_types, \
                    "memory_map": memory_map, \
                    "memory_sizes": memory_size})
    with open(filename, 'w') as file:
        file.write(j)

def load_snapshot(filename):
    global dictionary_names, \
           dictionary_slices, \
           errors, \
           stack, \
           types, \
           memory_values, \
           memory_types, \
           memory_map, \
           memory_size

    j = json.loads(open(filename, 'r').read())
    dictionary_names = j['symbols']
    dictionary_slices = j['symbol_map']
    errors = j['errors']
    stack = j['stack_values']
    types = j['stack_types']
    memory_values = j['memory_contents']
    memory_types = j['memory_types']
    memory_map = j['memory_map']
    memory_size = j['memory_sizes']

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def completer(text, state):
    options = [x for x in dictionary_names if x.startswith(text)]
    try:
        return options[state]
    except IndexError:
        return None

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def display_item(prefix, value):
    sys.stdout.write(prefix + str(value))


def dump_stack():
    """display the stack"""
    i = 0
    while i < len(stack):
        tos = stack[i]
        type = types[i]
        sys.stdout.write("\t" + str(i))
        if type == TYPE_NUMBER:
            display_item('\t' + '#', tos)
        elif type == TYPE_BYTECODE:
            display_item('\t' + '`', tos)
        elif type == TYPE_CHARACTER:
            display_item('\t' + '$', chr(tos))
        elif type == TYPE_STRING:
            display_item('\t' + '\'', slice_to_string(tos) + '\'')
        elif type == TYPE_POINTER:
            display_item('\t' + '&', tos)
        elif type == TYPE_REMARK:
            display_item('\t' + '"', slice_to_string(tos) + '"')
        elif type == TYPE_FLAG:
            if tos == -1:
                display_item('\t' + "", "true")
            elif tos == 0:
                display_item('\t' + "", "false")
            else:
                display_item('\t' + "", "malformed flag")
        elif type == TYPE_FUNCTION_CALL:
            display_item('\tCALL to ' + '&', tos)
        else:
            display_item('\t' + "", "unmatched type on the stack")
        sys.stdout.write("\n")
        i += 1

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def dump_dict():
    """display named items"""
    l = ''
    for w in dictionary_names:
        l = l + w + ' '
    sys.stdout.write(l)
    sys.stdout.write("\n")

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def display_value():
    global stack, types
    i = len(stack) - 1
    if types[i] == TYPE_NUMBER:
        sys.stdout.write(str(stack[i]))
    elif types[i] == TYPE_CHARACTER:
        sys.stdout.write(str(chr(stack[i])))
    elif types[i] == TYPE_STRING:
        sys.stdout.write(slice_to_string(stack[i]))
    elif types[i] == TYPE_POINTER:
        sys.stdout.write('&' + str(stack[i]))
    elif types[i] == TYPE_FLAG:
        if stack[i] == -1:
            sys.stdout.write("true")
        elif stack[i] == 0:
            sys.stdout.write("false")
        else:
            sys.stdout.write("malformed flag")
    elif types[i] == TYPE_COMMENT:
        sys.stdout.write(slice_to_string(stack[i]))
    elif types[i] == TYPE_BYTECODE:
        sys.stdout.write('`' + str(stack[i]))
    elif types[i] == TYPE_FUNCTION_CALL:
        sys.stdout.write('CALL: ' + str(stack[i]))
    else:
       sys.stdout.write("unknown type")

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def revert():
    global memory_values, memory_map, memory_types, dictionary_slices, dictionary_names
    memory_values = []
    memory_map = []
    memory_types = []
    dictionary_slices = []
    dictionary_names = []
    prepare_slices()
    prepare_dictionary()
    stack_clear()
    i = 1
    while i < 8:
        if files[i] != 0:
            files[i].close()
            files[i] = 0
        i = i + 1

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

files = []

def opcodes(slice, offset, opcode):
    global dictionary_warnings
    if opcode == 2000:
        dictionary_warnings = True
    if opcode == 2001:
        dictionary_warnings = False
    if opcode == 201:
        slot = 0
        i = 1
        while i < (len(files) - 1):
            if files[i] == 0:
                slot = i
            i = i + 1
        mode = slice_to_string(stack_pop())
        name = slice_to_string(stack_pop())
        if slot != 0:
            try:
                files[int(slot)] = open(name, mode)
            except:
                files[int(slot)] = -1
                report('A10: Unable to open file named ' + name)
        stack_push(slot, TYPE_NUMBER)
    elif opcode == 202:
        slot = int(stack_pop())
        files[slot].close()
        files[slot] = 0
    elif opcode == 203:
        slot = int(stack_pop())
        stack_push(ord(files[slot].read(1)), TYPE_NUMBER)
    elif opcode == 204:
        slot = int(stack_pop())
        files[slot].write(chr(int(stack_pop())))
    elif opcode == 205:
        slot = int(stack_pop())
        stack_push(files[slot].tell(), TYPE_NUMBER)
    elif opcode == 206:
        slot = int(stack_pop())
        pos = int(stack_pop())
        stack_push(files[slot].seek(pos, 0), TYPE_NUMBER)
    elif opcode == 207:
        slot = int(stack_pop())
        at = files[slot].tell()
        files[slot].seek(0, 2) # SEEK_END
        stack_push(files[slot].tell(), TYPE_NUMBER)
        files[slot].seek(at, 0) # SEEK_SET
    elif opcode == 208:
        name = slice_to_string(stack_pop())
        if os.path.exists(name):
            os.remove(name)
    elif opcode == 209:
        name = slice_to_string(stack_pop())
        if os.path.exists(name):
            stack_push(-1, TYPE_FLAG)
        else:
            stack_push(0, TYPE_FLAG)
    elif opcode == 226:
        s = request_slice()
        i = 0
        while i < len(sys.argv):
            store(string_to_slice(sys.argv[i]), s, i, TYPE_STRING)
            i = i + 1
        stack_push(s, TYPE_POINTER)
    elif opcode == 227:
        from subprocess import call
        s = slice_to_string(stack_pop())
        n = call(s, shell = True)
        stack_push(n, TYPE_NUMBER)
    elif opcode == 4000:
        stack_push(len(sys.argv) - 2, TYPE_NUMBER)
    elif opcode == 4001:
        n = int(stack_pop())
        stack_push(string_to_slice(sys.argv[n + 2]), TYPE_STRING)
    elif opcode == 5000:
        key = slice_to_string(stack_pop())
        value = form.getvalue(key, "(no)")
        stack_push(string_to_slice(value), TYPE_STRING)
    elif opcode == 5001:
        key = slice_to_string(stack_pop())
        value = os.getenv(key, "(no)")
        stack_push(string_to_slice(value), TYPE_STRING)
    elif opcode == 6000:
        display_value()
        stack_pop()
        sys.stdout.flush()
    elif opcode == 9000:
        dump_stack()
    elif opcode == 9001:
        exit()
    elif opcode == 9002:
        dump_dict()
    elif opcode == 9003:
        name = slice_to_string(stack_pop())
        load_file(name)
    elif opcode == 9004:
        save_snapshot(slice_to_string(stack_pop()))
    elif opcode == 9005:
        name = slice_to_string(stack_pop())
        if os.path.exists(name):
            load_snapshot(name)
        else:
            report('A20: ' + name + ' not found')
    elif opcode == 9006:
        revert()
        parse_bootstrap(stdlib)
        parse_bootstrap(extensions)
    return offset

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
ignore_depth = 0

def allegory_evaluate(src):
    global ignore_depth
    if src == "+ignore":
        ignore_depth = ignore_depth + 1
    elif src == "-ignore":
        ignore_depth = ignore_depth - 1
    elif ignore_depth <= 0:
        slice = request_slice()
        interpret(compile(src, slice), opcodes)
    if ignore_depth < 0:
        ignore_depth = 0


def load_file(name):
    global should_abort
    should_abort = False
    if os.path.exists(name):
        lines = condense_lines(open(name).readlines())
        for l in lines:
            try:
                if l != "#!/usr/bin/env allegory" and should_abort == False:
                    allegory_evaluate(l)
            except:
                pass
        for e in errors:
            sys.stdout.write('IN: ' + name + ', ' + e + '\n')
        clear_errors()
    else:
        report('A10: Unable to open file named ' + name)
        for e in errors:
            sys.stdout.write(e + '\n')
        clear_errors()
        should_abort = True


def evaluate(s):
    try:
        interpret(compile(s, request_slice()))
    except:
        sys.stdout.write("\n")
        pass


def get_input():
    done = False
    s = ''
    s = input("\ninput> ")
    while not done:
        if s.endswith(' \\'):
            s = s[:-2].strip() + ' '
            s = s + input("       ")
        else:
            done = True
    return s


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def scripting():
    source = sys.argv[1]
    if not os.path.exists(source):
        sys.exit('ERROR: source file "%s" was not found!' % source)
    load_file(source)
    dump_stack()


def interactive():
    try:
        import readline
        readline.set_completer(completer)
        readline.parse_and_bind("tab: complete")
    except (ImportError, AttributeError):
        pass

    print('allegory, (c)2013-2016 Charles Childers')
    print('------------------------------------------------')
    print('.s       Display Stack')
    print('bye      Exit Listener')
    print('words    Display a list of all named items')
    print('------------------------------------------------')

    snapshot = expanduser("~") + "/.parable/default.j"
    if os.path.exists(snapshot):
        print('Initialized using ' + snapshot)
        print('------------------------------------------------')
        load_snapshot(snapshot)

    while True:
        try:
            src = get_input()
        except:
            sys.stdout.write("\n")
            exit()

        if len(src) >= 1:
            try:
                allegory_evaluate(src)
            except KeyboardInterrupt:
                sys.stdout.write("\n")
                pass

        for e in errors:
            print(e)

        clear_errors()
        sys.stdout.flush()

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

if __name__ == '__main__':
    for i in range(0, 32):
        files.append(0)

    prepare_slices()
    prepare_dictionary()
    parse_bootstrap(stdlib)
    parse_bootstrap(extensions)

    home = expanduser("~")

    try:
        src = home + "/.parable/on_startup.p"
        if os.path.exists(src):
            load_file(src)
    except:
        pass

    try:
        src = "on_startup.p"
        if os.path.exists(src):
            load_file(src)
    except:
        pass

    if len(sys.argv) < 2:
        interactive()
    else:
        scripting()

    sys.stdout.flush()
