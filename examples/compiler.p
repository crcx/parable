"A Parser & Compiler for Parable (written in Parable)"

"Code basically consists of whitespace delimited tokens. Split them up, and initialize the starting and ending offsets."
[ 'Tokens'  'Offset'  'End' ] variables
[ "s-"  ' ' split !Tokens 0 !Offset @Tokens length? !End ] 'tokenize' define

"Helper functions for dealing with the current token."
[ "-s"  @Tokens @Offset fetch ] 'current-token' define
[ "-s"  current-token rest :s ] 'cleaned-token' define
[ "-c"  current-token first ] 'current-prefix' define
[ "-"  @Offset 1 + !Offset ] 'next-token' define

"Strings (and remarks) can contain spaces. This constructs a string from the tokens, ending when the token has the delimiter as the last character."
[ 'S'  'Delimiter' ] variables
[ "-f"  current-token last @Delimiter eq? ] 'final-token-in-string?' define
[ "-"  @S ' ' + current-token + !S ] 'append-to-string' define
[ "c-s" \
  !Delimiter \
  request-empty :s !S \
  final-token-in-string? \
  [ [ append-to-string next-token final-token-in-string? ] until ] if-false \
  append-to-string \
  "clean string delimiters" \
  @S 2 over length? 1 - subslice :s \
] 'gather-string' define

"Compiler Functions"
[ 'Slice'  'Slices' ] variables
[ "v-"  @Slice push ] 'c,' define
[ "-"  cleaned-token :n c, ] 'compile-number' define
[ "-"  cleaned-token :c c, ] 'compile-character' define
[ "-"  cleaned-token :n :b c, ] 'compile-bytecode' define
[ "-"  $' gather-string c, ] 'compile-string' define
[ "-"  $" gather-string c, ] 'compile-remark' define
[ "s-p"  dup function-exists? [ lookup-function ] [ :n :p ] if ] 'resolve-pointer' define
[ "-" \
  current-token rest :s resolve-pointer c, ] 'compile-pointer' define
[ "-" \
  current-token dup function-exists? \
  [ lookup-function :x c, ] \
  [ dup numeric? \
    [ :n c, ] \
    [ 'ERROR: WORD NOT FOUND' report-error ] \
    if \
  ] if \
] 'compile-funcall' define

[ "-"  \
  @Slice @Slices push \
  request-empty !Slice ] 'begin-quote' define
[ "-"  @Slice [ @Slices pop !Slice ] dip c, ] 'end-quote' define
[ "-"  \
  request-empty !Slices \
  request-empty !Slice \
  @Slice @Slices push ] 'prepare' define

"Token Handler"
[ "-f"  @Offset @End lt? ] 'more?' define
[ "s-..." \
  [ [ [ current-prefix $# eq? ] [ compile-number    ] ] \
    [ [ current-prefix $$ eq? ] [ compile-character ] ] \
    [ [ current-prefix $& eq? ] [ compile-pointer   ] ] \
    [ [ current-prefix $' eq? ] [ compile-string    ] ] \
    [ [ current-prefix $" eq? ] [ compile-remark    ] ] \
    [ [ current-prefix $` eq? ] [ compile-bytecode  ] ] \
    [ [ current-token '[' eq? ] [ begin-quote       ] ] \
    [ [ current-token ']' eq? ] [ end-quote         ] ] \
    [ [ true                  ] [ compile-funcall   ] ] \
  ] when ] 'compile-token' define

"And finally, the top level compiler loop"
[ "s-p"  prepare tokenize [ compile-token next-token more? ] while @Slice ] 'compile' define

'1 [ 2 ] dip 3 +' compile

    '\'Hello World!\' 2 3 *' compile invoke

