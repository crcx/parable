#!/usr/bin/env python

# Copyright (c) 2013, Charles Childers
#
# legend is a full screen console interface to the parable language.
# interaction is done by typing in short commands (prefixed by a
# colon) or parable code.
#
# legend recognizes the following commands:
#
#   :q         quit legend
#   :w         write session to a file
#   :e         edit session in $EDITOR (or vim if not set)
#   :r         reset to a fresh state
#   :i file    load and run the contents of *file*
#
# Anything else is passed to parable for compilation and execution.
#
# The stack is displayed at the top of the screen, building down to
# the top element (TOS). Below this, any error messages will be
# displayed. At the bottom of the screen is the input area.
# ===================================================================
# legend makes use of a modified version of a library named 'pretty':
#
# pretty - A miniature library that provides a Python print and stdout
#          wrapper that makes colored terminal text easier to use (eg.
#          without having to mess around with ANSI escape sequences).
#          This code is public domain - there is no license except
#          that you must leave this header.
#          Copyright (C) 2008 Brian Nez <thedude at bri1 dot com>
#
# the modified version cuts out functionality that is not needed by
# legend and works with both python2 and python3
# ===================================================================

# Dependencies
import sys
import os
from subprocess import call
from parable import *


#
# Configuration
#

COLOR_PROMPT = 'bright green'
COLOR_STACK_LINE = 'bright green'
COLOR_STACK_N = 'bright cyan'
COLOR_STACK_S = 'white'
COLOR_STACK_F = 'yellow'
COLOR_STACK_C = 'bright green'
COLOR_STACK_FLAG = 'bright gray'
COLOR_ERROR = 'bright purple'
COLOR_BAR = 'red'


colorCodes = {
    'black': '0;30', 'bright gray': '0;37',
    'blue': '0;34', 'white': '1;37',
    'green': '0;32', 'bright blue': '1;34',
    'cyan': '0;36', 'bright green': '1;32',
    'red': '0;31', 'bright cyan': '1;36',
    'purple': '0;35', 'bright red': '1;31',
    'yellow': '0;33', 'bright purple': '1;35',
    'dark gray': '1;30', 'bright yellow': '1;33',
    'normal': '0'
}


def write(text, color):
    """Write to stdout in color."""
    sys.stdout.write("\033[" + colorCodes[color] + "m" + text + "\033[0m")


def getTerminalSize():
    import os
    env = os.environ

    def ioctl_GWINSZ(fd):
        try:
            import fcntl
            import termios
            import struct
            import os
            cr = struct.unpack('hh', fcntl.ioctl(fd, termios.TIOCGWINSZ,
        '1234'))
        except:
            return
        return cr

    cr = ioctl_GWINSZ(0) or ioctl_GWINSZ(1) or ioctl_GWINSZ(2)
    if not cr:
        try:
            fd = os.open(os.ctermid(), os.O_RDONLY)
            cr = ioctl_GWINSZ(fd)
            os.close(fd)
        except:
            pass
    if not cr:
        cr = (env.get('LINES', 25), env.get('COLUMNS', 80))

    return int(cr[1]), int(cr[0])


def revert():
    """revert the session to a clean state (does not load bootstrap)"""
    global p_slices, p_dict, dictionary_slices, dictionary_names

    for i in p_slices:
        p_slices.pop()
    for i in p_map:
        p_map.pop()
    for i in dictionary_slices:
        dictionary_slices.pop()
    for i in dictionary_names:
        dictionary_names.pop()
    prepare_slices()
    prepare_dictionary()


def export_source(name):
    """export the source code for the current session to a file"""
    with open(name, "w") as session:
        session.write(generate_source())


def edit_session():
    """export the source code for the current session to a file, launch the"""
    """$EDITOR on it, and then load/parse the resulting file"""
    export_source('scratch')
    EDITOR = os.environ.get('EDITOR', 'vim')
    call([EDITOR, "scratch"])
    revert()
    f = open('scratch').readlines()
    for line in f:
        if len(line) > 1:
            s = compile(line, request_slice())
            interpret(s)
    try:
        os.remove('scratch')
    except OSError:
        pass


def display_stack():
    """display the stack contents. returns the number of lines rendered"""
    global stack, types
    i = 0
    l = 1
    while i < len(stack):
        if i == len(stack) - 1:
            write("TOS\t" + str(i), COLOR_STACK_LINE)
        else:
            write("\t" + str(i), COLOR_STACK_LINE)

        if types[i] == TYPE_NUMBER:
            write("\t#" + str(stack[i]), COLOR_STACK_N)
        elif types[i] == TYPE_CHARACTER:
            write("\t$" + str(chr(stack[i])), COLOR_STACK_C)
        elif types[i] == TYPE_STRING:
            write("\t'" + slice_to_string(stack[i]) + "'", COLOR_STACK_S)
            write("\n\t\tstored at: " + str(stack[i]), 'normal')
            l += 1
        elif types[i] == TYPE_FUNCTION:
            write("\t&" + str(stack[i]), COLOR_STACK_F)
            if pointer_to_name(stack[i]) != "":
                write("\n\t\tpointer to: ", 'normal')
                write(pointer_to_name(stack[i]), 'normal')
                l += 1
        elif types[i] == TYPE_FLAG:
            if stack[i] == -1:
                write("\ttrue", COLOR_STACK_FLAG)
            elif stack[i] == 0:
                write("\tfalse", COLOR_STACK_FLAG)
            else:
                write("\tmalformed flag", COLOR_STACK_FLAG)
        else:
            write("\tunmatched type on stack!", COLOR_ERROR)
        sys.stdout.write("\n")
        i += 1
        l += 1
    return l


def display_errors():
    """display any error messages. returns number of lines rendered"""
    l = 0
    for e in errors:
        write("\n" + e, COLOR_ERROR)
        l += 1
    return l


def display(height, width):
    """display the user interface"""
    l = display_stack()
    l += display_errors()
    clear_errors()
    while l < height - 1:
        sys.stdout.write("\n")
        l += 1
    c = 0
    while c < width:
        write("-", COLOR_BAR)
        c += 1
    write("---> ", COLOR_PROMPT)
    sys.stdout.flush()


def load_file(file):
    f = open(file).readlines()
    for line in f:
        if len(line) > 1:
            s = compile(line, request_slice())
            interpret(s)


if __name__ == '__main__':
    (width, height) = getTerminalSize()
    prepare_slices()
    prepare_dictionary()
    parse_bootstrap(open('bootstrap.p').readlines())
    collect_unused_slices()

    counter = 0

    while 1 == 1:

        display(height, width)
        src = sys.stdin.readline()

        cmd = ' '.join(src.split())

        if cmd == ':q' or cmd == ':quit':
            exit()
        elif cmd == ':w' or cmd == ':write':
            export_source('session')
        elif cmd == ':e' or cmd == ':edit':
            edit_session()
        elif cmd == ':r' or cmd == ':restart':
            revert()
            parse_bootstrap()
            collect_unused_slices()
        elif cmd[0:2] == ':i':
            load_file(cmd[3:])
        else:
            if len(src) > 1:
                interpret(compile(src, request_slice()))

        counter += 1
        if counter > 100:
            if len(stack) == 0:
                collect_unused_slices()
                counter = 0

        sys.stdout.flush()
