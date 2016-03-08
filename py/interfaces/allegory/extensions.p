[ "-"   `2000 "Turn on reporting of redefinitions" ] '+warnings' :
[ "-"   `2001 "Turn off reporting of redefinitions" ] '-warnings' :

[ "-"    `9000 "Display the stack" ] '.s' :
[ "-"    `9001 "Exit Allegory" ] 'bye' :
[ "-"    `9002 "Display a list of all named functions" ] 'words' :
[ "s-"   `9003 "Evaluate the contents of a file as Parable source" ] 'include' :
[ "s-"   `9004 "Save the current session to a new script" ] 'save-as' :
[ "...-" `9006 "Soft restart from the embedded snapshot" ] 'restart' :


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
[ 'open-file' 'close-file' 'read-file' 'write-file' 'file-position' 'file-seek' \
  'file-size' 'delete-file' 'file-exists?' 'slurp-file' ] 'Files~' vocab


"Command Line Arguments and System Integration"
[ "- pointer"        `226 \
  "Return an array of all command line arguments. Typically the \
   first two items will be the scripting engine name and the source \
   file being run." \
] 'sys.args' :

[ "string - number"  `227 \
  "Run an external program. Returns the execution status." \
] 'sys.run' :


[ "- number"  `4000 "Deprecated" ] 'arg-count' :
[ "number - string"  `4001 "Deprecated" ] 'get-arg' :
[ "s-s"  `5000 ] 'value-for-key' :
[ "s-s"  `5001 "Return the value of an environment variable" ] 'get-environment-value' :

"Terminal I/O"
[ "v-"  `6000    "Display a value to the screen" ] 'display' :
[ #10 :c display "Display a newline on the screen" ] 'tty.cr' :
[ 'display'  'tty.cr' ] 'ConsoleIO~' vocab

[ "-n" `300 "Return a Unix timestamp" ] 'time' :
[ "p-n" time [ invoke ] dip time swap - "Invoke a function and return the running time (in seconds)" ] 'invoke<time>' :


[ "s-" dup function-exists? [ drop ] [ 'library/' swap + include ] if "Load a library" ] 'needs' :


[ &ConsoleIO~ &Files~ ] [ with ] for-each


[ "-" \
  'allegory, (c)2013-2016 Charles Childers\n\n' display \
  "Entry point for standalone applications (via turnkey)" \
] 'allegory.on-start' :

[ "-" "Exit point for standalone applications (via turnkey)" ] 'allegory.on-end' :
