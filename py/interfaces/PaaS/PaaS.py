# PaaS - Parable as a Service
# (c) 2016, charles childers

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

import requests

def make_request(d):
    url = 'http://api.forthworks.com/apologue/2/0'
    return requests.post(url, data=d).text

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-


def getpso():
    payload = { 'req': 'getpso' }
    return make_request(payload)


def evaluate(pso, source):
    payload = { 'req': 'evaluate', 'source': source, 'pso': pso }
    return make_request(payload)


def dictionary(pso):
    payload = { 'req': 'dictionary', 'pso': pso }
    r = make_request(payload)
    return eval(r)


def stack(pso):
    payload = { 'req': 'stack', 'pso': pso }
    r = make_request(payload)
    return eval(r)


def errors(pso):
    payload = { 'req': 'errors', 'pso': pso }
    r = make_request(payload)
    return eval(r)


def clear_errors(pso):
    payload = { 'req': 'clear_errors', 'pso': pso }
    return make_request(payload)


def dictionary_names(pso):
    payload = { 'req': 'dictionary_names', 'pso': pso }
    r = make_request(payload)
    return eval(r)


def slice_contents(pso, slice):
    payload = { 'req': 'get_slice', 's': slice, 'pso': pso }
    r = make_request(payload)
    return eval(r)


def slice_to_string(pso, slice):
    s = []
    res = slice_contents(pso, slice)
    for c in res:
        s.append(chr(c))
    return ''.join(s)


def stack_values(pso):
    payload = { 'req': 'stack_values', 'pso': pso }
    r = make_request(payload)
    return eval(r)


def stack_types(pso):
    payload = { 'req': 'stack_types', 'pso': pso }
    r = make_request(payload)
    return eval(r)
