# parable
# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

import base64
import bz2
import json
import parable

if __name__ == '__main__':
    parable.prepare_slices()
    parable.prepare_dictionary()
    parable.parse_bootstrap(open('stdlib.p').readlines())

    j = json.dumps({"symbols": parable.dictionary_names, \
                    "symbol_map": parable.dictionary_slices, \
                    "errors": parable.errors, \
                    "stack_values": parable.stack, \
                    "stack_types": parable.types, \
                    "memory_contents": parable.memory_values, \
                    "memory_types": parable.memory_types, \
                    "memory_map": parable.memory_map, \
                    "memory_sizes": parable.memory_size})

    try:
        c = bz2.compress(bytes(j, 'utf-8'))
    except:
        c = bz2.compress(j)

    with open('parable.snapshot', 'w') as file:
        file.write(str(base64.b64encode(c)))
