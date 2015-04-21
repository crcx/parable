"data keys str"
"value data keys str"
[ swap array-index-of dup #-1 <> [ fetch ] [ nip 'Index not found' report-error ] if ] 'array-fetch-by-name' define
[ swap array-index-of dup #-1 <> [ store ] [ drop-pair drop 'Index not found' report-error ] if ] 'array-store-by-name' define


[ #10 #20 #30 #40 #50 ] array-from-quote 'd' define
[ 'a' 'b' 'c' 'd' 'e' ] array-from-quote 'k' define

&d &k 'b' array-fetch-by-name
&d &k 'boop' array-fetch-by-name

&d &k 'd' array-fetch-by-name
#3000 &d &k 'd' array-store-by-name
&d &k 'd' array-fetch-by-name
#3000 &d &k 'doom' array-store-by-name
