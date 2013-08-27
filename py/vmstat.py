# parable vm statistics
#
# this is an optional module to add some functions for reporting
# potentially useful information about the virtual machine state
# after execution completes.
#
# Copyright (c) 2013, Charles Childers
# See LICENSE for usage terms
# ========================================================================

from parable import *

def vm_slices_used():
    global MAX_SLICES, p_map
    i = 0
    j = 0
    while (i < MAX_SLICES):
        if p_map[i] == 1:
            j += 1
        i += 1
    return j
