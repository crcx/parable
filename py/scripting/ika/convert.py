# This is a short tool to convert bootstrap.p, io.p and ika_interface.py
# into a standalone script named 'ika'

print "#!/usr/bin/env python"
print "# Copyright (c)2012-2015, Charles Childers"

def condense_lines(code):
    m = len(code)
    s = ''
    r = []
    i = 0
    c = 0
    while i < m:
        if code[i].endswith(' \\\n'):
            s = s + ' ' + code[i][:-2].strip()
            c = 1
        else:
            c = 0
            s = s + ' ' + code[i]
        if c == 0:
            if s != '' and s != ' \n':
                r.append(s.strip())
            s = ''
        i = i + 1
    return r


print ""
f = open('parable.py').readlines()
for line in f:
    print line.rstrip()

print ""
print "bootstrap = []"
print "# core language functions"
f = condense_lines(open('stdlib.p').readlines())
for line in f:
    if len(line) > 0:
        print 'bootstrap.append(""" ' + line.strip() + ' """)'

print "# i/o functions"
f = condense_lines(open('io.p').readlines())
for line in f:
    if len(line) > 0:
        print 'bootstrap.append(""" ' + line.strip() + ' """)'

print ""
f = open('ika_interface.py').readlines()
for line in f:
    print line.rstrip()
