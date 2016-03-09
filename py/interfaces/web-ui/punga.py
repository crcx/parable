#!/usr/bin/env python3

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
# Punga: a browser based interface to the Parable Language
# (c) 2012 - 2016, Charles Childers
# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

import base64, bz2, cgi, cgitb, json, signal, sys
import parable

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

    parable.dictionary_names = j['symbols']
    parable.dictionary_slices = j['symbol_map']
    parable.errors = j['errors']
    parable.stack = j['stack_values']
    parable.types = j['stack_types']
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
    sys.stdout.write("<table class='table table-bordered'>")
    while i < depth:
        tos = parable.stack[i]
        type = parable.types[i]
        if type == parable.TYPE_NUMBER:
            sys.stdout.write(stack_item(i, "#" + str(tos)))
        elif type == parable.TYPE_CHARACTER:
            sys.stdout.write(stack_item(i, "$" + str(chr(tos))))
        elif type == parable.TYPE_STRING:
            s = "'" + parable.slice_to_string(tos) + "'"
            s = s + "<br>Store at: " + str(tos)
            sys.stdout.write(stack_item(i, s))
        elif type == parable.TYPE_POINTER:
            s = "&amp;" + str(tos)
            if parable.pointer_to_name(tos) != "":
                s = s + "<br>Pointer to: " + parable.pointer_to_name(tos)
            sys.stdout.write(stack_item(i, s))
        elif type == parable.TYPE_FLAG:
            if tos == -1:
                sys.stdout.write(stack_item(i, "true"))
            elif tos == 0:
                sys.stdout.write(stack_item(i, "false"))
            else:
                sys.stdout.write(stack_item(i, "malformed flag"))
        elif type == parable.TYPE_BYTECODE:
            sys.stdout.write(stack_item(i, "`" + str(tos)))
        elif type == parable.TYPE_REMARK:
            s = "\"" + parable.slice_to_string(tos) + "\""
            s = s + "<br>Store at: " + str(tos)
            sys.stdout.write(stack_item(i, s))
        elif type == parable.TYPE_FUNCTION_CALL:
            s = "Call: " + str(tos)
            if parable.pointer_to_name(tos) != "":
                s = s + "<br>Pointer to: " + parable.pointer_to_name(tos)
            sys.stdout.write(stack_item(i, s))
        else:
            sys.stdout.write(stack_item(i, "unmatched type on stack!"))
        i += 1
    sys.stdout.write("</table>")

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def dump_errors():
    if parable.errors:
        sys.stdout.write("<div class='alert alert-warning'>")
        for error in parable.errors:
            sys.stdout.write("<tt>" + error + "</tt><br>")
        sys.stdout.write("</div>")

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def dump_dict():
    """display named items"""
    l = ''
    i = 0
    for w in parable.dictionary_names:
        wx = '<pre>' + w.replace('<', '&lt;').replace('>', '&gt;') + '</pre>'

        slice = parable.dictionary_slices[i]
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
    sys.stdout.write(l)
    sys.stdout.write("\n")

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

def setup_environment():
#    cgitb.enable()
    signal.alarm(60)
    parable.prepare_slices()
    parable.prepare_dictionary()
    bootstrap(open('parable.snapshot', 'r').read())

# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

if __name__ == '__main__':
    setup_environment()
    form = cgi.FieldStorage()
    message = form.getvalue("code", "")
    sys.stdout.write("Content-type: text/html\n\n")

    print("""
        <!DOCTYPE html>
        <head>
            <title>parable language</title>
            <link href="https://maxcdn.bootstrapcdn.com/bootswatch/3.3.6/readable/bootstrap.min.css" rel="stylesheet">
            <link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css" rel="stylesheet">
            <style>div { overflow-y: scroll; -webkit-overflow-scrolling: touch; } i { font-size: 200%; } textarea { font-family:Monaco,Consolas,Liberation Mono,DejaVu Sans Mono,Bitstream Vera Sans Mono,Courier New, monospace; }</style>
            <meta charset=UTF-8>
            <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
            <meta name=apple-mobile-web-app-capable content=yes>
            <meta name=apple-mobile-web-app-status-bar-style content=black>
        </head>
        <body>
        <div class="container-fluid" style="height: 100vh; overflow: hidden">
            <div class="row">
                <div class="col-sm-3"><div class="form-group row">
                    <form name='editor' id='editor' action='punga.py' method='post'>
    """)
    sys.stdout.write("<textarea rows='24' style='height: 85vh' class='col-sm-3 form-control' name='code'")
    sys.stdout.write("placeholder='enter your code here'>")
    sys.stdout.write(message)
    sys.stdout.write("</textarea>")
    print("""
                        <a onClick='document.forms["editor"].submit()' class='form-control btn btn-default'>Evaluate</a>
                    </form></div>
                </div>
                <div class="col-sm-4" style="max-height: 85vh; min-height: 85vh; overflow: scroll">
    """)

    message = message.replace("\\\r\n", " ")
    message = message.replace("\\\n", " ")
    f = parable.condense_lines(message.split("\n"))
    for line in f:
        if len(line) > 1:
            s = parable.compile(line, parable.request_slice())
            parable.interpret(s)
    dump_errors()
    dump_stack()

    print("""
                    &nbsp;
                </div>
                <div class="col-sm-5" style="max-height: 85vh; min-height: 85vh; overflow: scroll">
                    <table class='table table-bordered'>
    """)

    dump_dict()

    print("""
                    </table>
                </div>
            </div>
        </div>
    </div>
    </body>
    </html>
    """)
