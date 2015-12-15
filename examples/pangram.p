'*scratch' value
[ "s-f" \
  request :s to *scratch \
  to-lowercase \
  [ dup letter? [ dup $a - *scratch swap store ] [ drop ] if ] for-each \
  'abcdefghijklmnopqrstuvwxyz' *scratch eq? \
] 'pangram?' define

'is this a pangram?' pangram?
'a' pangram?
'is this or this or this zzz' pangram?
'the quick brown fox jumped over the lazy dogs' pangram?

