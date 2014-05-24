[ 'fee'  'fi'  'fo'  'fum'  'a' ] array-from-quote 'vector1' define
[ 'a'  'small'  'fee'  'due'  'q' ] array-from-quote 'vector2' define
&vector1 [ :p :s &vector2 array-contains-string? ] array-filter
string array-to-string
