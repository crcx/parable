#!/usr/bin/env python3

# Copyright (c) 2013-2016, Charles Childers
#
# legend is a full screen console interface to the parable language.
# interaction is done by typing in short commands (prefixed by a
# colon) or parable code.
#
# legend recognizes the following commands:
#
#   :q         quit legend
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
import os, readline, sys
import parable
from os.path import expanduser

try:
    import __builtin__
    input = getattr(__builtin__, 'raw_input')
except (ImportError, AttributeError):
    pass


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
COLOR_STACK_COMMENT = 'dark gray'
COLOR_STACK_FUN_CALL = 'bright red'
COLOR_STACK_BYTECODE = 'cyan'
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
    env = os.environ

    def ioctl_GWINSZ(fd):
        try:
            import fcntl, termios, struct
            cr = struct.unpack('hh', fcntl.ioctl(fd, termios.TIOCGWINSZ, '1234'))
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
    for i in parable.memory_values:
        parable.memory_values.pop()
    for i in parable.memory_map:
        parable.memory_map.pop()
    for i in parable.dictionary_slices:
        parable.dictionary_slices.pop()
    for i in parable.dictionary_names:
        parable.dictionary_names.pop()
    parable.prepare_slices()
    parable.prepare_dictionary()


def display_stack():
    """display the stack contents. returns the number of lines rendered"""
    i = 0
    l = 1
    while i < len(parable.stack):
        tos = parable.stack_value_for(i)
        type = parable.stack_type_for(i)

        # display the stack item number
        if i == len(parable.stack) - 1:
            write("TOS\t" + str(i), COLOR_STACK_LINE)
        else:
            write("\t" + str(i), COLOR_STACK_LINE)

        # display the stack item
        if type == parable.TYPE_NUMBER:
            write("\t#" + str(tos), COLOR_STACK_N)
        elif type == parable.TYPE_CHARACTER:
            write("\t$" + str(chr(tos)), COLOR_STACK_C)
        elif type == parable.TYPE_STRING:
            write("\t'" + parable.slice_to_string(tos) + "'", COLOR_STACK_S)
            write("\n\t\tstored at: " + str(tos), 'normal')
            l += 1
        elif type == parable.TYPE_POINTER:
            write("\t&" + str(tos), COLOR_STACK_F)
            if parable.pointer_to_name(tos) != "":
                write("\n\t\tpointer to: ", 'normal')
                write(parable.pointer_to_name(tos), 'normal')
                l += 1
        elif type == parable.TYPE_FLAG:
            if tos == -1:
                write("\ttrue", COLOR_STACK_FLAG)
            elif tos == 0:
                write("\tfalse", COLOR_STACK_FLAG)
            else:
                write("\tmalformed flag", COLOR_STACK_FLAG)
        elif type == parable.TYPE_BYTECODE:
            write("\t`" + str(tos), COLOR_STACK_BYTECODE)
        elif type == parable.TYPE_REMARK:
            write("\t\"" + parable.slice_to_string(tos) + "\"", COLOR_STACK_COMMENT)
            write("\n\t\tstored at: " + str(tos), 'normal')
            l += 1
        elif type == parable.TYPE_FUNCALL:
            write("\t|" + str(tos), COLOR_STACK_FUN_CALL)
        else:
            write("\tUNKNOWN\t" + str(tos) + "\t" + str(type), COLOR_ERROR)
        sys.stdout.write("\n")

        # increase "l" so we know how many lines have been displayed so far
        i += 1
        l += 1

    return l


def display_errors():
    """display any error messages. returns number of lines rendered"""
    for e in parable.errors:
        write("\n" + e, COLOR_ERROR)
    return len(parable.errors)


def draw_separator(width):
    while width > 0:
        write("-", COLOR_BAR)
        width -= 1
    return 1


def clear_display():
    sys.stdout.write("\x1b[2J")


def display(height, width):
    """display the user interface"""
    clear_display()
    l = display_stack()
    l += display_errors()
    parable.clear_errors()
    while l < (height - 1):
        sys.stdout.write("\n")
        l += 1
    l += draw_separator(width)
    write("---> ", COLOR_PROMPT)
    sys.stdout.flush()


def load_file(file):
    if not os.path.exists(file):
        parable.report('L00: Unable to find ' + str(file))
    else:
        f = open(file).readlines()
        f = parable.condense_lines(f)
        for line in f:
            if len(line) > 1:
                s = parable.compile(line, parable.request_slice())
                parable.interpret(s)


def get_input():
    done = 0
    s = ''
    while done == 0:
        s = s + input()
        if s.endswith(' \\'):
            s = s[:-2].strip() + ' '
        else:
            done = 1
    return s


def completer(text, state):
    options = [x for x in parable.dictionary_names if x.startswith(text)]
    try:
        return options[state]
    except IndexError:
        return None


if __name__ == '__main__':
    (width, height) = getTerminalSize()

    readline.set_completer(completer)
    readline.parse_and_bind("tab: complete")

    parable.prepare_slices()
    parable.prepare_dictionary()
    parable.parse_bootstrap(open('stdlib.p').readlines())

    try:
        home = expanduser("~")
        src = home + "/.parable/on_startup.p"
        parable.parse_bootstrap(open(src).readlines())
    except:
        pass

    while 1 == 1:
        display(height, width)

        try:
            src = get_input()
        except:
            sys.stdout.write("\n")
            exit()

        cmd = ' '.join(src.split())

        if cmd == ':q':
            exit()
        elif cmd == ':r':
            revert()
            parable.parse_bootstrap(open('stdlib.p').readlines())
            parable.collect_garbage()
        elif cmd[0:2] == ':i':
            load_file(cmd[3:])
        else:
            if len(src) >= 1:
                try:
                    parable.interpret(parable.compile(src, parable.request_slice()))
                except:
                    sys.stdout.write("\n")
                    pass

        sys.stdout.flush()
