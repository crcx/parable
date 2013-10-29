"a simple combinator that assembles a string from the strings returned"
"by a quotation."

[ invoke-count-items #1 - [ [ :s ] bi@ + ] repeat ] 'build-string' define

"a couple of sample uses"
[ 'hello' #32 :c 'world' '!' ] build-string
[ 'hello' ] build-string
[ [ 'hello' #32 :c ] build-string 'world' ] build-string
