[ #1 #100 [ [ dup * ] [ #1 + ] bi ] repeat drop ] capture-results
#0 [ + ] reduce

[ #1 #100 expand-range ] capture-results #0 [ + ] reduce
dup * swap -
