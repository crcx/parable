"Parable Standard Library"
"Copyright (c) 2012-2015, Charles Childers"

"At this point, the language consists of [ ] define and the various prefixes. The rest of this will build Parable into a useful language."

"First, map the byte codes to named functions. These are the primitives."
[ "v-n"    `110 ] ':n' define
[ "v-s"    `111 ] ':s' define
[ "v-c"    `112 ] ':c' define
[ "v-p"    `113 ] ':p' define
[ "v-f"    `114 ] ':f' define
[ "v-vn"   `120 ] 'type?' define
[ "nn-n"   `200 ] '+' define
[ "nn-n"   `201 ] '-' define
[ "nn-n"   `202 ] '*' define
[ "nn-n"   `203 ] '/' define
[ "nn-n"   `204 ] 'rem' define
[ "n-n"    `205 ] 'floor' define
[ "nn-n"   `206 ] '^' define
[ "n-n"    `207 ] 'log' define
[ "n-n"    `208 ] 'log10' define
[ "nn-n"   `209 ] 'log<n>' define
[ "nn-n"   `210 ] 'shift' define
[ "nn-n"   `211 ] 'and' define
[ "nn-n"   `212 ] 'or' define
[ "nn-n"   `213 ] 'xor' define
[ "-n"     `214 ] 'random' define
[ "n-n"    `215 ] 'sqrt' define
[ "nn-f"   `220 ] '<' define
[ "nn-f"   `221 ] '>' define
[ "nn-f"   `222 ] '<=' define
[ "nn-f"   `223 ] '>=' define
[ "vv-f"   `224 ] '=' define
[ "vv-f"   `225 ] '<>' define
[ "fpp-"   `300 ] 'if' define
[ "p-"     `301 ] 'while-true' define
[ "p-"     `302 ] 'while-false' define
[ "np-"    `303 ] 'repeat' define
[ "p-"     `305 ] 'invoke' define
[ "vp-v"   `306 ] 'dip' define
[ "vp-v"   `307 ] 'sip' define
[ "vpp-?"  `308 ] 'bi' define
[ "vppp-?" `309 ] 'tri' define
[ "pp-"    `400 ] 'copy' define
[ "pn-n"   `401 ] 'fetch' define
[ "npn-"   `402 ] 'store' define
[ "-p"     `403 ] 'request' define
[ "p-"     `404 ] 'release' define
[ "-"      `405 ] 'collect-garbage' define
[ "p-n"    `406 ] 'get-slice-length' define
[ "np-"    `407 ] 'set-slice-length' define
[ "v-vv"   `500 ] 'dup' define
[ "v-"     `501 ] 'drop' define
[ "vV-Vv"  `502 ] 'swap' define
[ "vV-vVv" `503 ] 'over' define
[ "vV-VvV" `504 ] 'tuck' define
[ "vV-V"   `505 ] 'nip' define
[ "-n"     `506 ] 'depth' define
[ "...-"   `507 ] 'reset' define
[ "s-f"    `601 ] 'function-exists?' define
[ "s-p"    `602 ] 'lookup-function' define
[ "s-"     `603 ] 'hide-function' define
[ "ss-n"   `700 ] 'find' define
[ "pnn-p"  `701 ] 'subslice' define
[ "s-f"    `702 ] 'numeric?' define
[ "v-v"    `800 ] 'to-lowercase' define
[ "v-v"    `801 ] 'to-uppercase' define
[ "s-"     `900 ] 'report-error' define
[ "n-n"    `1000 ] 'sin' define
[ "n-n"    `1001 ] 'cos' define
[ "n-n"    `1002 ] 'tan' define
[ "n-n"    `1003 ] 'asin' define
[ "n-n"    `1004 ] 'acos' define
[ "n-n"    `1005 ] 'atan' define
[ "n-n"    `1006 ] 'atan2' define

"Constants for data types recognized by Parable's VM"
[ #100 ] 'NUMBER' define
[ #200 ] 'STRING' define
[ #300 ] 'CHARACTER' define
[ #400 ] 'POINTER' define
[ #500 ] 'FLAG' define

"The basic bi/tri combinators provided as part of the primitives allow application of multiple quotes to a single data element. Here we add new forms that are very useful."
"We consider the bi/tri variants to consist of one of three types."
"Cleave combinators (bi, tri) apply multiple quotations to a single value (or set of values)."

"Spread combinators (bi*, tri*) apply multiple quotations to multiple values."
[ "vvpp-?"   [ dip ] dip invoke ] 'bi*' define
[ "vvvppp-?" [ [ swap [ dip ] dip ] dip dip ] dip invoke ] 'tri*' define

"Apply combinators (bi@, tri@) apply a single quotation to multiple values."
[ "vvp-?"    dup bi* ] 'bi@' define
[ "vvvp-?"   dup dup tri* ] 'tri@' define

"Stack Flow"
[ "vV-vVvV"  over over ] 'dup-pair' define
[ "vv-"      drop drop ] 'drop-pair' define

"Expand the basic conditionals into a more useful set."
[ #-1 :f ] 'true' define
[ #0 :f ] 'false' define
[ :f :n #-1 xor :f ] 'not' define
[ [ ] if ] 'if-true' define
[ [ ] swap if ] 'if-false' define
[ #0 = ] 'zero?' define
[ :f :n zero? not ] 'true?' define
[ :f :n zero? ] 'false?' define
[ #2 rem zero? ] 'even?' define
[ #2 rem zero? not ] 'odd?' define
[ #0 < ] 'negative?' define
[ #0 >= ] 'positive?' define
[ [ type? CHARACTER = ] dip if-true ] 'if-character' define
[ [ type? STRING = ] dip if-true ] 'if-string' define
[ [ type? NUMBER = ] dip if-true ] 'if-number' define
[ [ type? POINTER = ] dip if-true ] 'if-pointer' define
[ [ type? FLAG = ] dip if-true ] 'if-flag' define
[ [ [ :n ] bi@ ] dip :n dup-pair > [ swap ] if-true [ over ] dip <= [ >= ] dip and :f ] 'between?' define

"Simple variables are just named slices, with functions to access the first element. They're useful for holding single values, but don't track data types."
[ request swap define ] 'variable' define
[ request [ swap define ] sip #0 store ] 'variable!' define
[ #0 fetch ] '@' define
[ #0 store ] '!' define
[ #0 swap ! ] 'off' define
[ #-1 swap ! ] 'on' define
[ [ @ #1 + ] sip ! ] 'increment' define
[ [ @ #1 - ] sip ! ] 'decrement' define
[ request swap copy ] 'zero-out' define
[ swap request dup-pair copy swap [ [ invoke ] dip ] dip copy ] 'preserve' define


"numeric ranges"
[ dup-pair < [ [ [ dup #1 + ] dip dup-pair = ] while-false ] [ [ [ dup #1 - ] dip dup-pair = ] while-false ] if drop ] 'expand-range' define
[ #1 - [ + ] repeat ] 'sum-range' define

"Misc"
[ dup get-slice-length ] 'string-length' define
[ [ get-slice-length + ] sip set-slice-length ] 'adjust-slice-length' define
[ depth [ invoke ] dip depth swap - ] 'invoke-and-count-items-returned' define
[ [ depth [ invoke ] dip depth swap - ] + ] 'invoke-and-count-items-returned-with-adjustment' define
[ [ drop ] repeat ] 'drop-multiple' define

"String and Character"
"Note that this is only supporting the basic ASCII character set presently."
[ "vs-f" swap :s find not true? ] 'string-contains?' define
[ "v-f"  :c $0 $9 between? ] 'digit?' define
[ "v-f"  '`~!@#$%^&*()'"<>,.:;[]{}\|-_=+'                    string-contains? ] 'symbol?' define
[ "v-f"  to-lowercase 'abcdefghijklmnopqrstuvwxyz'           string-contains? ] 'letter?' define
[ "v-f"  to-lowercase 'abcdefghijklmnopqrstuvwxyz1234567890' string-contains? ] 'alphanumeric?' define
[ "v-f"  to-lowercase 'bcdfghjklmnpqrstvwxyz'                string-contains? ] 'consonant?' define
[ "v-f"  to-lowercase 'aeiou'                                string-contains? ] 'vowel?' define
[ "v-f"  dup to-lowercase = ] 'lowercase?' define
[ "v-f"  dup to-uppercase = ] 'uppercase?' define
[ "p-s" invoke-and-count-items-returned #1 - [ [ :s ] bi@ + ] repeat ] 'build-string' define

"Functions for trimming leading and trailing whitespace off of a string. The left side trim is iterative; the right side trim is recursive."
[ "s-s"  :s #0 [ dup-pair fetch #32 = [ #1 + ] dip ] while-true #1 - [ string-length ] dip swap subslice :s ] 'trim-left' define
[ ] 'trim-right' define
[ "s-s"  :s string-length dup-pair #1 - fetch nip #32 = [ string-length #1 - #0 swap subslice :s trim-right ] if-true ] 'trim-right' define
[ "s-s" trim-left trim-right ] 'trim' define

"Helpful Math"
[ dup negative? [ #-1 * ] if-true ] 'abs' define
[ dup-pair < [ drop ] [ nip ] if ] 'min' define
[ dup-pair < [ nip ] [ drop ] if ] 'max' define
[ #1 swap [ [ * ] sip #1 - dup #1 <> ] while-true drop ] 'factorial' define

"Sliced Memory Access"
'*slice:current*' variable
'*slice:offset*' variable
[ &*slice:current* @ :p ] 'current-slice' define
[ &*slice:current* @ &*slice:offset* @ ] 'slice-position' define
[ &*slice:offset* increment ] 'slice-advance' define
[ &*slice:offset* decrement ] 'slice-retreat' define
[ slice-position store ] 'slice-store-current' define
[ slice-position fetch ] 'slice-fetch-current' define
[ slice-position store slice-advance #0 slice-position store ] 'slice-store' define
[ slice-position fetch slice-advance ] 'slice-fetch' define
[ slice-retreat slice-position store ] 'slice-store-retreat' define
[ slice-retreat slice-position fetch ] 'slice-fetch-retreat' define
[ &*slice:current* ! &*slice:offset* zero-out ] 'slice-set' define
[ [ slice-store ] repeat ] 'slice-store-items' define
[ request slice-set ] 'new-slice' define
[ &*slice:current* @ [ &*slice:offset* @ [ invoke ] dip &*slice:offset* ! ] dip &*slice:current* ! ] 'preserve-slice' define

"more strings"
[ [ [ new-slice string-length [ #1 - ] sip [ dup-pair fetch slice-store #1 - ] repeat drop-pair #0 slice-store &*slice:current* @ :p :s ] preserve-slice ] if-string ] 'reverse' define
[ swap reverse string-length [ dup-pair #1 - fetch swap [ swap ] dip [ [ :c over invoke ] dip ] dip #1 - dup #0 > ] while-true drop-pair drop ] 'for-each-character' define

[ invoke-and-count-items-returned [ hide-function ] repeat ] 'hide-functions' define

"arrays"
'source' variable
'filter' variable
'results' variable

[ dup get-slice-length over [ store ] dip #1 swap adjust-slice-length ] 'array-push' define
[ [ #-1 swap adjust-slice-length ] sip dup get-slice-length fetch ] 'array-pop' define
[ get-slice-length ] 'array-length' define
[ &filter ! over array-length [ over array-pop &filter @ invoke ] repeat nip ] 'array-reduce' define
[ [ new-slice invoke-and-count-items-returned slice-store-items &*slice:current* @ ] preserve-slice :p ] 'array-from-quote<in-stack-order>' define
[ request [ copy ] sip &source ! [ #0 &source @ array-length [ &source @ over fetch swap #1 + ] repeat drop ] array-from-quote<in-stack-order> ] 'array-reverse' define
[ array-from-quote<in-stack-order> array-reverse ] 'array-from-quote' define

[ ] 'array<remap>' define
[ type? STRING <> [ [ ] ] [ [ [ :p :s ] bi@ ] ] if 'array<remap>' define ] 'needs-remap?' define
[ swap needs-remap? [ swap dup slice-set array-length #0 swap [ over slice-fetch array<remap> = or ] repeat ] preserve-slice nip :f ] 'array-contains?' define
[ 'array<remap>'  'needs-remap?' ] hide-functions

[ &results zero-out &filter ! [ &source ! ] [ array-length ] bi ] 'prepare' define
[ prepare [ &source @ array-pop dup &filter @ invoke [ &results array-push ] [ drop ] if ] repeat &results request [ copy ] sip ] 'array-filter' define
[ prepare [ &source @ array-pop &filter @ invoke &results array-push ] repeat &results request [ copy ] sip ] 'array-map' define
[ dup-pair [ array-length ] bi@ = [ dup array-length true swap [ [ dup-pair [ array-pop ] bi@ = ] dip and ] repeat [ drop-pair ] dip :f ] [ drop-pair false ] if ] 'array-compare' define
[ &filter ! over array-length [ over array-pop &filter @ invoke ] repeat nip ] 'array-reduce' define
'prepare' hide-function

[ 'filter'  'source'  'results' ] hide-functions

"routines for rendering an array into a string"
'*array:conversions*' variable
&*array:conversions* slice-set
[ "array  --  string"  '' [ :s '#' swap + + #32 :c :s + ] array-reduce ] slice-store
[ "array  --  string"  '' [ :p :s  $' :s swap + $' :s + + #32 :c :s + ] array-reduce ] slice-store
[ "array  --  string"  '' [ :c :s '$' swap + + #32 :c :s + ] array-reduce ] slice-store
[ "pointer:array number:type - string"  #100 / #1 - &*array:conversions* swap fetch :p invoke ] 'array-to-string' define

"Conversion of strings to numbers"
'*conversion:base*' variable
[ :n #48 - &*conversion:base* @ #16 = [ dup #16 > [ #7 - ] if-true ] if-true ] 'conversion:to-digit' define
[ [ swap &*conversion:base* @ * + ] dip ] 'conversion:accumulate' define
[ &*conversion:base* ! #0 swap [ conversion:to-digit swap conversion:accumulate ] for-each-character ] 'convert-with-base' define
[ #2 convert-with-base ] 'convert-from-binary' define
[ #8 convert-with-base ] 'convert-from-octal' define
[ #10 convert-with-base ] 'convert-from-decimal' define
[ #16 convert-with-base ] 'convert-from-hexadecimal' define


"Curry Combinator"
'*curry:types*' variable
&*curry:types* slice-set
[ ] slice-store
[ "number"    #100 slice-store slice-store ] slice-store
[ "string"    #101 slice-store slice-store ] slice-store
[ "character" #102 slice-store slice-store ] slice-store
[ "pointer"   #103 slice-store slice-store ] slice-store
[ "flag"      #100 slice-store slice-store #114 slice-store ] slice-store

[ type? #100 / &*curry:types* swap fetch invoke ] 'curry:compile-value' define
[ #304 slice-store slice-store ] 'curry:compile-call' define

[ [ request slice-set swap curry:compile-value curry:compile-call &*slice:current* @ :p ] preserve-slice ] 'curry' define
[ '*curry:types*'  'curry:compile-value'  'curry:compile-call' ] hide-functions

"Values"
'*types*' variable
&*types* slice-set
[ ] slice-store
[ "number"    :n ] slice-store
[ "string"    :p :s ] slice-store
[ "character" :c ] slice-store
[ "pointer"   :p ] slice-store
[ "flag"      :f ] slice-store
[ #100 / &*types* swap fetch invoke ] 'restore-stored-type' define
'*state*' variable
[ &*state* on ] 'to' define
[ [ type? ] dip [ #1 store ] sip ] 'preserve-type' define
[ #1 fetch restore-stored-type ] 'restore-type' define
[ &*state* @ :f [ preserve-type ! &*state* off ] [ dup @ swap restore-type ] if ] 'value-handler' define
[ request #2 over set-slice-length [ value-handler ] curry swap define ] 'value' define
[ [ value ] sip to lookup-function invoke ] 'value!' define
[ array-from-quote #0 [ :p :s value ] array-reduce drop ] 'values' define
[ '*types*'  '*state*'  'restore-stored-type'  'preserve-type'  'restore-type'  'value-handler' ] hide-functions



"Hashing functions"
[ #5381 swap [ :n [ swap ] dip over #-5 shift + + swap ] for-each-character ] 'hash:djb2' define
[ :n over #-6 shift + over #-16 shift + swap - ] 'hash:sdbm<n>' define
[ #0 swap [ [ swap ] dip hash:sdbm<n> swap ] for-each-character ] 'hash:sdbm' define
[ #0 swap [ :n [ swap ] dip + #255 and swap ] for-each-character #255 xor #1 + #255 and ] 'hash:lrc' define
[ #0 swap [ :n [ swap ] dip xor swap ] for-each-character ] 'hash:xor' define
[ hash:djb2 ] 'chosen-hash' define
[ #389 ] 'hash-prime' define
[ chosen-hash hash-prime rem ] 'hash' define


"Dictionary"
[ swap dup function-exists? [ dup lookup-function swap hide-function swap define ] [ drop ] if ] 'rename-function' define


"More Arrays"
'reconstruct' variable
&reconstruct slice-set
[ ] slice-store
[ "number"    #100 slice-store slice-store ] slice-store
[ "string"    #101 slice-store slice-store ] slice-store
[ "character" #102 slice-store slice-store ] slice-store
[ "pointer"   #103 slice-store slice-store ] slice-store
[ "flag"      #100 slice-store slice-store #114 slice-store ] slice-store
[ #100 / &reconstruct swap fetch invoke ] 'compile-value' define

[ 'data' 'types' ] values
[ to types to data ] 'prepare' define
[ #399 slice-store &*slice:current* @ :p ] 'terminate' define
[ types over fetch [ data over fetch ] dip compile-value ] 'process' define
[ prepare new-slice #0 data array-length [ process #1 + ] repeat drop terminate ] 'array-to-quote' define
[ 'reconstruct' 'compile-value' 'data' 'types' 'prepare' 'extract' 'terminate' ] hide-functions

[ 'source' 'v' 'i' 'idx' ] values
[ type? STRING = [ [ :p :s ] dip ] [ :n ] if ] 'resolve-types' define
[ to source to v #0 to i #-1 to idx source array-length [ source i fetch v resolve-types = [ i to idx ] if-true i #1 + to i ] repeat idx ] 'array-index-of' define
[ 'source'  'v'  'i'  'idx'  'resolve-types' ] hide-functions


"Text Output Buffer"
'TOB' variable
[ &TOB array-push ] 'append-value' define
[ &TOB array-length [ &TOB array-pop :p :s ] repeat ] 'show-tob' define
[ #0 &TOB set-slice-length ] 'clear-tob' define

'TOB:Handlers' variable
&TOB:Handlers slice-set
[ ] slice-store
[ "number"     :s    append-value ] slice-store
[ "string"           append-value ] slice-store
[ "character"  :s    append-value ] slice-store
[ "pointer"    :n :s append-value ] slice-store
[ "flag"       :s    append-value ] slice-store
[ type? #100 / &TOB:Handlers swap fetch invoke ] '.' define
[ 'TOB' 'append-value' 'TOB:Handlers' ] hide-functions


"Constants"
[ #3.141592653 ] 'math:pi' define
[ #6.283185307 ] 'math:tau' define
[ #2.718281828 ] 'math:e' define
[ #1.618033988 ] 'math:golden-ratio' define
[ #0.577215664 ] 'math:euler-mascheroni' define
[ #1.414213562 ] 'math:pythagora' define
[ #0.618033988 ] 'math:inverse-golden-ratio' define
[ #2.414213562 ] 'math:silver-ratio/mean' define
[ #60 ] 'time:seconds/minute' define
[ #60 ] 'time:minutes/hour' define
[ #24 ] 'time:hours/day' define
[ #7 ] 'time:days/week' define
[ #52 ] 'time:weeks/year' define
[ #12 ] 'time:months/year' define
[ #365 ] 'time:days/year' define
[ #365.25 ] 'time:days/julian-year' define
[ #365.2425 ] 'time:days/gregorian-year' define
