[ "-"   `2000 ] '+warnings' :
[ "-"   `2001 ] '-warnings' :
[ "-"   `9000 ] '.s' :
[ "-"   `9001 ] 'bye' :
[ "-"   `9002 ] 'words' :
[ "s-"  `9003 ] 'include' :
[ "s-"  `9004 ] 'save-snapshot' :
[ "s-"  `9005 ] 'reload-snapshot' :
[ "...-" `9006 ] 'restart' :


"File Operations"
[ "string:name string:mode - number:file-id"  `201 ] 'open-file' :
[ "number:file-id -"  `202 ] 'close-file' :
[ "number:file-id - character"  `203 :c ] 'read-file' :
[ "character number:file-id -"  `204 ] 'write-file' :
[ "number:file-id - number:position"  `205 ] 'file-position' :
[ "number:offset number:file-id -"  `206 ] 'file-seek' :
[ "number:file-id - number:length"  `207 ] 'file-size' :
[ "string:name -"  `208 ] 'delete-file' :
[ "string:name - flag"  `209 ] 'file-exists?' :

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


[ "-p" `250 ] 'vm.memory<map>' :
[ "-p" `251 ] 'vm.memory<sizes>' :
[ "-p" `252 ] 'vm.memory<allocated>' :

[ "- number"  `4000 ] 'arg-count' :
[ "number - string"  `4001 ] 'get-arg' :
[ "s-s"  `5000 ] 'value-for-key' :
[ "s-s"  `5001 ] 'get-environment-value' :

"Terminal I/O"
[ "v-"  `6000 ] 'display' :
[ #10 :c display ] 'tty.cr' :

