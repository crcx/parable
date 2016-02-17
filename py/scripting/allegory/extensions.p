[ "-"   `9000 ] '.s' define
[ "-"   `9001 ] 'bye' define
[ "-"   `9002 ] 'words' define
[ "s-"  `9003 ] 'include' define
[ "s-"  `9004 ] 'save-snapshot' define
[ "s-"  `9005 ] 'reload-snapshot' define
[ "...-" `9006 ] 'restart' define

"File Operations"
[ "string:name string:mode - number:file-id"  `3000 ] 'open-file' define
[ "number:file-id -"  `3001 ] 'close-file' define
[ "number:file-id - character"  `3002 :c ] 'read-file' define
[ "character number:file-id -"  `3003 ] 'write-file' define
[ "number:file-id - number:position"  `3004 ] 'file-position' define
[ "number:offset number:file-id -"  `3005 ] 'file-seek' define
[ "number:file-id - number:length"  `3006 ] 'file-size' define
[ "string:name -"  `3007 ] 'delete-file' define
[ "string:name - flag"  `3008 ] 'file-exists?' define

[ 'slurp-file' ] {
  [ 'FID' 'S' ] variables
  [ "string:name - string:contents" \
    dup file-exists? \
    [ 'r' open-file !FID \
      request !S @S pop drop \
      @FID file-size [ @FID read-file @S push ] times \
      @FID close-file \
      @S :s \
    ] \
    [ drop '' duplicate-slice :s ] \
    if \
  ] 'slurp-file' define
}


"Command Line Arguments and System Integration"
[ "- number"  `4000 ] 'arg-count' define
[ "number - string"  `4001 ] 'get-arg' define
[ "s-s"  `5000 ] 'value-for-key' define
[ "s-s"  `5001 ] 'get-environment-value' define

"Terminal I/O"
[ "v-"  `6000 ] 'display' define
[ #10 :c display ] 'tty.cr' define

