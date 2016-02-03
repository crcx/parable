# PaaS - Parable as a Service
# (c) 2016, charles childers

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-


import urllib
import urllib2


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-


def endpoint():
    return 'http://api.forthworks.com/apologue/2/0'


def getpso():
    url = endpoint()
    params = urllib.urlencode({
      'req': 'getpso',
    })
    return urllib2.urlopen(url, params).read()


def evaluate(pso, source):
    url = endpoint()
    params = urllib.urlencode({
      'req': 'evaluate',
      'source': source,
      'pso': pso,
    })
    return urllib2.urlopen(url, params).read()


def errors(pso):
    url = endpoint()
    params = urllib.urlencode({
      'req': 'errors',
      'pso': pso,
    })
    return eval(urllib2.urlopen(url, params).read())


def clear_errors(pso):
    url = endpoint()
    params = urllib.urlencode({
      'req': 'clear_errors',
      'pso': pso,
    })
    return urllib2.urlopen(url, params).read()


def dictionary_names(pso):
    url = endpoint()
    params = urllib.urlencode({
      'req': 'dictionary_names',
      'pso': pso,
    })
    return eval(urllib2.urlopen(url, params).read())


def slice_contents(pso, slice):
    url = endpoint()
    params = urllib.urlencode({
      'req': 'get_slice',
      's': slice,
      'pso': pso,
    })
    return eval(urllib2.urlopen(url, params).read())


def slice_to_string(pso, slice):
    s = []
    res = slice_contents(pso, slice)
    for c in res:
        s.append(unichr(c))
    return ''.join(s)


def stack_values(pso):
    url = endpoint()
    params = urllib.urlencode({
      'req': 'stack_values',
      'pso': pso,
    })
    return eval(urllib2.urlopen(url, params).read())


def stack_types(pso):
    url = endpoint()
    params = urllib.urlencode({
      'req': 'stack_types',
      'pso': pso,
    })
    return eval(urllib2.urlopen(url, params).read())
