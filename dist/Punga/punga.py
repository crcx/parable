#!/usr/bin/env python3

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
# Punga: a browser based interface to the Parable Language
# (c) 2012 - 2016, Charles Childers
# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

import base64, bz2, cgi, cgitb, json, signal, sys
import parable

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def create_snapshot():
    parable.collect_garbage()
    j = json.dumps({"symbols": parable.dictionary, \
                    "errors": parable.errors, \
                    "stack": parable.stack, \
                    "memory_contents": parable.memory_values, \
                    "memory_types": parable.memory_types, \
                    "memory_map": parable.memory_map, \
                    "memory_sizes": parable.memory_size, \
                    "hidden_slices": parable.dictionary_hidden_slices, })
    return j

def compress_snapshot(j):
    try:
        c = bz2.compress(bytes(j, 'utf-8'))
    except:
        c = bz2.compress(j)
    return c


def encode_snapshot(c):
    return str(base64.b64encode(c)).replace("b'", "").replace("'", "")

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def bootstrap(s):
    try:
        raw = base64.b64decode(bytes(s, 'utf-8'))
    except:
        raw = base64.b64decode(s)

    u = bz2.decompress(raw)

    try:
        j = json.loads(u)
    except:
        j = json.loads(u.decode())

    parable.dictionary = j['symbols']
    parable.errors = j['errors']
    parable.stack = j['stack']
    parable.memory_values = j['memory_contents']
    parable.memory_types = j['memory_types']
    parable.memory_map = j['memory_map']
    parable.memory_size = j['memory_sizes']

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def stack_item(i, text):
    """return a HTML row for stack item *i* (which is represented by *text*)"""
    row = "<tr>"
    if i == len(parable.stack) - 1:
        row = row + "<td><strong>" + str(i) + "</strong></td>"
    else:
        row = row + "<td>" + str(i) + "</td>"
    row = row + "<td>" + text + "</td>"
    row = row + "</tr>"
    return row


def dump_stack():
    """display the stack"""
    i = 0
    s = ""
    depth = len(parable.stack)
    html = "<table>"
    while i < depth:
        tos = parable.stack_value_for(i)
        type = parable.stack_type_for(i)
        if type == parable.TYPE_NUMBER:
            html = html + stack_item(i, "#" + str(tos))
        elif type == parable.TYPE_CHARACTER:
            html = html + stack_item(i, "$" + str(chr(tos)))
        elif type == parable.TYPE_STRING:
            s = "'" + parable.slice_to_string(tos) + "'"
            s = s + "<br>Store at: " + str(tos)
            html = html + stack_item(i, s)
        elif type == parable.TYPE_POINTER:
            s = "&amp;" + str(tos)
            if parable.pointer_to_name(tos) != "":
                s = s + "<br>Pointer to: " + parable.pointer_to_name(tos)
            html = html + stack_item(i, s)
        elif type == parable.TYPE_FLAG:
            if tos == -1:
                html = html + stack_item(i, "true")
            elif tos == 0:
                html = html + stack_item(i, "false")
            else:
                html = html + stack_item(i, "malformed flag")
        elif type == parable.TYPE_BYTECODE:
            html = html + stack_item(i, "`" + str(tos))
        elif type == parable.TYPE_REMARK:
            s = "\"" + parable.slice_to_string(tos) + "\""
            s = s + "<br>Store at: " + str(tos)
            html = html + stack_item(i, s)
        elif type == parable.TYPE_FUNCALL:
            s = "Call: " + str(tos)
            if parable.pointer_to_name(tos) != "":
                s = s + "<br>Pointer to: " + parable.pointer_to_name(tos)
            html = html + stack_item(i, s)
        else:
            html = html + stack_item(i, "unmatched type on stack!<br>(" + str(tos) + "," + str(type) + ")")
        i += 1
    html = html + "</table>"
    return html

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def dump_errors():
    html = ""
    if parable.errors:
        for error in parable.errors:
            html = html + "<tt>" + error + "</tt><br>"
    return html

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def dump_dict():
    """display named items"""
    html = "<table>"
    l = ''
    i = 0
    for w in parable.dictionary_names():
        wx = '<pre>' + w.replace('<', '&lt;').replace('>', '&gt;') + '</pre>'

        slice = parable.dictionary_slices()[i]
        cell, type = parable.fetch(slice, 0)
        size = parable.memory_size[slice]
        if type == parable.TYPE_REMARK:
            comment = parable.slice_to_string(cell)
            l = l + '<tr>'
            l = l + '<td width="10%">' + str(slice) + '</td>' + '<td>' + wx
            cell, type = parable.fetch(slice, size)
            if type == parable.TYPE_REMARK:
                l = l + '<br>' + parable.slice_to_string(cell)
            l = l + '</td>'
            l = l + '<td width="20%"><pre>' + comment + '</pre></td></tr>\n'
        else:
            l = l + '<tr><td width-"10%">' + str(slice) + '</td>'
            l = l + '<td colspan="3">' + wx + '</td></tr>\n'
        i = i + 1
    html = html + l
    html = html + "</table>"
    return html

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

form = 0
snapshot = ""

def setup_environment():
    global form, snapshot
    cgitb.enable()
    signal.alarm(60)
    form = cgi.FieldStorage()
    parable.prepare_slices()
    parable.prepare_dictionary()
    snapshot = form.getvalue("snapshot", "{{snapshot}}")
    if snapshot == "{{snapshot}}":
        snapshot = open('parable.snapshot', 'r').read()
    bootstrap(snapshot)

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

if __name__ == '__main__':
    sys.stdout.write("Content-type: text/html\n\n")

    setup_environment()
    code = form.getvalue("code", "")
    message = code.replace("\\\r\n", " ")
    message = message.replace("\\\n", " ")
    f = parable.condense_lines(message.split("\n"))
    for line in f:
        if len(line) > 0:
            s = parable.compile(line, parable.request_slice())
            parable.interpret(s)

    with open('template.html') as file:
        template = file.read()

    stack = dump_stack()
    errors = dump_errors()
    dict = dump_dict()

    template = template.replace('{{code}}', code)
    template = template.replace('{{stack}}', stack)
    template = template.replace('{{errors}}', errors)
    template = template.replace('{{dict}}', dict)

    shot = encode_snapshot(compress_snapshot(create_snapshot()))
    template = template.replace('{{snapshot}}', shot)
    print(template)
