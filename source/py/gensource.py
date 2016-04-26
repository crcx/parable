import os

def extract_from_markdown(name):
    v = []
    with open(name) as f:
        v = f.readlines()
    s = []
    fence = False
    for l in v:
        l = l.rstrip()
        if fence == True and l != '````':
            s.append(l)
        elif l == '````' and fence == True:
            fence = False
        elif l == '````' and fence == False:
            fence = True
    return s


if __name__ == '__main__':
    with open('parable.py', 'w') as file:
        lines = extract_from_markdown('parable.md')
        for line in lines:
            file.write(line)
            file.write('\n')
    with open('stdlib.p', 'w') as file:
        lines = extract_from_markdown('stdlib.md')
        for line in lines:
            file.write(line)
            file.write('\n')
