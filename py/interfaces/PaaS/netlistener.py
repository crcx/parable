#!/usr/bin/env python3
# netlistener - listener using PaaS backend
# (c) 2016, charles childers


import PaaS
import sys

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

parable = 0

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-


def stack(pso):
    s = PaaS.stack(pso)
    v = s['values']
    t = s['types']
    a = []
    x = 0
    while x < len(v):
        if t[x] == 100:
            a.append('#' + str(v[x]))
        if t[x] == 200:
            a.append('\'' + PaaS.slice_to_string(pso, v[x]) + '\'')
        if t[x] == 300:
            a.append('$' + chr(v[x]))
        if t[x] == 400:
            a.append('&' + str(v[x]))
        if t[x] == 500:
            a.append('FLAG: ' + str(v[x]))
        if t[x] == 600:
            a.append('`' + str(v[x]))
        if t[x] == 700:
            a.append('"' + PaaS.slice_to_string(pso, v[x]) + '"')
        if t[x] == 800:
            a.append('CALL: ' + str(v[x]))
        x += 1
    return a


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-


def get_input():
    done = 0
    s = ''
    while done == 0:
        s = s + input()
        if s.endswith(' \\'):
            s = s[:-2].strip() + ' '
        else:
            done = 1
    return s


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-


def sep():
    for i in range(1, 40):
        sys.stdout.write('-+')
    sys.stdout.write('\n')


def prompt():
    sys.stdout.write('input> ')


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-


if __name__ == '__main__':
    print("")
    print('netlistener, (c) 2016 Charles Childers')
    sep()
    print('.s\tdisplay stack')
    print('words\tdisplay all named items')
    print('bye\texit netlistener')
    sep()

    parable = PaaS.getpso()

    while True:
        prompt()
        sys.stdout.flush()

        try:
            src = get_input()
        except:
            sys.stdout.write("\n")
            exit()

        if len(src) >= 1:
            if src == ".s":
                for i in stack(parable):
                    sys.stdout.write(i + '  ')
                sys.stdout.write("\n")
            elif src == "words":
                dictionary = PaaS.dictionary(parable)
                for w in dictionary['names']:
                    sys.stdout.write(w + ' ')
                sys.stdout.write("\n")
            elif src == "bye":
                sys.stdout.write("\n")
                exit()
            else:
                try:
                    parable = PaaS.evaluate(parable, src)
                except:
                    sys.stdout.write("\n")
                    pass

        for e in PaaS.errors(parable):
            print(e)

        parable = PaaS.clear_errors(parable)

        sys.stdout.flush()
