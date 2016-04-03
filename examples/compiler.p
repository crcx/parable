"A Parser & Compiler for Parable (written in Parable)"

"Code basically consists of whitespace delimited tokens. Split them up, and initialize the starting and ending offsets."
[ 'Tokens'  'Offset'  'End' ] ::
[ "s-"  ' ' split !Tokens 0 !Offset @Tokens length? !End ] 'tokenize' :

"Helper functions for dealing with the current token."
[ "-s"  @Tokens @Offset fetch ] 'current-token' :
[ "-s"  current-token body :s ] 'cleaned-token' :
[ "-c"  current-token head ] 'current-prefix' :
[ "-"  @Offset 1 + !Offset ] 'next-token' :

"Strings (and remarks) can contain spaces. This constructs a string from the tokens, ending when the token has the delimiter as the last character."
[ 'S'  'Delimiter' ] ::
[ "-f"  current-token tail @Delimiter eq? ] 'final-token-in-string?' :
[ "-"  @S ' ' + current-token + !S ] 'append-to-string' :
[ "c-s" \
  !Delimiter \
  request-empty :s !S \
  final-token-in-string? \
  [ [ append-to-string next-token final-token-in-string? ] until ] if-false \
  append-to-string \
  "clean string delimiters" \
  @S 2 over length? 1 - subslice :s \
] 'gather-string' :

"Compiler Functions"
[ 'Slice'  'Slices' ] ::
[ "v-"  @Slice push ] 'c,' :
[ "-"  cleaned-token :n c, ] 'compile-number' :
[ "-"  cleaned-token :c c, ] 'compile-character' :
[ "-"  cleaned-token :n :b c, ] 'compile-bytecode' :
[ "-"  $' gather-string c, ] 'compile-string' :
[ "-"  $" gather-string c, ] 'compile-remark' :
[ "s-p"  dup word-exists? [ lookup-word ] [ :n :p ] if ] 'resolve-pointer' :
[ "-" \
  current-token body :s resolve-pointer c, ] 'compile-pointer' :
[ "-" \
  cleaned-token dup word-exists? \
  [ lookup-word :x c, ] \
  [ dup numeric? \
    [ :n :p :x c, ] \
    [ 'ERROR: WORD NOT FOUND' report-error ] \
    if \
  ] if \
] 'compile-funcall-prefixed' :
[ "-" \
  current-token dup word-exists? \
  [ lookup-word :x c, ] \
  [ dup numeric? \
    [ :n c, ] \
    [ 'ERROR: WORD NOT FOUND' report-error ] \
    if \
  ] if \
] 'compile-funcall' :

[ "-"  \
  @Slice @Slices push \
  request-empty !Slice ] 'begin-quote' :
[ "-"  @Slice [ @Slices pop !Slice ] dip c, ] 'end-quote' :
[ "-"  \
  request-empty !Slices \
  request-empty !Slice \
  @Slice @Slices push ] 'prepare' :

"Token Handler"
[ "-f"  @Offset @End lt? ] 'more?' :
[ "s-..." \
  [ [ [ current-prefix $# eq? ] [ compile-number    ] ] \
    [ [ current-prefix $$ eq? ] [ compile-character ] ] \
    [ [ current-prefix $& eq? ] [ compile-pointer   ] ] \
    [ [ current-prefix $' eq? ] [ compile-string    ] ] \
    [ [ current-prefix $" eq? ] [ compile-remark    ] ] \
    [ [ current-prefix $` eq? ] [ compile-bytecode  ] ] \
    [ [ current-prefix $| eq? ] [ compile-funcall-prefixed ] ] \
    [ [ current-token '[' eq? ] [ begin-quote       ] ] \
    [ [ current-token ']' eq? ] [ end-quote         ] ] \
    [ [ true                  ] [ compile-funcall   ] ] \
  ] when ] 'compile-token' :

"And finally, the top level compiler loop"
[ "s-p"  prepare tokenize [ compile-token next-token more? ] while @Slice ] 'compile' :

'1 [ 2 ] dip 3 +' compile

    '\'Hello World!\' 2 3 *' compile invoke

&+

'4 5 |21' compile invoke
'15 5 |+' compile invoke

