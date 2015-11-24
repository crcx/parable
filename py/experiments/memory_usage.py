#!/usr/bin/env python

import sys
import parable


def vm_slices_used():
    i = 0
    for x in parable.p_map:
        if x == 1:
            i += 1
    return str(i)


if __name__ == '__main__':
    parable.prepare_slices()
    parable.prepare_dictionary()
    parable.parse_bootstrap(open('stdlib.p').readlines())

    print 'Slices used by stdlib (no GC):   \t' + vm_slices_used()
    parable.collect_unused_slices()
    print 'Slices used by stdlib (after GC):\t' + vm_slices_used()
