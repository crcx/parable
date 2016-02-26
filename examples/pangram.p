'Scratch' var
[ "s-f" \
  request-empty :s !Scratch \
  to-lowercase \
  [ dup letter? [ dup :n $a :n - @Scratch swap store ] [ drop ] if ] for-each \
  'abcdefghijklmnopqrstuvwxyz' @Scratch eq? \
] 'pangram?' :

'is this a pangram?' pangram?
'a' pangram?
'is this or this or this zzz' pangram?
'the quick brown fox jumped over the lazy dogs' pangram?

