[ ] 'factorial' define
[ dup zero? [ #1 + ] [ dup #1 eq? [ dup #1 - factorial * ] if-false ] if ]
'factorial' define

#10 factorial
