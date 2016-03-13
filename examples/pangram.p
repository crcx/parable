'Scratch' var

[ "s-f" \
  request :s !Scratch 25 @Scratch :p set<final-offset> \
  to-lowercase [ letter? ] filter \
  [ @Scratch :p over :n $a :n - store ] for-each \
  'abcdefghijklmnopqrstuvwxyz' @Scratch eq? \
] 'pangram?' :

'is this a pangram?' pangram?
'a' pangram?
'is this or this or this zzz' pangram?
'the quick brown fox jumped over the lazy dogs' pangram?
