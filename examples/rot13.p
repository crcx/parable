[ 'ROT13:Map'  'encode' ] {
  'nopqrstuvwxyzabcdefghijklm' !ROT13:Map
  [ "c-c"  :n $a :n - @ROT13:Map swap fetch :c ] 'encode' define

  [ "s-s" \
    to-lowercase '' swap \
    [ :c dup letter? [ encode ] if-true :s swap + ] for-each \
    reverse :s \
  ] 'rot13' define
}
'hello 123 Uryyb Z' rot13
