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
[ "p-n"    `406 ] 'get-last-index' define
[ "np-"    `407 ] 'set-last-index' define
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
[ "p-p"    `703 ] 'reverse' define
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

[ #100 ] 'NUMBER' define
[ #200 ] 'STRING' define
[ #300 ] 'CHARACTER' define
[ #400 ] 'POINTER' define
[ #500 ] 'FLAG' define

"simple, forth-style variables"
[ "s-"   request swap define ] 'variable' define
[ "p-v"  #0 fetch ] '@' define
[ "vp-"  #0 store ] '!' define



"returns the number of cells in a slice"
[ "p-n"  get-last-index #1 + ] 'length?' define


"number functions"
[ "n-n"  over over < [ nip ] [ drop ] if ] 'max' define
[ "n-n"  over over > [ nip ] [ drop ] if ] 'min' define
[ "n-n"  dup #-1 * max ] 'abs' define


"utility functions"
[ "q-...n"  depth [ invoke ] dip depth swap - ] 'invoke<depth?>' define


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
[ "-f"   #-1 :f ] 'true' define
[ "-f"   #0  :f ] 'false' define
[ "f-f"  :f :n #-1 xor :f ] 'not' define
[ "fp-"  [ ] if ] 'if-true' define
[ "fp-"  [ ] swap if ] 'if-false' define
[ "v-f"  #0 = ] 'zero?' define
[ "v-f"  :f :n zero? not ] 'true?' define
[ "v-f"  :f :n zero? ] 'false?' define
[ "n-f"  #2 rem zero? ] 'even?' define
[ "n-f"  #2 rem zero? not ] 'odd?' define
[ "n-f"  #0 < ] 'negative?' define
[ "n-f"  #0 >= ] 'positive?' define
[ "cp-"  [ type? CHARACTER = ] dip if-true ] 'if-character' define
[ "sp-"  [ type? STRING = ] dip if-true ] 'if-string' define
[ "np-"  [ type? NUMBER = ] dip if-true ] 'if-number' define
[ "pp-"  [ type? POINTER = ] dip if-true ] 'if-pointer' define
[ "fp-"  [ type? FLAG = ] dip if-true ] 'if-flag' define
[ "nnn-f"  [ [ :n ] bi@ ] dip :n dup-pair > [ swap ] if-true [ over ] dip <= [ >= ] dip and :f ] 'between?' define

"Simple variables are just named slices, with functions to access the first element. They're useful for holding single values, but don't track data types."
[ "vs-"  request [ swap define ] sip #0 store ] 'variable!' define
[ "p-"   #0 swap ! ] 'off' define
[ "p-"   #-1 swap ! ] 'on' define
[ "p-"   [ @ #1 + ] sip ! ] 'increment' define
[ "p-"   [ @ #1 - ] sip ! ] 'decrement' define
[ "p-"   request swap copy ] 'zero-out' define
[ "pp-"  swap request dup-pair copy swap [ [ invoke ] dip ] dip copy ] 'preserve' define


"numeric ranges"
[ "nn-..."  dup-pair < [ [ [ dup #1 + ] dip dup-pair = ] while-false ] [ [ [ dup #1 - ] dip dup-pair = ] while-false ] if drop ] 'expand-range' define
[ "...n-n"   #1 - [ + ] repeat ] 'sum-range' define


"Misc"
[ "p-pn"  dup get-last-index ] 'slice-last-index' define
[ "p-pn"  slice-last-index #1 + ] 'slice-length' define
[ "np-"   [ get-last-index + ] sip set-last-index ] 'adjust-slice-length' define
[ "?n-"   [ drop ] repeat ] 'drop-multiple' define
[ "p-p"   request [ copy ] sip ] 'slice-duplicate' define
[ "p-"   invoke<depth?> [ hide-function ] repeat ] 'hide-functions' define
[ "ss-"  swap dup function-exists? [ dup lookup-function swap hide-function swap define ] [ drop ] if ] 'rename-function' define
[ "p-"   invoke<depth?> [ variable ] repeat ] 'variables' define

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
[ "p-s"  invoke<depth?> #1 - [ [ :s ] bi@ + ] repeat ] 'build-string' define

"Functions for trimming leading and trailing whitespace off of a string. The left side trim is iterative; the right side trim is recursive."
[ "s-s"  :s #0 [ dup-pair fetch #32 = [ #1 + ] dip ] while-true #1 - [ slice-last-index ] dip swap subslice :s ] 'trim-left' define
[ ] 'trim-right' define
[ "s-s"  :s slice-last-index dup-pair #1 - fetch nip #32 = [ slice-last-index #1 - #0 swap subslice :s trim-right ] if-true ] 'trim-right' define
[ "s-s"  trim-left trim-right ] 'trim' define

"Helpful Math"
[ "n-"    #1 swap [ [ * ] sip #1 - dup #1 <> ] while-true drop ] 'factorial' define

"Slice as a linear buffer"
[ '*CURRENT-BUFFER'  '*BUFFER-OFFSET' ] variables
[ "-p"     &*CURRENT-BUFFER @ :p ] 'current-buffer' define
[ "-pn"    current-buffer &*BUFFER-OFFSET @ ] 'buffer-position' define
[ "-"      &*BUFFER-OFFSET increment ] 'buffer-advance' define
[ "-"      &*BUFFER-OFFSET decrement ] 'buffer-retreat' define
[ "n-"     buffer-position store ] 'buffer-store-current' define
[ "-n"     buffer-position fetch ] 'buffer-fetch-current' define
[ "v-"     buffer-position store buffer-advance #0 buffer-position store ] 'buffer-store' define
[ "-n"     buffer-position fetch buffer-advance ] 'buffer-fetch' define
[ "v-"     buffer-retreat buffer-position store ] 'buffer-store-retreat' define
[ "-n"     buffer-retreat buffer-position fetch ] 'buffer-fetch-retreat' define
[ "p-"     &*CURRENT-BUFFER ! &*BUFFER-OFFSET zero-out ] 'set-buffer' define
[ "...n-"  [ buffer-store ] repeat ] 'buffer-store-items' define
[ "-"      request set-buffer ] 'new-buffer' define
[ "p-"     &*CURRENT-BUFFER @ [ &*BUFFER-OFFSET @ [ invoke ] dip &*BUFFER-OFFSET ! ] dip &*CURRENT-BUFFER ! ] 'preserve-buffer' define
[ "s-"     request [ swap define ] sip set-buffer ] 'named-buffer' define


"Curry Combinator"
'*curry:types*' named-buffer
[ ] buffer-store
[ "number"    #100 buffer-store buffer-store ] buffer-store
[ "string"    #101 buffer-store buffer-store ] buffer-store
[ "character" #102 buffer-store buffer-store ] buffer-store
[ "pointer"   #103 buffer-store buffer-store ] buffer-store
[ "flag"      #100 buffer-store buffer-store #114 buffer-store ] buffer-store

[ type? #100 / &*curry:types* swap fetch invoke ] 'curry:compile-value' define
[ #304 buffer-store buffer-store ] 'curry:compile-call' define

[ "vp-p"  [ request set-buffer swap curry:compile-value curry:compile-call &*CURRENT-BUFFER @ :p ] preserve-buffer ] 'curry' define
[ '*curry:types*'  'curry:compile-value'  'curry:compile-call' ] hide-functions

"Values"
'*types*' named-buffer
[ ] buffer-store
[ "number"    :n ] buffer-store
[ "string"    :p :s ] buffer-store
[ "character" :c ] buffer-store
[ "pointer"   :p ] buffer-store
[ "flag"      :f ] buffer-store
[ #100 / &*types* swap fetch invoke ] 'restore-stored-type' define
'*state*' variable
[ "-" &*state* on ] 'to' define
[ [ type? ] dip [ #1 store ] sip ] 'preserve-type' define
[ #1 fetch restore-stored-type ] 'restore-type' define
[ &*state* @ :f [ preserve-type ! &*state* off ] [ dup @ swap restore-type ] if ] 'value-handler' define
[ "s-" request #2 over set-last-index [ value-handler ] curry swap define ] 'value' define
[ "ns-" [ value ] sip to lookup-function invoke ] 'value!' define
[ "p-" invoke<depth?> [ value ] repeat ] 'values' define
[ '*types*'  '*state*'  'restore-stored-type'  'preserve-type'  'restore-type'  'value-handler' ] hide-functions


"arrays"
[ 'source'  'results'  'filter' ] values

[ &source [ &results [ &filter [ invoke ] preserve ] preserve ] preserve ] 'localize' define

[ "vp-"  :p dup length? store ] 'array-push' define
[ "p-v"  :p [ dup get-last-index fetch ] sip dup length? #2 - swap set-last-index ] 'array-pop' define
[ "p-p"    [ request to results invoke<depth?> #0 max [ results array-push ] repeat results #1 over length? subslice :p ] localize ] 'array-from-quote' define
[ "pnp-n"  [ to filter over length? [ over array-pop filter invoke ] repeat nip ] localize ] 'array-reduce' define
[ "pp-?"   [ to filter slice-duplicate dup length? [ [ array-pop filter invoke ] sip ] repeat drop ] localize ] 'for-each' define


[ ] 'array<remap>' define

[ type? STRING <> [ [ ] ] [ [ [ :p :s ] bi@ ] ] if 'array<remap>' define ] 'needs-remap?' define

[ "pv-f"   swap needs-remap? [ swap dup set-buffer slice-last-index #0 swap [ over buffer-fetch array<remap> = or ] repeat ] preserve-buffer nip :f ] 'array-contains?' define

[ 'array<remap>'  'needs-remap?' ] hide-functions

[ [ reverse ] dip request to results to filter [ to source ] [ length? ] bi results array-pop drop ] 'prepare' define

[ "pp-p"   prepare [ source array-pop dup filter invoke [ results array-push ] [ drop ] if ] repeat results request [ copy ] sip ] 'array-filter' define

[ "pp-p"   prepare [ source array-pop filter invoke results array-push ] repeat results request [ copy ] sip ] 'array-map' define

[ "pp-f"   dup-pair [ length? ] bi@ = [ dup length? true swap [ [ dup-pair [ array-pop ] bi@ = ] dip and ] repeat [ drop-pair ] dip :f ] [ drop-pair false ] if ] 'array-compare' define

[ 'prepare'  'localize'  'filter'  'source'  'results' ] hide-functions

[ 'source' 'v' 'i' 'idx' ] values
[ type? STRING = [ [ :p :s ] dip ] [ :n ] if ] 'resolve-types' define
[ "vp-n"  to source to v #0 to i #-1 to idx source length? [ source i fetch v resolve-types = [ i to idx ] if-true i #1 + to i ] repeat idx ] 'array-index-of' define
[ 'source'  'v'  'i'  'idx'  'resolve-types' ] hide-functions

"Text Output Buffer"
'TOB' variable
[ &TOB array-push ] 'append-value' define
[ "-..." &TOB get-last-index [ &TOB array-pop :p :s ] repeat ] 'show-tob' define
[ "-" #0 &TOB set-last-index ] 'clear-tob' define

'TOB:Handlers' named-buffer
[ ] buffer-store
[ "number"     :s    append-value ] buffer-store
[ "string"           append-value ] buffer-store
[ "character"  :s    append-value ] buffer-store
[ "pointer"    :n :s append-value ] buffer-store
[ "flag"       :s    append-value ] buffer-store
[ "v-"  type? #100 / &TOB:Handlers swap fetch invoke ] '.' define
[ 'TOB' 'append-value' 'TOB:Handlers' ] hide-functions


"Hashing functions"
[ "s-n" #5381 swap [ :n [ swap ] dip over #-5 shift + + swap ] for-each ] 'hash:djb2' define
[ :n over #-6 shift + over #-16 shift + swap - ] 'hash:sdbm<n>' define
[ "s-n" #0 swap [ :c [ swap ] dip hash:sdbm<n> swap ] for-each ] 'hash:sdbm' define
'hash-sdbm<n>' hide-function
[ "s-n" #0 swap [ :n [ swap ] dip + #255 and swap ] for-each #255 xor #1 + #255 and ] 'hash:lrc' define
[ "s-n" #0 swap [ :n [ swap ] dip xor swap ] for-each ] 'hash:xor' define
[ "s-b" hash:djb2 ] 'chosen-hash' define
[ #389 ] 'hash-prime' define
[ "s-n" chosen-hash hash-prime rem ] 'hash' define
