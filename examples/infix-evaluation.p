"Infix to Postfix Evaluator"

[ 'Operators'  'Numbers'  'Tokens'  'Offset'  'End'  'tokenize'  'current-token'  'next-token'  'more?'  'process-token'  'translate'  '_n'  '_o' ] {

  [ "s-"  ' ' split !Tokens 0 !Offset @Tokens length? !End ] 'tokenize' define

  "Helper functions for dealing with the current token."
  [ "-s"  @Tokens @Offset fetch ] 'current-token' define
  [ "-"  @Offset 1 + !Offset ] 'next-token' define

  "Token Handler"
  [ "-f"  @Offset @End lt? ] 'more?' define
  [ "s-..." \
    [ [ [ current-token numeric? ] [ current-token :n @Numbers push ] ] \
      [ [ current-token '+' eq?  ] [ &+ @Operators push ] ] \
      [ [ current-token '-' eq?  ] [ &- @Operators push ] ] \
      [ [ current-token '*' eq?  ] [ &* @Operators push ] ] \
      [ [ current-token '/' eq?  ] [ &/ @Operators push ] ] \
      [ [ current-token '%' eq?  ] [ &rem @Operators push ] ] \
      [ [ true                   ] [ '...Unknown...' ] ] \
    ] when ] 'process-token' define

  "And finally, the top level compiler loop"
  [ "s-p"  tokenize [ process-token next-token more? ] while ] 'translate' define

  [ @Numbers first @Numbers rest !Numbers ] '_n' define
  [ @Operators first @Operators rest !Operators ] '_o' define

  [ "s-n" \
    request-empty !Numbers \
    request-empty !Operators \
    translate \
    _n _n _o invoke @Operators length? [ _n _o invoke ] times \
  ] 'evaluate-infix' define
}


'3 * 4 + 1' evaluate-infix

