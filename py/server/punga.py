#!/usr/bin/env python

# Parable, Copyright (c) 2012 - 2015  Charles Childers
#
# This is *Punga*, a browser based interface layer for Parable.
# 
# Punga is a CGI script that presents a simple form based editor. When the user
# submits the form, Parable processes the code, and the refereshed page has the
# original code and execution results.
#
# Setup:
#
# Copy punga.py, parable.py, stdlib.p to your *cgi-bin* location.
# Configure your server to allow running punga.py
#
# Notes:
#
# * This uses Bootstrap CSS (loaded from a CDN) to simplify layout
#

import cgi, cgitb, signal, sys
import parable


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
        elif type == parable.TYPE_COMMENT:
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


def dump_errors():
    if parable.errors:
        sys.stdout.write("<div class='alert alert-error'>")
        for error in parable.errors:
            sys.stdout.write("<tt>" + error + "</tt><br>")
        sys.stdout.write("</div>")


def dump_dict():
    """display named items"""
    l = ''
    for w in parable.dictionary_names:
        l = l + w + ' '
    sys.stdout.write(l)
    sys.stdout.write("\n")


def setup_environment():
    cgitb.enable()
    signal.alarm(60)
    parable.prepare_slices()
    parable.prepare_dictionary()
    parable.parse_bootstrap(open('stdlib.p').readlines())


if __name__ == '__main__':
    setup_environment()
    form = cgi.FieldStorage()
    message = form.getvalue("code", "")
    sys.stdout.write("Content-type: text/html\n\n")

    print("""
        <!DOCTYPE html>
        <head>
            <title>parable language</title>
            <link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.min.css" rel="stylesheet">
            <link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css" rel="stylesheet">
            <style>i { font-size: 200%; }</style>
            <meta charset=UTF-8>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
        </head>
        <body>
        <div class="container">
            <div class="row"><div class="span12">&nbsp;</div></div>
            <div class="row">
                <div class="span6">
                    <form name='editor' id='editor' action='punga.py' method='post'>
    """)
    sys.stdout.write("<textarea rows='12' class='span6' name='code' ")
    sys.stdout.write("placeholder='enter your code here'>")
    sys.stdout.write(message)
    sys.stdout.write("</textarea>")
    print("""
                        <a onClick='document.forms["editor"].submit()' class='btn'>Evaluate</a>
                    </form>
                </div>
                <div class="span6">
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
            </div>
            <div class="row"><div class="span12">&nbsp;</div></div>
            <div class="row"><div class="span12">
                <a href="http://forthworks.com/parable">Parable</a><br>
                &copy; 2012 - 2015, <a href="http://forthworks.com">Charles Childers</a>
            </div>
        </div>
    </div>
    </body>
    </html>
    """)
