#!/usr/bin/env python3

# gfm - Github Flavored Markdown to HTML
#
# gfm.py input.md

import sys

import requests

def get_html(f):
    h = {
      'Content-Type': 'text/plain',
    }
    url = 'https://api.github.com/markdown/raw'
    r = requests.post(url, headers=h, data=f)
    return r.text


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('./gfm.py source')
    else:
        print(get_html(open(sys.argv[1]).read()))

