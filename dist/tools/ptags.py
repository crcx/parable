#!/usr/bin/env python3

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
# generate a ctags compatible tags file for parable
#
# constraints:
#
# - code can be in either a *.p or *.md file
#    - in *.p, everything is code
#    - in *.md, code either has four spaces at the start of the line or
#      is fenced with four backticks (````)
# - syntax for naming a function can be complicated
#    - basic form:
#      [ ... ] 'name' :
#    - alternate form:
#      'name' [ ... ] .
#    - variable forms:
#      'name' var
#
#      ... 'name' var!
#
#      [ 'name' 'name2' 'name3' ... ] ::
#    - functions can span multiple source lines:
#      'hello' [ "-s" \
#          'hello world!' ] .
# - tag file formats
#   - classic ctags (for vim):
#      tag  filename  line#
#   - textmate requires:
#      tag  filename  /^search_string$/;"  function  line:line#
#   - replace the separators with a single tab

import argparse
import fnmatch
import os


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

# form 0: not a definition
# form 1: [ ... ] 'name' :
# form 2: 'name' [ ... ] .
# form 3: 'name' var   OR   'name' var!
# form 4: [ 'name' 'name' ] ::

def determine_form(src):
    form = 0
    line = src.strip()
    if line.endswith('\' :'): form = 1
    if line.startswith('\'') and line.endswith(' .'): form = 2
    if line.startswith('\'') and line.endswith(' var'): form = 3
    if line.startswith('\'') and line.endswith(' var!'): form = 3
    if line.startswith('[ \'') and line.endswith(' ::'): form = 4
    return form


def extract_tags(src, form):
    tags = []
    tokens = src.strip().split(' ')
    if form == 1 or form == 3:
        token = tokens[-2:][0:1][0]
        tags.append(token[1:-1])
    elif form == 2:
        token = tokens[0:1][0]
        tags.append(token[1:-1])
    elif form == 4:
        token = tokens[1:-2]
        for t in token:
            if t != '':
                tags.append(t[1:-1])
    return tags

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

def tag(tag, textmate=False):
    name = tag[0]
    file = os.getcwd() + '/' + tag[1][2:]
    line = tag[2]
    if textmate:
        return name + '\t' + file + '\t' + '/^\'' + name + '\'$/;"\tfunction\tline:' + str(line)
    else:
        return name + '\t' + file + '\t' + str(line)

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

def get_tags_for(pat, textmate=False):
    tags = []
    matches = []
    for root, dir, filenames in os.walk('.'):
        for filename in fnmatch.filter(filenames, pat):
            matches.append(os.path.join(root, filename))
    for f in matches:
        words = []
        print('Scanning ' + f + '...')
        s = open(f, 'r').readlines()
        i = 1
        for l in s:
            form = determine_form(l)
            if form != 0:
                for tag in extract_tags(l, form):
                    words.append((tag, f, i))
            i = i + 1
        print(' + ' + str(len(words)) + ' identified')
        tags = tags + words
    return sorted(tags)


def write_tags(tagfile, textmate=False):
    tags = get_tags_for('*.p')
    tags = tags + get_tags_for('*.md')
    with open(tagfile, 'w') as f:
        for l in sorted(tags):
            f.write(tag(l, textmate) + '\n')
    return len(tags)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='ctags for parable')
    parser.add_argument('--ctags', help='generate vim compatible tags', action="store_true")
    parser.add_argument('--tmtags', help='generate textmate compatible tags', action="store_true")
    args = vars(parser.parse_args())

    if args['ctags']:
        write_tags('tags')

    if args['tmtags']:
        write_tags('tmtags', textmate=True)

    if not args['ctags'] and not args['tmtags']:
        print('Specify tags format!')
