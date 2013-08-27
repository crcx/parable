#!/usr/bin/env python
# Copyright (c) 2013  Charles Childers
#

import sys
import cgi
import cgitb; cgitb.enable()  # for troubleshooting

import signal
signal.alarm(60)

from parable import *

def dump_stack():
    """display the stack"""
    global stack
    i = 0
    sys.stdout.write("<table class='table table-bordered'>")
    while i < len(stack):
        if i == len(stack) - 1:
            sys.stdout.write("<tr><td><strong>" + str(i) + "</strong>")
        else:
            sys.stdout.write("<tr><td>" + str(i))
        if types[i] == TYPE_NUMBER:
            sys.stdout.write("</td><td>#" + str(stack[i]) + "</td></tr>")
        elif types[i] == TYPE_CHARACTER:
            sys.stdout.write("</td><td>$" + str(chr(stack[i])) + "</td></tr>")
        elif types[i] == TYPE_STRING:
            sys.stdout.write("</td><td>'" + slice_to_string(stack[i]) +"'" + "<br><span style='color: #D3D3D3;'>Stored at: " + str(stack[i]) + "</span></td></tr>")
        elif types[i] == TYPE_FUNCTION:
            sys.stdout.write("</td><td>&" + str(stack[i]))
            if pointer_to_name(stack[i]) != "":
                sys.stdout.write("<br><span style='color: #D3D3D3;'>Pointer to: " + pointer_to_name(stack[i]) + "</span>");
            sys.stdout.write("</td></tr>")
        elif types[i] == TYPE_FLAG:
            if stack[i] == -1:
                sys.stdout.write("</td><td>true" + "</td></tr>")
            elif stack[i] == 0:
                sys.stdout.write("</td><td>false" + "</td></tr>")
            else:
                sys.stdout.write("</td><td>malformed flag" + "</td></tr>")
        else:
            sys.stdout.write("</td><td>unmatched type on stack!" + "</td></tr>")
        i += 1
    sys.stdout.write("</table>")

def dump_errors():
    global errors

    if errors:
        sys.stdout.write("<div class='alert alert-error'>")
        i = 0
        while i <= len(errors):
            sys.stdout.write("<tt>" + errors.pop() + "</tt><br>")
            i += 1
        sys.stdout.write("</div>")

def dump_dict():
    """display named items"""
    l = ''
    for w in dictionary_names:
        l = l + w + ' '
    sys.stdout.write(l)
    sys.stdout.write("\n")



sys.stdout.write("Content-type: text/html\n\n")

print """
<!DOCTYPE html>
<head>
<title>parable language</title>
<link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.min.css" rel="stylesheet">
<link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css" rel="stylesheet">
<style>
    i { font-size: 200%; }
</style>
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-246810-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
<meta charset=UTF-8>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<body>
<div class="container">
  <div class="row"><div class="span12">&nbsp;</div></div>

  <div class="row">
    <div class="span6">
      <form name='editor' id='editor' action='punga.cgi' method='post'>
"""
sys.stdout.write("<textarea rows='12' class='span6' name='code' placeholder='enter your code here'>")
form = cgi.FieldStorage()
message = form.getvalue("code", " ")
sys.stdout.write(message)
sys.stdout.write("</textarea>")
print """
      <a onClick='document.forms["editor"].submit()' class='btn'>Evaluate</a>
      </form>
    </div>
    <div class="span6">
"""

prepare_slices()
prepare_dictionary()
parse_bootstrap()
collect_unused_slices()

f = message.split("\n")
counter = 0
for line in f:
    if len(line) > 1:
        s = compile(line, request_slice())
        interpret(s)
        counter += 1
        if counter > 100:
            if len(stack) == 0:
                collect_unused_slices()
                counter = 0
    dump_errors()

dump_stack()

# from vmstat import *
# print "<p>Used " + str(vm_slices_used()) + " of " + str(MAX_SLICES) + " slices.</p>"

print """
      &nbsp;
    </div>
  </div>

  <div class="row"><div class="span12">&nbsp;</div></div>

  <div class="row"><div class="span12"><a href="http://forthworks.com/parable">Parable</a><br>
    &copy; 2012-2013, <a href="http://forthworks.com">Charles Childers</a>
  </div></div>
</div>
</body>
</html>
"""
