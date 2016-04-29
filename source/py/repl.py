#!/usr/bin/env python3
# Copyright (c) 2013-2016, Charles Childers
# coding: utf-8
import parable
def setup_readline():
    try:
        import readline
        readline.set_completer(tab_completion)
        readline.parse_and_bind("tab: complete")
    except:
        pass
def tab_completion(text, state):
    options = [x for x in parable.dictionary_names() if x.startswith(text)]
    try:
        return options[state]
    except IndexError:
        return None
def init_from_snapshot(s):
    try:
        import base64, bz2, json
        raw = base64.b64decode(bytes(s, 'utf-8'))   # decode base64
        u = bz2.decompress(raw)                     # decompress json
        j = json.loads(u.decode())                  # parse json
        parable.dictionary = j['symbols']
        parable.errors = j['errors']
        parable.stack = j['stack']
        parable.memory_values = j['memory_contents']
        parable.memory_types = j['memory_types']
        parable.memory_map = j['memory_map']
        parable.memory_size = j['memory_sizes']
        parable.dictionary_hidden_slices = j['hidden_slices']
    except:
        pass
def get_input():
    done = False
    s = input("\ninput> ")
    while not done:
        if parable.is_balanced(parable.tokenize(s)):
            done = True
        else:
            s = s.strip() + ' '
            s = s + input("       ")
    return s
def opcode_display_stack():
    i = 0
    while i < len(parable.stack):
        print("\t{0}\t{1}".format(i, parable.parsed_item(i)))
        i += 1
def opcode_display_words():
    print(' '.join(parable.dictionary_names()))
def opcode_exit_repl():
    opcode_display_stack()
    exit()
def opcode_include_file():
    import os
    name = parable.slice_to_string(parable.stack_pop())
    if os.path.exists(name):
        source = open(name).readlines()
        parable.parse_bootstrap(source)
def opcodes(slice, offset, opcode):
    import os, sys
    if opcode == 9000:
        opcode_display_stack()
    elif opcode == 9001:
        opcode_display_words()
    elif opcode == 9002:
        opcode_exit_repl()
    elif opcode == 9003:
        opcode_include_file()
    return offset
def evaluate(s):
    parable.interpret(parable.compile(s), opcodes)
if __name__ == '__main__':
    import os
    if os.path.exists('parable.snapshot'):
        init_from_snapshot(open('parable.snapshot').read())
    else:
        parable.prepare_slices()
        parable.prepare_dictionary()
        parable.parse_bootstrap(open('stdlib.p').readlines())

    setup_readline()
    evaluate("[ \"-\"   `9000 ] '.s' :")
    evaluate("[ \"-\"   `9001 ] 'words' :")
    evaluate("[ \"-\"   `9002 ] 'bye' :")
    evaluate("[ \"s-\"  `9003 ] 'include' :")
    print('Parable Listener, (c) 2013-2016 Charles Childers')
    print('------------------------------------------------')
    print('.s       Display Stack')
    print('bye      Exit Listener')
    print('words    Display a list of all named items')
    print('------------------------------------------------\n')
    while True:
        try:
            src = get_input()
        except:
            sys.stdout.write("\n")
            exit()
        if len(src) >= 1:
            try:
                evaluate(src)
            except KeyboardInterrupt:
                sys.stdout.write("\n")
                pass
        for e in parable.errors:
            sys.stdout.write(e + "\n")
        parable.clear_errors()
