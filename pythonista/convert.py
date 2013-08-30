print "bootstrap = []"

f = open('bootstrap.parable').readlines()
for line in f:
    if len(line) > 1:
        print 'bootstrap.append(""" ' + line.strip() + ' """)'
