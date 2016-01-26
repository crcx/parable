[ "-"   `9000 ] '.s' define
[ "-"   `9001 ] 'bye' define
[ "-"   `9002 ] 'words' define
[ "s-"  `9003 ] 'include' define
[ "-"   `9004 ] 'save-session' define
[ "-"   `9005 ] 'reload-session' define

"VM State"
[ "-p"  `9100 ] 'vm.dict<names>' define
[ "-p"  `9101 ] 'vm.dict<slices>' define
[ '*S' ] {
  [ "-p" \
    request-empty to *S \
    depth [ *S push ] times \
    *S reverse dup to *S invoke \
    *S \
  ] 'vm.stack' define
}

"File Operations"
[ "string:name string:mode - number:file-id"  `3000 ] 'open-file' define
[ "number:file-id -"  `3001 ] 'close-file' define
[ "number:file-id - character"  `3002 :c ] 'read-file' define
[ "character number:file-id -"  `3003 ] 'write-file' define
[ "number:file-id - number:position"  `3004 ] 'file-position' define
[ "number:offset number:file-id -"  `3005 ] 'file-seek' define
[ "number:file-id - number:length"  `3006 ] 'file-size' define
[ "string:name -"  `3007 ] 'delete-file' define


[ '*FID'  '*S' ] {
  [ "string:name - string:contents" \
    'r' open-file to *FID \
    request to *S *S pop drop \
    *FID file-size [ *FID read-file *S push ] times \
    *FID close-file \
    *S :s \
  ] 'slurp-file' define
}

[ "string:name - flag"  `3008 ] 'file-exists?' define

"Command Line Arguments"
[ "- number"  `4000 ] 'arg-count' define
[ "number - string"  `4001 ] 'get-arg' define

"Command Line Arguments and System Integration"
[ "- number"  `4000 ] 'arg-count' define
[ "number - string"  `4001 ] 'get-arg' define
[ "s-s"  `5000 ] 'value-for-key' define
[ "s-s"  `5001 ] 'get-environment-value' define
