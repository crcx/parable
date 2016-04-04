[ "-"   `2000 "Turn on reporting of redefinitions" ] '+warnings' :
[ "-"   `2001 "Turn off reporting of redefinitions" ] '-warnings' :

[ "-"    `9001 "Exit Allegory" ] 'bye' :
[ "-"    `9002 "Display a list of all named words" ] 'words' :
[ "s-"   `9003 "Evaluate the contents of a file as Parable source" ] 'include' :
[ "s-"   `9004 "Save the current session to a new script" ] 'save-as' :
[ "...-" `9006 "Soft restart from the embedded snapshot" ] 'restart' :

[ "-s"  `200 "Get user home directory" ] 'home-directory' :

"File Operations"
[ "string:name string:mode - number:file-id"  `201  "Open a file. Valid modes include R, W, and A" ] 'open-file' :
[ "number:file-id -"                          `202  "Close an open file" ] 'close-file' :
[ "number:file-id - character"                `203  "Read a character from a file" ] 'read-file' :
[ "character number:file-id -"                `204  "Write a character to a file" ] 'write-file' :
[ "number:file-id - number:position"          `205  "Return the current value of the index pointer into the file" ] 'file-position' :
[ "number:offset number:file-id -"            `206  "Move the index pointer into a file to a new position" ] 'file-seek' :
[ "number:file-id - number:length"            `207  "Return the size of an open file" ] 'file-size' :
[ "string:name -"                             `208  "Delete a file" ] 'delete-file' :
[ "string:name - flag"                        `209  "True if the file exists, otherwise false" ] 'file-exists?' :

[ 'slurp-file' ] {
  [ 'FID' 'S' ] ::

  [ "string:name - string:contents" \
    dup file-exists? \
    [ 'r' open-file !FID \
      request !S @S pop drop \
      @FID file-size [ @FID read-file @S push ] times \
      @FID close-file \
      @S :s \
    ] \
    [ drop '' duplicate-slice :s 'Unable to to locate file' abort<with-error> ] \
    if \
    "Read a file into a new slice" \
  ] 'slurp-file' :
}


"Command Line Arguments and System Integration"
[ "- pointer"        `226 \
  "Return an array of all command line arguments. Typically the \
   first two items will be the scripting engine name and the source \
   file being run." \
] 'sys.args' :

[ "string - number"  `227 \
  "Run an external program. Returns the execution status." \
] 'sys.run' :


[ "- number"         sys.args 2 -            "Deprecated" ] 'arg-count' :
[ "number - string"  sys.args swap 2 - fetch "Deprecated" ] 'get-arg' :

[ "s-s"  `5000 ] 'value-for-key' :
[ "s-s"  `5001 "Return the value of an environment variable" ] 'get-environment-value' :


"Terminal I/O"
[ "v-"  `6000    "Display a value to the screen" ] 'display' :
[ '\n'   display "Display a newline on the screen" ] 'tty.cr' :
[ '\t'   display "Display a newline on the screen" ] 'tty.tab' :

[ "-n" `300 "Return a Unix timestamp" ] 'time' :
[ "p-n" time [ invoke ] dip time swap - "Invoke a function and return the running time (in seconds)" ] 'invoke<time>' :

'library/' 'LibraryPath' var!
[ 'needs' ] {
  [ "s-sf" dup file-exists? ] 'present?' :
  [ "s-s"  @LibraryPath swap + ] '+path' :
  [ "s-" \
    dup word-exists? \
    [ drop ] \
    [ +path present? \
      [ include ] \
      [ '.md' + present? \
        [ include ] \
        [ drop ] if \
      ] if \
    ] if \
    "Load a library" \
  ] 'needs' :
}

[ "s-" [ needs ] [ lookup-word with ] bi "Load a library and expose the vocabulary immediately" ] 'needs<now>' :

[ '.s' ] {
  [ 'I' 'V' ] ::

  [ "-" @I zero? [ 'TOS\ \ \ ' ] [ '\ \ \ \ \ \ ' ] if display ] 'indicate' :

  [ "-" \
    @V pop \
    [ [ [ bytecode?  ] [ "$` display" display                  ] ] \
      [ [ remark?    ] [ $" display display $" display         ] ] \
      [ [ string?    ] [ $' display display $' display         ] ] \
      [ [ number?    ] [ $# display display                    ] ] \
      [ [ character? ] [ $$ display display                    ] ] \
      [ [ pointer?   ] [ "$& display" display                  ] ] \
      [ [ flag?      ] [ display                               ] ] \
      [ [ funcall?   ] [ "'CALL ' display $& display" display  ] ] \
      [ [ true       ] [ 'Unknown type: ' display :n display   ] ] \
    ] when tty.cr \
  ] 'display-cell' :

  [ "-" @I display tty.tab ] 'display-offset' :

  [ "-" \
    depth 1 - !I \
    stack-values reverse !V \
    depth [ indicate display-offset display-cell &I decrement ] times \
    "Display the items on the stack" \
  ] '.s' :
}

[ "-" \
  'allegory, (c)2013-2016 Charles Childers\n\n' display \
  'on_startup.md' dup file-exists? \
  [ include ] \
  [ drop home-directory '/.parable/on_startup.md' + dup file-exists? [ include ] [ drop ] if ] if \
  "Entry point for standalone applications (via turnkey)" \
] 'allegory.on-start' :

[ "-" .s "Exit point for standalone applications (via turnkey)" ] 'allegory.on-end' :


[ 'open-file' 'close-file' 'read-file' 'write-file' 'file-position' 'file-seek' \
  'file-size' 'delete-file' 'file-exists?' 'slurp-file' ] 'Files~' vocab

[ 'display'  'tty.cr' 'tty.tab' ] 'ConsoleIO~' vocab

[ '+warnings' '-warnings' '.s' 'bye' 'words' 'include' 'save-as' \
  'restart' 'Files~' 'sys.args' 'sys.run' 'arg-count' 'get-arg' \
  'value-for-key' 'get-environment-value' 'ConsoleIO~' 'time' \
  'invoke<time>' 'needs' 'allegory.on-start' 'allegory.on-end' \
  'home-directory' 'LibraryPath' 'needs<now>' \
] 'Allegory~' vocab

&Allegory~ with
[ &ConsoleIO~ &Files~ ] [ with ] for-each
