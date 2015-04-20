'data' value
'keys' value
'key'  value
[ to key to keys to data key keys array-index-of dup #-1 <> [ data swap fetch  ] [ 'Index not found: ' key + report-error ] if ] 'array-fetch-by-name' define
[ to key to keys to data key keys array-index-of dup #-1 <> [ data swap store ] [ drop-pair 'Index not found: ' key + report-error ] if ] 'array-store-by-name' define
[ 'data' 'keys' 'key' ] hide-functions


[ #10 #20 #30 #40 #50 ] array-from-quote 'd' define
[ 'a' 'b' 'c' 'd' 'e' ] array-from-quote 'k' define

&d &k 'b' array-fetch-by-name
&d &k 'boop' array-fetch-by-name

&d &k 'd' array-fetch-by-name
#3000 &d &k 'd' array-store-by-name
&d &k 'd' array-fetch-by-name
#3000 &d &k 'doom' array-store-by-name
