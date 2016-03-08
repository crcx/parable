#!/usr/bin/env python3
# (c) 2015, 2016 Charles Childers

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-


import base64, cgi, cgitb, bz2, json, signal, sys
import io
import parable


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-


def extract(pso, key):
    raw = base64.b64decode(pso)
    j = json.loads(bz2.decompress(raw).decode())
    return j[key]


def save_snapshot():
    j = json.dumps({"symbols": parable.dictionary_names,
                    "symbol_map": parable.dictionary_slices,
                    "stack_values": parable.stack,
                    "stack_types": parable.types,
                    "errors": parable.errors,
                    "memory_contents": parable.memory_values,
                    "memory_types": parable.memory_types,
                    "memory_map": parable.memory_map,
                    "memory_sizes": parable.memory_size})
    o = bz2.compress(bytes(j, 'utf-8'))
    return base64.b64encode(o)


def load_snapshot(data):
    raw = base64.b64decode(data)
    j = json.loads(bz2.decompress(raw).decode())
    parable.dictionary_names = j['symbols']
    parable.dictionary_slices = j['symbol_map']
    parable.stack = j['stack_values']
    parable.types = j['stack_types']
    parable.memory_values = j['memory_contents']
    parable.memory_types = j['memory_types']
    parable.memory_map = j['memory_map']
    parable.memory_size = j['memory_sizes']
    parable.errors = j['errors']


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-


def getpso(form):
    parable.prepare_slices()
    parable.prepare_dictionary()
    parable.parse_bootstrap(open('stdlib.p').readlines())
    parable.collect_garbage()
    pso = save_snapshot().decode()
    return pso


def evaluate(form):
    pso = form.getvalue("pso")
    load_snapshot(pso)
    parable.errors = []
    source = form.getvalue("source")
    process_input(source)
    pso = save_snapshot().decode()
    return pso


def dictionary(form):
    pso = form.getvalue("pso")
    load_snapshot(pso)
    j = json.dumps({"names": parable.dictionary_names,
                    "pointers": parable.dictionary_slices,
                  })
    return j


def stack(form):
    pso = form.getvalue("pso")
    load_snapshot(pso)
    j = json.dumps({"values": parable.stack,
                    "types": parable.types,
                  })
    return j


def dictionary_names(form):
    pso = form.getvalue("pso")
    load_snapshot(pso)
    return extract(pso, 'symbols')


def dictionary_map(form):
    pso = form.getvalue("pso")
    load_snapshot(pso)
    return extract(pso, 'symbol_map')


def stack_values(form):
    pso = form.getvalue("pso")
    load_snapshot(pso)
    return extract(pso, 'stack_values')


def stack_types(form):
    pso = form.getvalue("pso")
    load_snapshot(pso)
    return extract(pso, 'stack_types')


def get_slice(form):
    pso = form.getvalue("pso")
    load_snapshot(pso)
    s = int(form.getvalue("s"))
    memory = extract(pso, 'memory_contents')
    return memory[s]


def errors(form):
    pso = form.getvalue("pso")
    load_snapshot(pso)
    return extract(pso, 'errors')


def clear_errors(form):
    pso = form.getvalue("pso")
    load_snapshot(pso)
    parable.clear_errors()
    return save_snapshot().decode()


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-


def handler(signum, frame):
    print("Content-Type: application/json")
    print("")
    report('FATAL ERROR: Execution exceed max runtime permitted')
    sys.exit('fatal error: execution runtime exceeded')


def process_input(source):
    filtered = source.replace("\\\r\n", " ")
    filtered = filtered.replace("\\\n", " ")
    lines = filtered.split("\n")

    for line in lines:
        line = line.strip()
        if len(line) >= 1 and line != '':
            slice = parable.compile(line, parable.request_slice())
            parable.interpret(slice)


# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-


if __name__ == '__main__':
    # Cap max run time at 60 seconds
    # (This seems satisfactory so far, and keeps server load managable)
    signal.signal(signal.SIGALRM, handler)
    signal.alarm(60)

    # get input (in "code" field)
    form = cgi.FieldStorage()

    req = form.getvalue("req")
    res = ""

    if req == "getpso":
        res = getpso(form)

    if req == "evaluate":
        res = evaluate(form)

    if req == "dictionary":
        res = dictionary(form)

    if req == "stack":
        res = stack(form)

    if req == "dictionary_names":
        res = dictionary_names(form)

    if req == "dictionary_map":
        res = dictionary_names(map)

    if req == "stack_values":
        res = stack_values(form)

    if req == "stack_types":
        res = stack_types(form)

    if req == "errors":
        res = errors(form)

    if req == "clear_errors":
        res = clear_errors(form)

    if req == "get_slice":
        res = get_slice(form)

    print("Content-Type: text/plain")
    print("")
    print(res)

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
