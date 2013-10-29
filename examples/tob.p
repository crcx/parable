"This is basically a continuation of some bits I had done for an earlier"
"Retro. I had intended for Retro 7 to buffer output and display it as an"
"editable set of blocks, with input being provided via the editor. This"
"did not pan out, but the idea stuck with me."

"Since Parable explicitly lacks an I/O model, something like this is"
"needed to allow for rendering messages to the user after a program is"
"run."

"This will setup an array named TOB, which will contain strings for each"
"item being displayed. At the end, the program should call SHOW-TOB to"
"push the strings to the stack for display."

'TOB' variable
[ &TOB array-push ] 'tob.append' define
[ :s tob.append ] 'tob.number' define
[ type? POINTER = [ :n :s tob.append ] [ tob.number ] if ] 'tob.pointer' define
[ type? FLAG = [ :s tob.append ] [ tob.pointer ] if ] 'tob.flag' define
[ type? CHARACTER = [ :s tob.append ] [ tob.flag ] if ] 'tob.character' define
[ type? STRING = [ tob.append ] [ tob.character ] if ] 'tob.string' define
[ tob.string ] '.' define
[ &TOB array-length [ &TOB array-pop :p :s ] repeat ] 'show-tob' define


"A simple test"

#0 #100 [ dup :s 'This is cycle ' swap + . #1 + ] repeat drop
show-tob
