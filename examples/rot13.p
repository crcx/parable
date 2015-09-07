[ 'nopqrstuvwxyzabcdefghijklm' ] 'rot13:map' define
[ :n $a :n - rot13:map swap fetch :c ] 'encode-letter' define
[ to-lowercase '' swap [ :c dup letter? [ encode-letter ] if-true :s swap + ] for-each ] 'rot13' define

'hello 123 Uryyb' rot13
