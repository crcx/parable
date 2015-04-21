'key' value
'str' value
[ :c :s key find [ true ] [ false ] if ] 'match?' define
[ to key :p [ match? ] array-filter array-reverse :s ] 'strip-character' define
[ [ to str ] dip [ str swap :s strip-character to str ] for-each-character str ] 'strip-characters' define
[ 'key' 'str' 'match?' ] hide-functions

"string:source string:remove -- string:results  strip-character"
"string:source string:remove -- string:results  strip-characters"

