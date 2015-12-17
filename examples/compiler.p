"A Parser & Compiler for Parable (written in Parable)"

"Code basically consists of whitespace delimited tokens. Split them up, and initialize the starting and ending offsets."
[ '*Tokens'  '*Offset'  '*End' ] values
[ "s-"  ' ' split to *Tokens 0 to *Offset *Tokens length? to *End ] 'tokenize' define

"Helper functions for dealing with the current token."
[ "-s"  *Tokens *Offset fetch ] 'current-token' define
[ "-s"  current-token rest :s ] 'cleaned-token' define
[ "-c"  current-token @ ] 'current-prefix' define
[ "-"  *Offset 1 + to *Offset ] 'next-token' define

"Strings (and comments) can contain spaces. This constructs a string from the tokens, ending when the token has the delimiter as the last character."
[ '*S'  '*Delimiter' ] values
[ "-f"  current-token last *Delimiter eq? ] 'final-token-in-string?' define
[ "-"  *S ' ' + current-token + to *S ] 'append-to-string' define
[ "c-s" \
  to *Delimiter \
  request-empty :s to *S \
  final-token-in-string? \
  [ [ append-to-string next-token final-token-in-string? ] while-false ] if-false \
  append-to-string \
  "clean string delimiters" \
  *S 2 over length? 1 - subslice :s \
] 'gather-string' define

"Compiler Functions"
[ '*Slice'  '*Slices' ] values
[ "v-"  *Slice push ] 'c,' define
[ "-"  cleaned-token :n c, ] 'compile-number' define
[ "-"  cleaned-token :c c, ] 'compile-character' define
[ "-"  cleaned-token :n :b c, ] 'compile-bytecode' define
[ "-"  $' gather-string c, ] 'compile-string' define
[ "-"  $" gather-string c, ] 'compile-comment' define
[ "s-p"  dup function-exists? [ lookup-function ] [ :n :p ] if ] 'resolve-pointer' define
[ "-" \
  current-token rest :s resolve-pointer c, ] 'compile-pointer' define
[ "-" \
  current-token dup function-exists? \
  [ lookup-function :call c, ] \
  [ dup numeric? \
    [ :n c, ] \
    [ 'ERROR: WORD NOT FOUND' report-error ] \
    if \
  ] if \
] 'compile-funcall' define

[ "-"  \
  *Slice *Slices push \
  request-empty to *Slice ] 'begin-quote' define
[ "-"  *Slice [ *Slices pop to *Slice ] dip c, ] 'end-quote' define
[ "-"  \
  request-empty to *Slices \
  request-empty to *Slice \
  *Slice *Slices push ] 'prepare' define

"Token Handler"
[ "-f"  *Offset *End lt? ] 'more?' define
[ "s-..." \
  [ [ [ current-prefix $# eq? ] [ compile-number    ] ] \
    [ [ current-prefix $$ eq? ] [ compile-character ] ] \
    [ [ current-prefix $& eq? ] [ compile-pointer   ] ] \
    [ [ current-prefix $' eq? ] [ compile-string    ] ] \
    [ [ current-prefix $" eq? ] [ compile-comment   ] ] \
    [ [ current-prefix $` eq? ] [ compile-bytecode  ] ] \
    [ [ current-token '[' eq? ] [ begin-quote       ] ] \
    [ [ current-token ']' eq? ] [ end-quote         ] ] \
    [ [ true                  ] [ compile-funcall   ] ] \
  ] when ] 'compile-token' define

"And finally, the top level compiler loop"
[ "s-p"  prepare tokenize [ compile-token next-token more? ] while-true *Slice ] 'compile' define

'1 [ 2 ] dip 3 +' compile

    '\'Hello World!\' 2 3 *' compile invoke

