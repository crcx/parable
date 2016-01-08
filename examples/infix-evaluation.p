"Infix to Postfix Evaluator"

[ '*Operators'  '*Numbers'  '*Tokens'  '*Offset'  '*End'  'tokenize'  'current-token'  'next-token'  'more?'  'process-token'  'translate'  '@n'  '@o' ] {

  [ "s-"  ' ' split to *Tokens 0 to *Offset *Tokens length? to *End ] 'tokenize' define

  "Helper functions for dealing with the current token."
  [ "-s"  *Tokens *Offset fetch ] 'current-token' define
  [ "-"  *Offset 1 + to *Offset ] 'next-token' define

  "Token Handler"
  [ "-f"  *Offset *End lt? ] 'more?' define
  [ "s-..." \
    [ [ [ current-token numeric? ] [ current-token :n *Numbers push ] ] \
      [ [ current-token '+' eq?  ] [ &+ *Operators push ] ] \
      [ [ current-token '-' eq?  ] [ &- *Operators push ] ] \
      [ [ current-token '*' eq?  ] [ &* *Operators push ] ] \
      [ [ current-token '/' eq?  ] [ &/ *Operators push ] ] \
      [ [ current-token '%' eq?  ] [ &rem *Operators push ] ] \
      [ [ true                   ] [ '...Unknown...' ] ] \
    ] when ] 'process-token' define

  "And finally, the top level compiler loop"
  [ "s-p"  tokenize [ process-token next-token more? ] while ] 'translate' define

  [ *Numbers first *Numbers rest to *Numbers ] '@n' define
  [ *Operators first *Operators rest to *Operators ] '@o' define

  [ "s-n" \
    request-empty to *Numbers \
    request-empty to *Operators \
    translate \
    @n @n @o invoke *Operators length? [ @n @o invoke ] times \
  ] 'evaluate-infix' define
}
