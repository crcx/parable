[ #1 #2 [ dup-pair + dup #4000000 < ] while-true drop ] array-from-quote
[ even? ] array-filter
#0 [ + ] array-reduce
