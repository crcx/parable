#!/usr/bin/env python3
# netlistener - listener using PaaS backend
# (c) 2016, charles childers

import PaaS
import sys

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

    parable = PaaS.obtain()

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
                for i in PaaS.stack(parable)['parsed']:
                    sys.stdout.write(i + '  ')
                sys.stdout.write("\n")
            elif src == "words":
                for w in PaaS.dictionary(parable)['names']:
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

        sys.stdout.flush()
