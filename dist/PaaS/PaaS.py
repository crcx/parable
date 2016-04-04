# PaaS - Parable as a Service
# (c) 2016, charles childers

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

import requests
import json

def make_request(d):
    url = 'http://api.forthworks.com/PaaS/2016.04'
    return requests.post(url, data=d).text

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-


def obtain():
    payload = { 'req': 'obtain' }
    return make_request(payload)


def evaluate(pso, source):
    payload = { 'req': 'evaluate', 'source': source, 'snapshot': pso }
    return make_request(payload)


def dictionary(pso):
    payload = { 'req': 'dictionary', 'snapshot': pso }
    r = make_request(payload)
    return json.loads(r)


def stack(pso):
    payload = { 'req': 'stack', 'snapshot': pso }
    r = make_request(payload)
    return json.loads(r)


def errors(pso):
    payload = { 'req': 'errors', 'snapshot': pso }
    r = make_request(payload)
    return json.loads(r)


def slice_contents(pso, slice):
    payload = { 'req': 'slice', 'which': slice, 'snapshot': pso }
    r = make_request(payload)
    return json.loads(r)


def slice_to_string(pso, slice):
    s = []
    res = slice_contents(pso, slice)
    for c in res:
        s.append(chr(c))
    return ''.join(s)
