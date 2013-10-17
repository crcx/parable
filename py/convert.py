# This is a short tool to convert bootstrap.p and pre_interface.py into
# a standalone script named 'pre'

print "#!/usr/bin/env python"
print "# Copyright (c)2012-2013, Charles Childers"

f = open('parable.py').readlines()
for line in f:
    print line.rstrip()

print "bootstrap = []"
f = open('bootstrap.p').readlines()
for line in f:
    if len(line) > 1:
        print 'bootstrap.append(""" ' + line.strip() + ' """)'

f = open('pre_interface.py').readlines()
for line in f:
    print line.rstrip()
