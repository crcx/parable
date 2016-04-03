# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

# allegory interface layer begins here

import base64
import bz2
import json
import os
import sys
from os.path import expanduser

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def save_snapshot(filename):
    j = json.dumps({"symbols": dictionary, \
                    "errors": errors, \
                    "stack_values": stack, \
                    "memory_contents": memory_values, \
                    "memory_types": memory_types, \
                    "memory_map": memory_map, \
                    "memory_sizes": memory_size, \
                    "hidden_slices": dictionary_hidden_slices })

    orig = open(__file__).read().split('\n')
    c = bz2.compress(bytes(j, 'utf-8'))

    with open(filename, 'w') as file:
        for line in orig:
            if line.startswith("stdlib"):
                file.write('stdlib="' + str(base64.b64encode(c)).replace("b'", "").replace("'", "") + '"')
            else:
                file.write(line)
            file.write('\n')

    import stat
    st = os.stat(filename)
    os.chmod(filename, st.st_mode | stat.S_IEXEC)


def load_snapshot(filename):
    global dictionary, \
           errors, \
           stack, \
           memory_values, \
           memory_types, \
           memory_map, \
           memory_size, \
           dictionary_hidden_slices


    j = json.loads(open(filename, 'r').read())
    dictionary = j['symbols']
    errors = j['errors']
    stack = j['stack_values']
    memory_values = j['memory_contents']
    memory_types = j['memory_types']
    memory_map = j['memory_map']
    memory_size = j['memory_sizes']
    dictionary_hidden_slices = j['hidden_slices']


def bootstrap(s):
    global dictionary, \
           errors, \
           stack, \
           memory_values, \
           memory_types, \
           memory_map, \
           memory_size, \
           dictionary_hidden_slices

    raw = base64.b64decode(bytes(s, 'utf-8'))
    u = bz2.decompress(raw)
    j = json.loads(u.decode())

    dictionary = j['symbols']
    errors = j['errors']
    stack = j['stack_values']
    memory_values = j['memory_contents']
    memory_types = j['memory_types']
    memory_map = j['memory_map']
    memory_size = j['memory_sizes']
    dictionary_hidden_slices = j['hidden_slices']

    xt = lookup_pointer('allegory.on-start')
    if xt != -1:
        interpret(xt, opcodes)

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def completer(text, state):
    options = [x for x in dictionary_names() if x.startswith(text)]
    try:
        return options[state]
    except IndexError:
        return None

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def dump_dict():
    """display named items"""
    l = ''
    for w in dictionary_names():
        l = l + w + ' '
    sys.stdout.write(l)
    sys.stdout.write("\n")

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def display_value():
    global stack
    i = len(stack) - 1
    t = stack_type_for(i)
    v = stack_value_for(i)
    if t == TYPE_NUMBER:
        sys.stdout.write(str(v))
    elif t == TYPE_CHARACTER:
        sys.stdout.write(str(chr(v)))
    elif t == TYPE_STRING:
        sys.stdout.write(slice_to_string(v))
    elif t == TYPE_POINTER:
        sys.stdout.write('&' + str(v))
    elif t == TYPE_FLAG:
        if v == -1:
            sys.stdout.write("true")
        elif v == 0:
            sys.stdout.write("false")
        else:
            sys.stdout.write("malformed flag")
    elif t == TYPE_REMARK:
        sys.stdout.write(slice_to_string(v))
    elif t == TYPE_BYTECODE:
        sys.stdout.write('`' + str(v))
    elif t == TYPE_FUNCALL:
        sys.stdout.write('CALL: &' + str(v))
    else:
       sys.stdout.write("unknown type")

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def revert():
    global memory_values, memory_map, memory_types, dictionary
    memory_values = []
    memory_map = []
    memory_types = []
    dictionary = []
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
    if opcode == 200:
        stack_push(string_to_slice(expanduser('~')), TYPE_STRING)
    elif opcode == 201:
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
        try:
            stack_push(ord(files[slot].read(1)), TYPE_CHARACTER)
        except:
            report('Non-ASCII characters detected, aborting file input')
            abort_run(opcode, offset)
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
    elif opcode == 300:
        import time
        stack_push(time.time(), TYPE_NUMBER)
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
    elif opcode == 9001:
        xt = lookup_pointer('allegory.on-end')
        if xt != -1:
            interpret(xt, opcodes)
        sys.exit('')
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
        bootstrap(stdlib)
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


def extract_from_markdown(name):
    v = []
    with open(name) as f:
        v = f.readlines()
    s = []
    fence = False
    for l in v:
        if l.startswith('    '): s.append(l[4:])
        elif fence == True and l != '````\n':
            s.append(l)
        elif l == '````\n' and fence == True:
            fence = False
        elif l == '````\n' and fence == False:
            fence = True
    return s


def load_file(name):
    global should_abort
    should_abort = False
    if os.path.exists(name):
        if name.endswith('.md'): lines = condense_lines(extract_from_markdown(name))
        else: lines = condense_lines(open(name).readlines())
        for l in lines:
            try:
                if l != "#!/usr/bin/env allegory" and should_abort == False:
                    allegory_evaluate(l)
            except:
                e = sys.exc_info()[0]
                if e == SystemExit: exit()
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
    s = input("\nok\n")
    while not done:
        if s.endswith(' \\'):
            s = s[:-2].strip() + ' '
            s = s + input()
        else:
            done = True
    return s


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def scripting():
    bootstrap(stdlib)
    source = sys.argv[1]
    if not os.path.exists(source):
        sys.exit('ERROR: source file "%s" was not found!' % source)
    load_file(source)
    xt = lookup_pointer('allegory.on-end')
    if xt != -1:
        interpret(xt, opcodes)


def interactive():
    try:
        import readline
        readline.set_completer(completer)
        readline.parse_and_bind("tab: complete")
    except (ImportError, AttributeError):
        pass

    bootstrap(stdlib)

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

    if len(sys.argv) < 2:
        interactive()
    else:
        scripting()

    sys.stdout.flush()
