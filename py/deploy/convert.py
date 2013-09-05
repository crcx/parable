print "#!/usr/bin/env python"
print "# Copyright (c)2012-2013, Charles Childers"

f = open('../parable.py').readlines()
for line in f:
    print line.rstrip()

print "bootstrap = []"
f = open('../bootstrap.p').readlines()
for line in f:
    if len(line) > 1:
        print 'bootstrap.append(""" ' + line.strip() + ' """)'

f = open('interface').readlines()
for line in f:
    print line.rstrip()
