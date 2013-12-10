[ "value -"  `1000 ] '.' define
[ #10 :c . ] 'show:cr' define
[ #32 :c . ] 'show:space' define

"File Operations"
[ "string:name string:mode - number:file-id"  `2000 ] 'open-file' define
[ "number:file-id -"  `2001 ] 'close-file' define
[ "number:file-id - character"  `2002 :c ] 'read-file' define
[ "character number:file-id -"  `2003 ] 'write-file' define
[ "number:file-id - number:position"  `2004 ] 'file-position' define
[ "number:offset number:file-id -"  `2005 ] 'file-seek' define
[ "number:file-id - number:length"  `2006 ] 'file-size' define
[ "string:name -"  `2007 ] 'delete-file' define
[ "string:name - string:contents"  [ new-slice 'r' open-file dup file-size [ [ read-file slice-store ] sip ] repeat close-file &*slice-current* @ :p :s ] preserve-slice ] 'slurp-file' define

"Command Line Arguments"
[ "- number"  `3000 ] 'arg-count' define
[ "number - string"  `3001 ] 'get-arg' define
