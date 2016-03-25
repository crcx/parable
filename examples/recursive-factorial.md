[ ] 'factorial' :
[ dup zero? [ #1 + ] [ dup #1 eq? [ dup #1 - factorial * ] if-false ] if ]
'factorial' :

#10 factorial
