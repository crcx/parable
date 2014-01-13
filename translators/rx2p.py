# rx2p: retro source to parable
# Copyright (c) 2014, Charles Childers
#
# This takes a source file with Retro syntax and function names
# and converts it to Parable.
#
# So far it handles:
#
#    : foo ... ;        ->      [ ... ] 'foo' define
#    123                ->      #123
#    ( ... )            ->      "..."
#    \ ...              ->      "..."
#    ['] name           ->      &name
#    2over              ->      dup-pair
#    2drop              ->      drop-pair
#    times              ->      repeat
#
# Usage:
#
#    python rx2p.py source.rx > source.p
# =============================================================

import sys, os


def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False


def compile(str):
    new = ""
    names = []
    cleaned = ' '.join(str.split())
    tokens = cleaned.split(' ')
    count = len(tokens)
    i = 0
    while i < count:
        token = tokens[i]
        if token == ":":
            new = new + " [";
            i += 1
            names.append(tokens[i])
        elif token == ";":
            new = new + " ] '" + names.pop() + "' define"
        elif token == "[']":
            new = new + " &";
            i += 1
            new = new + tokens[i]
        elif token == "(":
            new = new + ' "'
        elif token == ")":
            new = new + '"'
        elif is_number(token):
            new = new + " #" + token
        elif token == "2over"
            new = new + " dup-pair"
        elif token == "2drop"
            new = new + " drop-pair"
        elif token == "times"
            new = new + " repeat"
        elif token == "\\":
            new = new + ' "'
            i += 1
            while i < count:
                new = new + " " + tokens[i]
                i += 1
            new = new + '"'
        else:
            new = new + " " + token
        i += 1
    return new


def process_file(f):
    for line in f:
        if len(line) > 1:
            sys.stdout.write(compile(line))
            sys.stdout.write('\n')


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit('Usage: %s filename(s)' % sys.argv[0])
    for source in sys.argv:
        if not os.path.exists(source):
            sys.exit('ERROR: source file "%s" was not found!' % source)
        if source != sys.argv[0]:
            process_file(open(source).readlines())
    sys.stdout.flush()
