print "#!/usr/bin/env python"
print "# Copyright (c)2012-2016, Charles Childers"

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

f = open('../../parable.py').readlines()
for line in f:
    print line.rstrip()

print "stdlib = []"
f = condense_lines(open('../../stdlib.p').readlines())
for line in f:
    if len(line) > 0:
        print 'stdlib.append(""" ' + line.strip() + ' """)'

print "extensions = []"
f = condense_lines(open('extensions.p').readlines())
for line in f:
    if len(line) > 0:
        print 'extensions.append(""" ' + line.strip() + ' """)'

f = open('interface.py').readlines()
for line in f:
    print line.rstrip()
