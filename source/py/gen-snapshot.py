#!/usr/bin/env python3
# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

import base64
import bz2
import json
import parable
import os
import sys

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

standalone = False
target = "parable.snapshot"

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def embed_parable():
    with open('parable.py', 'r') as file:
        p = file.read()
    return p

def parse_args():
    global standalone, target
    files = []
    if len(sys.argv) > 1:
        for i in sys.argv:
            if i.startswith("python3") or i.startswith("pypy3"):
                pass
            elif i.startswith("--"):
                if i.startswith("--output="):
                    target = i[9:]
                if i.startswith("--standalone"):
                    standalone = True
            else:
                files.append(i)
    return files

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def prepare():
    parable.prepare_slices()
    parable.prepare_dictionary()
    parable.parse_bootstrap(open('stdlib.p').readlines())


def load_files(files):
    for i in files:
        if os.path.exists(i) and i != "./gen-snapshot.py" and i != "gen-snapshot.py" :
            parable.parse_bootstrap(open(i).readlines())


def create_snapshot():
    parable.collect_garbage()
    j = json.dumps({"symbols": parable.dictionary, \
                    "errors": parable.errors, \
                    "stack": parable.stack, \
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
    load_files(parse_args())
    j = create_snapshot()
    c = compress_snapshot(j)
    e = encode_snapshot(c)

    with open(target, 'w') as file:
        if standalone:
            file.write(embed_parable() + "\n")
            file.write('stdlib="' + e + '"\n')
        else:
            file.write(e)
