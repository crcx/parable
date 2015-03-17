# =============================================================
# this should all be moved to a separate file sometime...

display_stack = ->
    if sp <= 0
        return
    i = sp
    while i > 0
        i = i - 1
        if types[i] == TYPE_STRING
            console.log "%d:\t'%s'", i, slice_to_string(stack[i])
        else if types[i] == TYPE_CHARACTER
            console.log "%d:\t$%s", i, String.fromCharCode stack[i]
        else if types[i] == TYPE_FLAG
            if stack[i] == -1
                console.log "%d\t%s", i, 'true'
            else if stack[i] == 0
                console.log "%d\t%s", i, 'false'
            else
                console.log "%d\t%s", i, 'malformed flag'
        else if types[i] == TYPE_NUMBER
            console.log "%d\t#%d", i, stack[i]
        else if types[i] == TYPE_FUNCTION
            console.log "%d\t&%d", i, stack[i]
        else
            console.log "%d\tUnknown type: %d", i, stack[i]


fs = require 'fs'
prepare()
compile_source(fs.readFileSync('bootstrap.p').toString().split("\n"))
compile_source(fs.readFileSync(process.argv[2]).toString().split("\n"))
display_stack()
