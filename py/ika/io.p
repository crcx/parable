[ "value -"  `2000 ] '.' define
[ #10 :c . ] 'show:cr' define
[ #32 :c . ] 'show:space' define

"File Operations"
[ "string:name string:mode - number:file-id"  `3000 ] 'open-file' define
[ "number:file-id -"  `3001 ] 'close-file' define
[ "number:file-id - character"  `3002 :c ] 'read-file' define
[ "character number:file-id -"  `3003 ] 'write-file' define
[ "number:file-id - number:position"  `3004 ] 'file-position' define
[ "number:offset number:file-id -"  `3005 ] 'file-seek' define
[ "number:file-id - number:length"  `3006 ] 'file-size' define
[ "string:name -"  `3007 ] 'delete-file' define
[ "string:name - string:contents"  [ new-slice 'r' open-file dup file-size [ [ read-file slice-store ] sip ] repeat close-file &*slice:current* @ :p :s ] preserve-slice ] 'slurp-file' define
[ "string:name - flag"  `3008 ] 'file-exists?' define

"Command Line Arguments"
[ "- number"  `4000 ] 'arg-count' define
[ "number - string"  `4001 ] 'get-arg' define
