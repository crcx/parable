#
# An attempt to export a parable session into a C array
# for compiling/running on embedded targets
#

import sys
from parable import *

if __name__ == '__main__':
    prepare_slices()
    prepare_dictionary()
    parse_bootstrap()

    sys.stdout.write("/* parable to c */\n")
    sys.stdout.write("float p_slices[] = {\n")

    i = 0
    while (i < MAX_SLICES):
        j = 0
        while (j < len(p_slices[i])):
            sys.stdout.write(str(fetch(i, j)))
            j += 1
            sys.stdout.write(",")
        i += 1
    sys.stdout.write("0};\n")
