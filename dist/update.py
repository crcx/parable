#!/usr/bin/env python3
# coding: utf-8
# This is a small script to download / update the Parable sources

import requests
import os.path
import sys

def download(urls, dir):
    for url in urls:
        sys.stdout.write('  ' + os.path.basename(url) + '\t\t')
        r =  requests.get(url)
        with open(dir + '/' + os.path.basename(url), 'w') as f:
            f.write(r.text)
        print(str(len(r.content)) + ' bytes')

core = [
         'https://raw.githubusercontent.com/crcx/parable/master/source/py/parable.py',
         'https://raw.githubusercontent.com/crcx/parable/master/source/py/stdlib.p',
       ]

allegory = [
             'https://raw.githubusercontent.com/crcx/allegory/master/allegory',
           ]

legend = [
           'https://raw.githubusercontent.com/crcx/legend/master/legend.py',
         ]

paas = [
         'https://raw.githubusercontent.com/crcx/PaaS/master/2016.04',
         'https://raw.githubusercontent.com/crcx/PaaS/master/PaaS.py',
         'https://raw.githubusercontent.com/crcx/PaaS/master/netlistener.py',
        ]

punga = [
         'https://raw.githubusercontent.com/crcx/punga/master/punga.py',
         'https://raw.githubusercontent.com/crcx/punga/master/template.html',
        ]

tools = [
         'https://raw.githubusercontent.com/crcx/ptags/master/ptags.py',
        ]

print('Downloading')
download(core, '.')
download(allegory, '.')
download(legend, '.')
download(paas, 'PaaS')
download(punga, 'Punga')
download(tools, 'tools')
print('Finished')
