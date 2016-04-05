#!/usr/bin/env python3

# parable repl
# Copyright (c) 2013-2016, Charles Childers
# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
# coding: utf-8

import parable


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
# readline support
#
# readline allows for input history and editing of inputs. it makes for a much
# nicer user experience.
#
# setup_readline() attempts to import and initialize readline support. if this
# fails, we just return and don't get to benefit from readline.
#
# completer() provides for tab completion for anything named in the parable
# dictionary.

def setup_readline():
    try:
        import readline
        readline.set_completer(completer)
        readline.parse_and_bind("tab: complete")
    except:
        pass

def completer(text, state):
    options = [x for x in parable.dictionary_names() if x.startswith(text)]
    try:
        return options[state]
    except IndexError:
        return None


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
# snapshots
#
# parable can be bootstrapped from either source or a precompiled snapshot.
# it's generally preferable to use a snapshot, as this is *much* faster and
# makes for a nicer user experience.
#
# snapshots are:
# - json
# - bzip2 compressed
# - base64 encoded
#
# it's important to note that a snapshot may not be portable across parable
# releases. (since it represents internal state, the fields and contents may
# change as the implementation evolves.)

import base64
import bz2
import json

def init_from_snapshot(s):
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


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
# i/o functions
#
# get_input() displays a prompt and accepts user input.
#

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
    parable.interpret(parable.compile(s, parable.request_slice()), opcodes)


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
