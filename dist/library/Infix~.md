## Infix~

### Overview

### Code

````
"Infix to Postfix Evaluator"

[ 'evaluate-infix' ] 'Infix~' {

  [ 'Operators'  'Numbers'  'Tokens'  'Offset'  'End' ] ::

  [ "s-"  ' ' split !Tokens 0 !Offset @Tokens length? !End ] 'tokenize' :

  "Helper functions for dealing with the current token."
  [ "-s"  @Tokens @Offset fetch ] 'current-token' :
  [ "-"   @Offset 1 + !Offset ] 'next-token' :

  [ "-vf"  current-token lookup-word dup nan? not ] 'var?' :

  "Token Handler"
  [ "-f"  @Offset @End lt? ] 'more?' :
  [ "s-..." \
    [ [ [ current-token numeric? ] [ current-token :n @Numbers push ] ] \
      [ [ current-token '+' eq?  ] [ &+   @Operators push ] ] \
      [ [ current-token '-' eq?  ] [ &-   @Operators push ] ] \
      [ [ current-token '*' eq?  ] [ &*   @Operators push ] ] \
      [ [ current-token '/' eq?  ] [ &/   @Operators push ] ] \
      [ [ current-token '%' eq?  ] [ &rem @Operators push ] ] \
      [ [ current-token '(' eq?  ] [ 'Parenthesis are not supported' abort<with-error> ] ] \
      [ [ current-token ')' eq?  ] [ 'Parenthesis are not supported' abort<with-error> ] ] \
      [ [ true                   ] [ var? [ 1 fetch @Numbers push ] [ drop '...Unknown...' abort<with-error> ] if ] ] \
    ] when ] 'process-token' :

  "And finally, the top level compiler loop"
  [ "s-p"  tokenize [ process-token next-token more? ] while ] 'translate' :

  [ @Numbers   head @Numbers   body !Numbers   ] '_n' :
  [ @Operators head @Operators body !Operators ] '_o' :

  [ "s-n" \
    request-empty !Numbers \
    request-empty !Operators \
    ' + 0' + translate \
    _n _n _o invoke @Operators length? [ _n _o invoke ] times \
    "Evaluate the code in the string as an infix expression. Tokens should be separated by whitespace." \
  ] 'evaluate-infix' :
}}
````

