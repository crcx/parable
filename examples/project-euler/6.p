[ #1 #100 [ [ dup * ] [ #1 + ] bi ] repeat drop ] array-from-quote
#0 [ + ] array-reduce
[ #1 #100 expand-range ] array-from-quote #0 [ + ] array-reduce
dup * swap -
