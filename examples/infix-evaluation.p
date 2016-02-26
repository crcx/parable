"Infix to Postfix Evaluator"

[ 'evaluate-infix' ] {

  [ 'Operators'  'Numbers'  'Tokens'  'Offset'  'End' ] ::

  [ "s-"  ' ' split !Tokens 0 !Offset @Tokens length? !End ] 'tokenize' :

  "Helper functions for dealing with the current token."
  [ "-s"  @Tokens @Offset fetch ] 'current-token' :
  [ "-"  @Offset 1 + !Offset ] 'next-token' :

  "Token Handler"
  [ "-f"  @Offset @End lt? ] 'more?' :
  [ "s-..." \
    [ [ [ current-token numeric? ] [ current-token :n @Numbers push ] ] \
      [ [ current-token '+' eq?  ] [ &+ @Operators push ] ] \
      [ [ current-token '-' eq?  ] [ &- @Operators push ] ] \
      [ [ current-token '*' eq?  ] [ &* @Operators push ] ] \
      [ [ current-token '/' eq?  ] [ &/ @Operators push ] ] \
      [ [ current-token '%' eq?  ] [ &rem @Operators push ] ] \
      [ [ true                   ] [ '...Unknown...' ] ] \
    ] when ] 'process-token' :

  "And finally, the top level compiler loop"
  [ "s-p"  tokenize [ process-token next-token more? ] while ] 'translate' :

  [ @Numbers head @Numbers body !Numbers ] '_n' :
  [ @Operators head @Operators body !Operators ] '_o' :

  [ "s-n" \
    request-empty !Numbers \
    request-empty !Operators \
    translate \
    _n _n _o invoke @Operators length? [ _n _o invoke ] times \
  ] 'evaluate-infix' :
}


'3 * 4 + 1' evaluate-infix

