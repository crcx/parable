# coding: utf-8
# This is a small script to download / update the Parable sources
# under Pythonista.

import requests
import os.path
import sys

urls = ['https://raw.githubusercontent.com/crcx/parable/master/py/allegory',
        'https://raw.githubusercontent.com/crcx/parable/master/py/parable.py',
        'https://raw.githubusercontent.com/crcx/parable/master/py/stdlib.p',
        'https://raw.githubusercontent.com/crcx/parable/master/py/interfaces/listener.py',
       ]

print('Downloading')
for url in urls:
    sys.stdout.write('  ' + os.path.basename(url) + '\t\t')
    r =  requests.get(url)
    if os.path.basename(url) == 'allegory':
        fn = os.path.basename(url) + '.py'
    else:
        fn = os.path.basename(url)
    with open(fn, 'w') as f:
        f.write(r.content.decode())
    print(str(len(r.content)) + ' bytes')
print('Finished')