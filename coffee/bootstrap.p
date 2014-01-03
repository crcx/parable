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

