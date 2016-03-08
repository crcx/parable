#!/usr/bin/env pypy

# Listener: a basic UI for Parable
# Copyright (c) 2013, 2015  Charles Childers
#

import readline
import os
import sys
import parable
from os.path import expanduser

def load_file(name):
    global should_abort
    should_abort = False
    if os.path.exists(name):
        lines = parable.condense_lines(open(name).readlines())
        for l in lines:
            try:
                if l != "#!/usr/bin/env allegory" and should_abort == False:
                    slice = parable.request_slice()
                    parable.interpret(parable.compile(l, slice))
            except:
                pass
    else:
        should_abort = True


if __name__ == '__main__':
    parable.prepare_slices()
    parable.prepare_dictionary()
    parable.parse_bootstrap(open('stdlib.p').readlines())
    load_file(sys.argv[1])

    slice = parable.lookup_pointer(sys.argv[2])
    refs = parable.find_references(slice)

    print('Slice: ' + str(slice))
    print('RAW:   ' + str(parable.memory_values[slice]))
    print('REFS:  ' + str(refs))
    refs.sort()
    print('REFS:  ' + str(refs))
    print('---------------------------------------------')
    for ref in refs:
        s = parable.pointer_to_name(ref)
        if s != "":
            print(str(ref) + ':\t' + s)
