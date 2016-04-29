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
# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
# byte code extensions
#
# it's often useful to add additional byte codes for i/o and/or other
# functionality that can't be portably implemented in parable.
#
# as an example, this provides three additional byte codes:
#
# `9000  "-"   display the stack
# `9001  "-"   display all names in the dictionary
# `9002  "-"   exit REPL
# `9003  "s-"  load and evaluate code in a file

import os
import sys

def opcodes(slice, offset, opcode):
    if opcode == 9000:
        i = 0
        while i < len(parable.stack):
            sys.stdout.write("\t" + str(i))
            sys.stdout.write("\t" + parable.parsed_item(i) + "\n")
            i += 1
    elif opcode == 9001:
        l = ''
        for w in parable.dictionary_names():
            l = l + w + ' '
        sys.stdout.write(l)
        sys.stdout.write("\n")
    elif opcode == 9002:
        print(parable.stack)
        exit()
    elif opcode == 9003:
        name = parable.slice_to_string(parable.stack_pop())
        if os.path.exists(name):
            lines = parable.condense_lines(open(name).readlines())
            for l in lines:
                evaluate(l)
    return offset


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
# evaluate: a helper function
#
# evaluation of code requires:
#
# - obtaining a slice
# - compiling source into the slice
# - interpreting the compiled byte code
#
# this one-line function wraps this all up and lets us keep the rest of the
# source a bit more readable.

def evaluate(s):
    parable.interpret(parable.compile(s), opcodes)


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
# main entry point

if __name__ == '__main__':
    setup_readline()

    if os.path.exists('parable.snapshot'):
        init_from_snapshot(open('parable.snapshot').read())
    else:
        parable.prepare_slices()
        parable.prepare_dictionary()
        parable.parse_bootstrap(open('stdlib.p').readlines())

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


    while 1 == 1:
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
        sys.stdout.flush()
