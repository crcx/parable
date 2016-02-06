# PaaS - Parable as a Service
# (c) 2016, charles childers

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

import requests


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-


def endpoint():
    return 'http://api.forthworks.com/apologue/2/0'


def getpso():
    payload = { 'req': 'getpso' }
    return requests.post(endpoint(), data=payload).text


def evaluate(pso, source):
    payload = { 'req': 'evaluate', 'source': source, 'pso': pso }
    return requests.post(endpoint(), data=payload).text


def errors(pso):
    payload = { 'req': 'errors', 'pso': pso }
    r = requests.post(endpoint(), data=payload)
    return eval(r.text)


def clear_errors(pso):
    payload = { 'req': 'clear_errors', 'pso': pso }
    return requests.post(endpoint(), data=payload).text


def dictionary_names(pso):
    payload = { 'req': 'dictionary_names', 'pso': pso }
    r = requests.post(endpoint(), data=payload)
    return eval(r.text)


def slice_contents(pso, slice):
    payload = { 'req': 'get_slice', 's': slice, 'pso': pso }
    r = requests.post(endpoint(), data=payload)
    return eval(r.text)


def slice_to_string(pso, slice):
    s = []
    res = slice_contents(pso, slice)
    for c in res:
        s.append(chr(c))
    return ''.join(s)


def stack_values(pso):
    payload = { 'req': 'stack_values', 'pso': pso }
    r = requests.post(endpoint(), data=payload)
    return eval(r.text)


def stack_types(pso):
    payload = { 'req': 'stack_types', 'pso': pso }
    r = requests.post(endpoint(), data=payload)
    return eval(r.text)
