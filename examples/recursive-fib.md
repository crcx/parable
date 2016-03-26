Recursion in Parble is done via redefinition.

    [ ] 'fib' :
    [ "n-n" dup #1 gt? [ [ #1 - fib ] sip #2 - fib + ] if-true ] 'fib' :

A test:

    #20 fib
