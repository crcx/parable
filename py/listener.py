#!/usr/bin/env python

# Listener: a basic UI for Parable
# Copyright (c) 2013, 2015  Charles Childers
#

import readline
import os
import sys
import parable


try:
    import __builtin__
    input = getattr(__builtin__, 'raw_input')
except (ImportError, AttributeError):
    pass


def display_item(prefix, value):
    sys.stdout.write('\t' + prefix + str(value))

def dump_stack():
    """display the stack"""
    i = 0
    while i < len(parable.stack):
        tos = parable.stack[i]
        type = parable.types[i]
        sys.stdout.write("\t" + str(i))
        if type == parable.TYPE_NUMBER:
            display_item('#', tos)
        elif type == parable.TYPE_CHARACTER:
            display_item('$', chr(tos))
        elif type == parable.TYPE_STRING:
            display_item('\'', parable.slice_to_string(tos) + '\'')
        elif type == parable.TYPE_POINTER:
            display_item('&', tos)
        elif type == parable.TYPE_REMARK:
            display_item('"', parable.slice_to_string(tos) + '"')
        elif type == parable.TYPE_FLAG:
            if tos == -1:
                display_item("", "true")
            elif tos == 0:
                display_item("", "false")
            else:
                display_item("", "malformed flag")
        else:
            display_item("", "unmatched type on the stack")
        sys.stdout.write("\n")
        i += 1


def dump_dict():
    """display named items"""
    l = ''
    for w in parable.dictionary_names:
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
    sys.stdout.write("\ninput> ")
    sys.stdout.flush()
    indent = False
    while not done:
        if indent:
            sys.stdout.write("       ")
        s = s + input()
        if s.endswith(' \\'):
            s = s[:-2].strip() + ' '
            indent = True
        else:
            done = True
    return s


def completer(text, state):
    options = [x for x in parable.dictionary_names if x.startswith(text)]
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
    parable.parse_bootstrap(open('stdlib.p').readlines())

    evaluate("[ \"-\"   `9000 ] '.s' define")
    evaluate("[ \"-\"   `9001 ] 'bye' define")
    evaluate("[ \"-\"   `9002 ] 'words' define")
    evaluate("[ \"s-\"  `9003 ] 'include' define")

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
