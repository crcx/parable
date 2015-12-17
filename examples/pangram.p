'*Scratch' value
[ "s-f" \
  request-empty :s to *Scratch \
  to-lowercase \
  [ dup letter? [ dup $a - *Scratch swap store ] [ drop ] if ] for-each \
  'abcdefghijklmnopqrstuvwxyz' *Scratch eq? \
] 'pangram?' define

'is this a pangram?' pangram?
'a' pangram?
'is this or this or this zzz' pangram?
'the quick brown fox jumped over the lazy dogs' pangram?

