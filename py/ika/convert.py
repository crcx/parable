# This is a short tool to convert bootstrap.p, io.p and ika_interface.py
# into a standalone script named 'ika'

print "#!/usr/bin/env python"
print "# Copyright (c)2012-2013, Charles Childers"

print ""
f = open('parable.py').readlines()
for line in f:
    print line.rstrip()

print ""
print "bootstrap = []"
print "# core language functions"
f = open('bootstrap.p').readlines()
for line in f:
    if len(line) > 1:
        print 'bootstrap.append(""" ' + line.strip() + ' """)'

print "# i/o functions"
f = open('io.p').readlines()
for line in f:
    if len(line) > 1:
        print 'bootstrap.append(""" ' + line.strip() + ' """)'

print ""
f = open('ika_interface.py').readlines()
for line in f:
    print line.rstrip()
