[ "-"   `2000 ] 'toggle-warnings' :
[ "-"   `9000 ] '.s' :
[ "-"   `9001 ] 'bye' :
[ "-"   `9002 ] 'words' :
[ "s-"  `9003 ] 'include' :
[ "s-"  `9004 ] 'save-snapshot' :
[ "s-"  `9005 ] 'reload-snapshot' :
[ "...-" `9006 ] 'restart' :

"File Operations"
[ "string:name string:mode - number:file-id"  `3000 ] 'open-file' :
[ "number:file-id -"  `3001 ] 'close-file' :
[ "number:file-id - character"  `3002 :c ] 'read-file' :
[ "character number:file-id -"  `3003 ] 'write-file' :
[ "number:file-id - number:position"  `3004 ] 'file-position' :
[ "number:offset number:file-id -"  `3005 ] 'file-seek' :
[ "number:file-id - number:length"  `3006 ] 'file-size' :
[ "string:name -"  `3007 ] 'delete-file' :
[ "string:name - flag"  `3008 ] 'file-exists?' :

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
[ "- number"  `4000 ] 'arg-count' :
[ "number - string"  `4001 ] 'get-arg' :
[ "s-s"  `5000 ] 'value-for-key' :
[ "s-s"  `5001 ] 'get-environment-value' :

"Terminal I/O"
[ "v-"  `6000 ] 'display' :
[ #10 :c display ] 'tty.cr' :

