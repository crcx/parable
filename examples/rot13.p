'nopqrstuvwxyzabcdefghijklm'  '*ROT13:Map' value!
[ "c-c"  :n $a :n - *ROT13:Map swap fetch :c ] 'encode-letter' define
[ "s-s"  to-lowercase '' swap [ :c dup letter? [ encode-letter ] if-true :s swap + ] for-each ] 'rot13' define

'hello 123 Uryyb' rot13
