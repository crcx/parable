Recursion in Parble is done via redefinition.

    [ ] 'factorial' :
    [ "n-n" \
      dup zero? [ 1 + ] [ dup 1 eq? [ dup 1 - factorial * ] if-false ] if ]
    'factorial' :

Example:

    10 factorial
