#!/usr/bin/env python

# Copyright (c) 2014  Charles Childers

import sys
import os

def refine(code):
    s = ''
    r = []
    for l in code:
        if l != '\n':
            s = s + ' ' + l.strip()
        else:
            r.append(s)
            s = ''
    return r


for source in sys.argv:
    if not os.path.exists(source):
        sys.exit('ERROR: source file "%s" was not found!' % source)
    if source != sys.argv[0]:
        for line in refine(open(source).readlines()):
            print line

