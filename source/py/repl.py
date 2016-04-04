#!/usr/bin/env python3

# parable repl
# Copyright (c) 2013-2016, Charles Childers
# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
# coding: utf-8


import base64
import bz2
import json
import readline
import os
import sys
import parable

def init_from_snapshot(s):
    raw = base64.b64decode(bytes(s, 'utf-8'))
    u = bz2.decompress(raw)
    j = json.loads(u.decode())
    parable.dictionary = j['symbols']
    parable.errors = j['errors']
    parable.stack = j['stack_values']
    parable.memory_values = j['memory_contents']
    parable.memory_types = j['memory_types']
    parable.memory_map = j['memory_map']
    parable.memory_size = j['memory_sizes']
    parable.dictionary_hidden_slices = j['hidden_slices']


def dump_stack():
    """display the stack"""
    i = 0
    while i < len(parable.stack):
        sys.stdout.write("\t" + str(i))
        sys.stdout.write("\t" + parable.parsed_item(i) + "\n")
        i += 1


def dump_dict():
    """display named items"""
    l = ''
    for w in parable.dictionary_names():
        l = l + w + ' '
    sys.stdout.write(l)
    sys.stdout.write("\n")


def opcodes(slice, offset, opcode):
    if opcode == 9000:
        dump_stack()
    elif opcode == 9001:
        exit()
    elif opcode == 9002:
        dump_dict()
    elif opcode == 9003:
        name = parable.slice_to_string(parable.stack_pop())
        if os.path.exists(name):
            lines = parable.condense_lines(open(name).readlines())
            for l in lines:
                slice = parable.request_slice()
                parable.interpret(parable.compile(l, slice), opcodes)

    return offset


def evaluate(s):
    parable.interpret(parable.compile(s, parable.request_slice()))


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


def completer(text, state):
    options = [x for x in parable.dictionary_names() if x.startswith(text)]
    try:
        return options[state]
    except IndexError:
        return None

if __name__ == '__main__':
    print('Parable Listener, (c) 2013-2016 Charles Childers')
    print('------------------------------------------------')
    print('.s       Display Stack')
    print('bye      Exit Listener')
    print('words    Display a list of all named items')
    print('------------------------------------------------\n')

    readline.set_completer(completer)
    readline.parse_and_bind("tab: complete")

    parable.prepare_slices()
    parable.prepare_dictionary()
    if os.path.exists('parable.snapshot'):
        init_from_snapshot(open('parable.snapshot').read())
    else:
        parable.parse_bootstrap(open('stdlib.p').readlines())

    evaluate("[ \"-\"   `9000 ] '.s' :")
    evaluate("[ \"-\"   `9001 ] 'bye' :")
    evaluate("[ \"-\"   `9002 ] 'words' :")
    evaluate("[ \"s-\"  `9003 ] 'include' :")

    while 1 == 1:
        try:
            src = get_input()
        except:
            sys.stdout.write("\n")
            exit()

        if len(src) >= 1:
            try:
                slice = parable.request_slice()
                parable.interpret(parable.compile(src, slice), opcodes)
            except KeyboardInterrupt:
                sys.stdout.write("\n")
                pass

        for e in parable.errors:
            sys.stdout.write(e + "\n")

        parable.clear_errors()
        sys.stdout.flush()
