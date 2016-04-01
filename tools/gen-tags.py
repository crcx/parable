#!/usr/bin/env python3

import fnmatch
import os

def tag_for_colon(l, f, i):
    t = l.split(' ')
    return t[-2:-1][0][1:-1] + '\t' + f + '\t' + str(i)

def tag_for_dot(l, f, i):
     t = l.strip().split(' ')
     return t[0:1][0][1:-1] + '\t' + f + '\t' + str(i)

def get_tags_for(pat):
    tags = []
    matches = []
    for root, dir, filenames in os.walk('.'):
        for filename in fnmatch.filter(filenames, pat):
            matches.append(os.path.join(root, filename))
    for f in matches:
        s = open(f, 'r').readlines()
        i = 1
        for l in s:
            if l.endswith('\' :\n'): tags.append(tag_for_colon(l, f, i))
            if l.strip().startswith('\'') and l.endswith(' .\n'): tags.append(tag_for_dot(l, f, i))
            i = i + 1
    return tags

if __name__ == '__main__':
    with open('tags', 'w') as f:
        f.write('!_TAG_FILE_FORMAT 1\n!_TAG_FILE_SORTED 1\n')
        tags = get_tags_for('*.p')
        tags = tags + get_tags_for('*.md')
        for l in sorted(tags):
            f.write(l + '\n')
