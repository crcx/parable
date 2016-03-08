#!/usr/bin/env python
# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

import base64
import bz2
import json
import parable
import os
import sys

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def prepare():
    parable.prepare_slices()
    parable.prepare_dictionary()
    parable.parse_bootstrap(open('stdlib.p').readlines())


def load_files():
    if len(sys.argv) > 1:
        for i in sys.argv:
            if os.path.exists(i) and i != "./gen-snapshot.py" and i != "gen-snapshot.py" :
                parable.parse_bootstrap(open(i).readlines())


def create_snapshot():
    parable.collect_garbage()
    j = json.dumps({"symbols": parable.dictionary_names, \
                    "symbol_map": parable.dictionary_slices, \
                    "errors": parable.errors, \
                    "stack_values": parable.stack, \
                    "stack_types": parable.types, \
                    "memory_contents": parable.memory_values, \
                    "memory_types": parable.memory_types, \
                    "memory_map": parable.memory_map, \
                    "memory_sizes": parable.memory_size, \
                    "hidden_slices": parable.dictionary_hidden_slices, })
    return j


def compress_snapshot(j):
    try:
        c = bz2.compress(bytes(j, 'utf-8'))
    except:
        c = bz2.compress(j)
    return c


def encode_snapshot(c):
    return str(base64.b64encode(c)).replace("b'", "").replace("'", "")

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

if __name__ == '__main__':
    prepare()
    load_files()
    j = create_snapshot()
    c = compress_snapshot(j)
    e = encode_snapshot(c)
    with open('parable.snapshot', 'w') as file:
        file.write(e)
