#!/usr/bin/env python
# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

import base64
import bz2
import json
import parable
import os
import sys

if __name__ == '__main__':
    parable.prepare_slices()
    parable.prepare_dictionary()
    parable.parse_bootstrap(open('stdlib.p').readlines())

    if len(sys.argv) > 1:
        for i in sys.argv:
            if os.path.exists(i) and i != "./gen-snapshot.py":
                parable.parse_bootstrap(open(i).readlines())

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

    try:
        c = bz2.compress(bytes(j, 'utf-8'))
    except:
        c = bz2.compress(j)

    with open('parable.snapshot', 'w') as file:
        file.write(str(base64.b64encode(c)).replace("b'", "").replace("'", ""))
