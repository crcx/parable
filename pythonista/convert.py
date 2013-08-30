print "bootstrap = []"

f = open('../py/bootstrap.p').readlines()
for line in f:
    if len(line) > 1:
        print 'bootstrap.append(""" ' + line.strip() + ' """)'
