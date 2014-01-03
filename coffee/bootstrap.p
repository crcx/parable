"Primitives"
[ `110 ] ':n' define
[ `111 ] ':s' define
[ `112 ] ':c' define
[ `113 ] ':p' define
[ `114 ] ':f' define
[ `120 ] 'type?' define
[ `200 ] '+' define
[ `201 ] '-' define
[ `202 ] '*' define
[ `203 ] '/' define
[ `204 ] 'rem' define
[ `205 ] 'floor' define
[ `210 ] 'shift' define
[ `211 ] 'and' define
[ `212 ] 'or' define
[ `213 ] 'xor' define
[ `220 ] '<' define
[ `221 ] '>' define
[ `222 ] '<=' define
[ `223 ] '>=' define
[ `224 ] '=' define
[ `225 ] '<>' define
[ `300 ] 'if' define
[ `301 ] 'while-true' define
[ `302 ] 'while-false' define
[ `303 ] 'repeat' define
[ `305 ] 'invoke' define
[ `306 ] 'dip' define
[ `307 ] 'sip' define
[ `308 ] 'bi' define
[ `309 ] 'tri' define
[ `400 ] 'copy' define
[ `401 ] 'fetch' define
[ `402 ] 'store' define
[ `403 ] 'request' define
[ `404 ] 'release' define
[ `405 ] 'collect-garbage' define
[ `500 ] 'dup' define
[ `501 ] 'drop' define
[ `502 ] 'swap' define
[ `503 ] 'over' define
[ `504 ] 'tuck' define
[ `505 ] 'nip' define
[ `506 ] 'depth' define
[ `507 ] 'reset' define
[ `700 ] 'find' define
[ `701 ] 'substring' define
[ `702 ] 'numeric?' define
[ `800 ] 'to-lowercase' define
[ `801 ] 'to-uppercase' define
[ `802 ] 'length' define
[ `900 ] 'report-error' define

