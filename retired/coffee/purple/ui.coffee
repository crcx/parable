# purple, a ui for parable.coffee
# copyright (c)2014, charles childers
# =============================================================


# create_cell(max, index, type, value)
# returns a line of HTML corresponding to a table cell for
# the specified stack item

create_cell = (max, index, type, value) ->
    index = index + 1
    extra = ""
    if type == 'string'
        extra = "<br>Stored in &amp;#{stack[index - 1]}"
    if type == 'pointer'
        if pointer_to_name(parseInt(value.substr(5))) != ""
            extra = "<br>Pointer to <em>#{pointer_to_name parseInt value.substr 5}</em>"
    if index == max
        "<td>#{value}<hr>Type: #{type}<br>Item #{index} of #{max}#{extra}<br>(<b>Top Of Stack</b>)</td>"
    else
        "<td>#{value}<hr>Type: #{type}<br>Item #{index} of #{max}#{extra}</td>"


# display_stack()
# generate a stack display and inject it into the DOM element named 'stack'

display_stack = ->
    s = "<table class='table table-condensed table-bordered'><tr>"
    if sp <= 0
        document.getElementById('stack').innerHTML = "<b>empty stack</b>"
        return
    i = sp
    while i > 0
        i = i - 1
        if types[i] == TYPE_STRING
            s = s + create_cell sp, i, 'string', "'" + slice_to_string(stack[i]) + "'"
        else if types[i] == TYPE_CHARACTER
            s = s + create_cell sp, i, 'character', '$' + String.fromCharCode stack[i]
        else if types[i] == TYPE_FLAG
            if stack[i] == -1
                s = s + create_cell sp, i, 'flag', 'true'
            else if stack[i] == 0
                s = s + create_cell sp, i, 'flag', 'false'
            else
                s = s + create_cell sp, i, 'flag', 'malformed flag'
        else if types[i] == TYPE_NUMBER
            s = s + create_cell sp, i, 'number', '#' + stack[i]
        else if types[i] == TYPE_FUNCTION
            s = s + create_cell sp, i, 'pointer', '&amp;' + stack[i]
        else
            s = s + "<td>Unknown data type for value " + stack[i] + "<hr>#{i}</td>"
    s = s + "</tr></table>"
    document.getElementById('stack').innerHTML = s
    s


# parable_compile_and_run()
# retrieve the code in the 'code' editor DOM element,
# parse it into an array, and pass to compile_source()
# after execution completes, update the stack display,
# dictionary, logs, and session statistics

parable_compile_and_run = ->
    code = document.getElementById('code').value
    code = code + "\n"
    compile_source code.split("\n")
    display_stack()
    parable_display_symbols()
    parable_update_log()
    parable_update_stats()
    0


# parable_empty_stack()
# handler for the button to quickly empty out the
# stack. redraws the stack when done.

parable_empty_stack = ->
    sp = 0
    display_stack()
    parable_update_stats()
    0


# parable_append_symbol(text)
# append the specified text into the code editor. this is used
# by the dictionary display parable_display_symbols()

parable_append_symbol = (txt) ->
    code = document.getElementById("code")
    original = code.value
    code.value = "#{original} #{txt} "
    0


parable_display_symbols = ->
    s = "<table class='table table-condensed table-bordered'><tr>"
    for i in dictionary_names
        s = s + "<td><a onClick='parable_append_symbol(\"#{i}\");'>#{i}</a><br>"
        s = s + "Stored in slice &amp;#{lookup_pointer(i)}</td>"
    s = s + "</tr></table>"
    document.getElementById('symbols').innerHTML = s
    0


parable_clear_log = ->
    log = []
    document.getElementById('log').innerHTML = '<b>nothing to report</b>'


parable_update_log = ->
    if log.length == 0
        document.getElementById('log').innerHTML = '<b>nothing to report</b>'
    else
        s = "<table class='table table-condensed table-bordered'><tr>"
        for i in log
            s = s + "<td>#{i}</td>"
        s = s + "</tr></table>"
        document.getElementById('log').innerHTML = s


parable_update_stats = ->
    s = ""
    used = 0
    i = 0
    while i < MAX_SLICES
        if p_map[i] != 0
            used++
        i++
    s = s + "<p>Used #{used} of #{MAX_SLICES} slices.<p>"
    s = s + "<p>Current stack depth: #{sp}.</p>"
    s = s + "<hr>"
    s = s + "<div class='btn-group'>"
    s = s + "<button class='btn btn-default' onClick='parable_collect_garbage();'>Collect Garbage</button>"
    s = s + "<button class='btn btn-default' onClick='parable_clear_log();'>Clear Logs</button>"
    s = s + "<button class='btn btn-default' onClick='parable_empty_stack();'>Clear Stack</button>"
    s = s + "</div>"
    document.getElementById('stats').innerHTML = s
    s

parable_collect_garbage = ->
    if sp == 0
        collect_unused_slices()
        parable_update_stats()
    else
        log.push 'Error: stack must be cleared before garbage collection'
        parable_update_log()
