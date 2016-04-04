#!/usr/bin/env python3

# gen-tags.py
# Generate a ctags compatible tags file for Parable


import fnmatch
import os

def tag(tag, file, line, textmate):
    if textmate:
        return tag + '\t' + os.getcwd() + '/' + file[2:] + '\t' + '/^\'' + tag + '\'$/;"\tfunction\tline:' + str(line)
    else:
        return tag + '\t' + os.getcwd() + '/' + file[2:] + '\t' + str(line)

def tag_for_colon(l, f, i, textmate):
    t = l.split(' ')
    print('  ' + t[-2:-1][0][1:-1])
    return tag(t[-2:-1][0][1:-1], f, i, textmate)

def tag_for_dot(l, f, i, textmate):
     t = l.strip().split(' ')
     print('  ' + t[0:1][0][1:-1])
     return tag(t[0:1][0][1:-1], f, i, textmate)

def get_tags_for(pat, textmate=False):
    tags = []
    matches = []
    for root, dir, filenames in os.walk('.'):
        for filename in fnmatch.filter(filenames, pat):
            matches.append(os.path.join(root, filename))
    for f in matches:
        print('Scanning ' + f + '...')
        s = open(f, 'r').readlines()
        i = 1
        for l in s:
            if l.endswith('\' :\n'): tags.append(tag_for_colon(l, f, i, textmate))
            if l.strip().startswith('\'') and l.endswith(' .\n'): tags.append(tag_for_dot(l, f, i, textmate))
            i = i + 1
    return tags

if __name__ == '__main__':
    with open('tags', 'w') as f:
        tags = get_tags_for('*.p')
        tags = tags + get_tags_for('*.md')
        for l in sorted(tags):
            f.write(l + '\n')
        print(str(len(tags)) + ' words found')

    with open('tmtags', 'w') as f:
        tags = get_tags_for('*.p', textmate=True)
        tags = tags + get_tags_for('*.md', textmate=True)
        for l in sorted(tags):
            f.write(l + '\n')