"Constants for data types recognized by Parable's VM"
[ #100 ] 'NUMBER' define
[ #200 ] 'STRING' define
[ #300 ] 'CHARACTER' define
[ #400 ] 'POINTER' define
[ #500 ] 'FLAG' define

"Stack Flow"
[ over over ] 'dup-pair' define
[ drop drop ] 'drop-pair' define

"Conditionals"
[ #-1 :f ] 'true' define
[ #0 :f ] 'false' define
[ [ ] if ] 'if-true' define
[ [ ] swap if ] 'if-false' define
[ dup-pair > [ swap ] if-true [ over ] dip <= [ >= ] dip and :f ] 'between?' define
[ #0 <> ] 'true?' define
[ #0 = ] 'false?' define
[ #2 rem #0 = ] 'even?' define
[ #2 rem #0 <> ] 'odd?' define
[ #0 < ] 'negative?' define
[ #0 >= ] 'positive?' define
[ #0 = ] 'zero?' define
[ [ type? CHARACTER = ] dip if-true ] 'if-character' define
[ [ type? STRING = ] dip if-true ] 'if-string' define
[ [ type? NUMBER = ] dip if-true ] 'if-number' define
[ [ type? POINTER = ] dip if-true ] 'if-pointer' define
[ [ type? FLAG = ] dip if-true ] 'if-flag' define

"combinators"
[ [ dip ] dip invoke ] 'bi*' define
[ dup bi* ] 'bi@' define
[ [ [ swap [ dip ] dip ] dip dip ] dip invoke ] 'tri*' define
[ [ [ swap &dip dip ] dip dip ] dip invoke ] 'tri*' define
[ dup dup tri* ] 'tri@' define

"variables"
[ #0 fetch ] '@' define
[ #0 store ] '!' define
[ [ @ #1 + ] sip ! ] 'increment' define
[ [ @ #1 - ] sip ! ] 'decrement' define
[ request swap define ] 'variable' define
[ swap request dup-pair copy swap [ [ invoke ] dip ] dip copy ] 'preserve' define

"numeric ranges"
[ dup-pair < [ [ [ dup #1 + ] dip dup-pair = ] while-false ] [ [ [ dup #1 - ] dip dup-pair = ] while-false ] if drop ] 'expand-range' define
[ #1 - [ + ] repeat ] 'sum-range' define

"Misc"
[ depth [ invoke ] dip depth swap - ] 'invoke-count-items' define
[ [ drop ] repeat ] 'drop-multiple' define

"String and Character"
[ dup to-lowercase = ] 'lowercase?' define
[ dup to-uppercase = ] 'uppercase?' define
[ [ [ uppercase? ] [ lowercase? ] bi or :f ] if-character ] 'letter?' define
[ [ $0 $9 between? ] if-character ] 'digit?' define
[ :s '`~!@#$%^&*()'"<>,.:;[]{}\|-_=+' swap find [ false ] [ true ] if ] 'symbol?' define
[ to-lowercase :s 'abcdefghijklmnopqrstuvwxyz1234567890' swap find [ false ] [ true ] if ] 'alphanumeric?' define
[ to-lowercase :s 'bcdfghjklmnpqrstvwxyz' swap find [ false ] [ true ] if ] 'consonant?' define
[ to-lowercase :s 'aeiou' swap find [ false ] [ true ] if ] 'vowel?' define
[ :s #0 [ dup-pair fetch #32 = [ #1 + ] dip ] while-true #1 - [ length ] dip swap substring ] 'trim-left' define
[ ] 'trim-right' define
[ :s length dup-pair #1 - fetch nip #32 = [ length #1 - #0 swap substring trim-right ] if-true ] 'trim-right' define
[ trim-left trim-right ] 'trim' define
[ invoke-count-items #1 - [ [ :s ] bi@ + ] repeat ] 'build-string' define

"Helpful Math"
[ dup negative? [ #-1 * ] if-true ] 'abs' define
[ dup-pair < [ drop ] [ nip ] if ] 'min' define
[ dup-pair < [ nip ] [ drop ] if ] 'max' define

"Sliced Memory Access"
'*slice-current*' variable
'*slice-offset*' variable
[ &*slice-current* @ &*slice-offset* @ ] 'slice-position' define
[ &*slice-offset* increment ] 'slice-advance' define
[ &*slice-offset* decrement ] 'slice-retreat' define
[ slice-position store ] 'slice-store-current' define
[ slice-position fetch ] 'slice-fetch-current' define
[ slice-position store slice-advance ] 'slice-store' define
[ slice-position fetch slice-advance ] 'slice-fetch' define
[ slice-retreat slice-position store ] 'slice-store-retreat' define
[ slice-retreat slice-position fetch ] 'slice-fetch-retreat' define
[ &*slice-current* ! #0 &*slice-offset* ! ] 'slice-set' define
[ [ slice-store ] repeat ] 'slice-store-items' define
[ request slice-set ] 'new-slice' define
[ &*slice-current* @ [ &*slice-offset* @ [ invoke ] dip &*slice-offset* ! ] dip &*slice-current* ! ] 'preserve-slice' define

"arrays"
'*array:filter*' variable
'*array:source*' variable
'*array:results*' variable
[ [ new-slice invoke-count-items dup slice-store slice-store-items &*slice-current* @ ] preserve-slice ] 'array-from-quote' define
[ @ ] 'array-length' define
[ #1 + fetch ] 'array-fetch' define
[ #1 + store ] 'array-store' define
[ swap [ swap slice-set #0 slice-fetch [ over slice-fetch = or ] repeat ] preserve-slice nip :f ] 'array-contains?' define
[ swap [ swap slice-set #0 slice-fetch [ over slice-fetch [ :p :s ] bi@ = or ] repeat ] preserve-slice nip :f ] 'array-contains-string?' define
[ [ dup array-length #1 + store ] sip [ @ #1 + ] sip ! ] 'array-push' define
[ [ dup array-length fetch ] sip [ @ #1 - ] sip ! ] 'array-pop' define
[ #0 &*array:results* ! &*array:filter* ! [ &*array:source* ! ] [ array-length ] bi [ &*array:source* @ array-pop dup &*array:filter* @ invoke [ &*array:results* array-push ] [ drop ] if ] repeat &*array:results* request [ copy ] sip ] 'array-filter' define
[ #0 &*array:results* ! &*array:filter* ! [ &*array:source* ! ] [ array-length ] bi [ &*array:source* @ array-pop &*array:filter* @ invoke &*array:results* array-push ] repeat &*array:results* request [ copy ] sip ] 'array-map' define
[ dup-pair [ array-length ] bi@ = [ dup array-length true swap [ [ dup-pair [ array-pop ] bi@ = ] dip and ] repeat [ drop-pair ] dip :f ] [ drop-pair false ] if ] 'array-compare' define
[ &*array:filter* ! over array-length [ over array-pop &*array:filter* @ invoke ] repeat nip ] 'array-reduce' define
[ request [ copy ] sip &*array:source* ! [ #0 &*array:source* @ array-length [ &*array:source* @ over array-fetch swap #1 + ] repeat drop ] array-from-quote ] 'array-reverse' define

"routines for rendering an array into a string"
'*array:conversions*' variable
&*array:conversions* slice-set
[ "array  --  string"  '' [ :s '#' swap + + #32 :c :s + ] array-reduce ] slice-store
[ "array  --  string"  '' [ :p :s  $' :s swap + $' :s + + #32 :c :s + ] array-reduce ] slice-store
[ "array  --  string"  '' [ :c :s '$' swap + + #32 :c :s + ] array-reduce ] slice-store
[ "pointer:array number:type - string"  #100 / #1 - &*array:conversions* swap fetch :p invoke ] 'array-to-string' define

"more stuff"
[ [ [ new-slice length [ #1 - ] sip [ dup-pair fetch slice-store #1 - ] repeat drop-pair #0 slice-store &*slice-current* @ :p :s ] preserve-slice ] if-string ] 'reverse' define
