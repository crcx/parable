# parable
# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

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

    with open('parable.snapshot', 'w') as file:
        file.write(j)
