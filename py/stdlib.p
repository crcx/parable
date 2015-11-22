"Name the byte codes"
[ "v-b"    `100 ] ':b' define
[ "v-n"    `101 ] ':n' define
[ "v-s"    `102 ] ':s' define
[ "v-c"    `103 ] ':c' define
[ "v-p"    `104 ] ':p' define
[ "v-f"    `105 ] ':f' define
[ "v-f"    `106 ] ':call' define
[ "vt-v"   `109 ] 'set-type' define
[ "v-vn"   `110 ] 'type?' define
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
[ "pnt-"   `408 ] 'set-stored-type' define
[ "p-n"    `409 ] 'get-stored-type' define
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


"Symbolic names for data types"
[ "-n"  100 ] 'NUMBER' define
[ "-n"  200 ] 'STRING' define
[ "-n"  300 ] 'CHARACTER' define
[ "-n"  400 ] 'POINTER' define
[ "-n"  500 ] 'FLAG' define
[ "-n"  600 ] 'BYTECODE' define
[ "-n"  700 ] 'COMMENT' define
[ "-n"  800 ] 'FUNCTION-CALL' define


"Stack Flow"
[ "vV-vVvV"  over over ] 'dup-pair' define
[ "vv-"      drop drop ] 'drop-pair' define
[ "?n-"      [ drop ] repeat ] 'drop-multiple' define
[ "q-...n"   depth [ invoke ] dip depth swap - ] 'invoke<depth?>' define


"Slice Functions"
[ "p-pn"  dup get-last-index ] 'slice-last-index' define
[ "p-pn"  slice-last-index 1 + ] 'slice-length' define
[ "np-"   [ get-last-index + ] sip set-last-index ] 'adjust-slice-length' define
[ "p-p"   request [ copy ] sip ] 'duplicate-slice' define
[ "p-n"   get-last-index 1 + ] 'length?' define


"Simple variables are just named slices, with functions to access the first element. They're useful for holding single values, but don't track data types."
[ "s-"   request swap define ] 'variable' define
[ "p-v"  0 fetch ] '@' define
[ "vp-"  0 store ] '!' define
[ "vs-"  request [ swap define ] sip 0 store ] 'variable!' define
[ "p-"   0 swap ! ] 'off' define
[ "p-"   -1 swap ! ] 'on' define
[ "p-"   [ @ 1 + ] sip ! ] 'increment' define
[ "p-"   [ @ 1 - ] sip ! ] 'decrement' define
[ "p-"   request swap copy ] 'zero-out' define
[ "pp-"  swap request dup-pair copy swap [ [ invoke ] dip ] dip copy ] 'preserve' define


"Number functions"
[ "n-n"  over over < [ nip ] [ drop ] if ] 'max' define
[ "n-n"  over over > [ nip ] [ drop ] if ] 'min' define
[ "n-n"  dup -1 * max ] 'abs' define


"The basic bi/tri combinators provided as part of the primitives allow application of multiple quotes to a single data element. Here we add new forms that are very useful."
"We consider the bi/tri variants to consist of one of three types."
"Cleave combinators (bi, tri) apply multiple quotations to a single value (or set of values)."


"Spread combinators (bi*, tri*) apply multiple quotations to multiple values."
[ "vvpp-?"   [ dip ] dip invoke ] 'bi*' define
[ "vvvppp-?" [ [ swap [ dip ] dip ] dip dip ] dip invoke ] 'tri*' define


"Apply combinators (bi@, tri@) apply a single quotation to multiple values."
[ "vvp-?"    dup bi* ] 'bi@' define
[ "vvvp-?"   dup dup tri* ] 'tri@' define


"Expand the basic conditionals into a more useful set."
[ "-f"   -1 :f ] 'true' define
[ "-f"   0  :f ] 'false' define
[ "f-f"  :f :n -1 xor :f ] 'not' define
[ "fp-"  [ ] if ] 'if-true' define
[ "fp-"  [ ] swap if ] 'if-false' define
[ "v-f"  0 = ] 'zero?' define
[ "v-f"  :f :n zero? not ] 'true?' define
[ "v-f"  :f :n zero? ] 'false?' define
[ "n-f"  2 rem zero? ] 'even?' define
[ "n-f"  2 rem zero? not ] 'odd?' define
[ "n-f"  0 < ] 'negative?' define
[ "n-f"  0 >= ] 'positive?' define
[ "cp-"  [ type? CHARACTER = ] dip if-true ] 'if-character' define
[ "sp-"  [ type? STRING = ] dip if-true ] 'if-string' define
[ "np-"  [ type? NUMBER = ] dip if-true ] 'if-number' define
[ "pp-"  [ type? POINTER = ] dip if-true ] 'if-pointer' define
[ "fp-"  [ type? FLAG = ] dip if-true ] 'if-flag' define
[ "nnn-f"  [ [ :n ] bi@ ] dip :n dup-pair > [ swap ] if-true [ over ] dip <= [ >= ] dip and :f ] 'between?' define
[ "vv-vvf"  [ type? ] dip type? swap [ = ] dip swap ] 'types-match?' define


"numeric ranges"
[ "nn-..."  dup-pair < [ [ [ dup 1 + ] dip dup-pair = ] while-false ] [ [ [ dup 1 - ] dip dup-pair = ] while-false ] if drop ] 'expand-range' define
[ "...n-n"  1 - [ + ] repeat ] 'sum-range' define


"Misc"
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
[ "p-s"  invoke<depth?> 1 - [ [ :s ] bi@ + ] repeat ] 'build-string' define

"Functions for trimming leading and trailing whitespace off of a string. The left side trim is iterative; the right side trim is recursive."
[ "s-s"  :s #0 [ dup-pair fetch 32 = [ 1 + ] dip ] while-true 1 - [ slice-last-index ] dip swap subslice :s ] 'trim-left' define
[ ] 'trim-right' define
[ "s-s"  :s slice-last-index dup-pair 1 - fetch nip 32 = [ slice-last-index 1 - 0 swap subslice :s trim-right ] if-true ] 'trim-right' define
[ "s-s"  trim-left trim-right ] 'trim' define


"Helpful Math"
[ "n-"    1 swap [ [ * ] sip 1 - dup 1 <> ] while-true drop ] 'factorial' define


"Slice as a linear buffer"
[ '*CURRENT-BUFFER'  '*BUFFER-OFFSET' ] variables
[ "-p"     &*CURRENT-BUFFER @ ] 'current-buffer' define
[ "-pn"    current-buffer &*BUFFER-OFFSET @ ] 'buffer-position' define
[ "-"      &*BUFFER-OFFSET increment ] 'buffer-advance' define
[ "-"      &*BUFFER-OFFSET decrement ] 'buffer-retreat' define
[ "n-"     buffer-position store ] 'buffer-store-current' define
[ "-n"     buffer-position fetch ] 'buffer-fetch-current' define
[ "v-"     buffer-position store buffer-advance ] 'buffer-store' define
[ "-n"     buffer-position fetch buffer-advance ] 'buffer-fetch' define
[ "v-"     buffer-retreat buffer-position store ] 'buffer-store-retreat' define
[ "-n"     buffer-retreat buffer-position fetch ] 'buffer-fetch-retreat' define
[ "p-"     &*CURRENT-BUFFER ! &*BUFFER-OFFSET zero-out ] 'set-buffer' define
[ "...n-"  [ buffer-store ] repeat ] 'buffer-store-items' define
[ "-"      request set-buffer ] 'new-buffer' define
[ "p-"     &*CURRENT-BUFFER @ [ &*BUFFER-OFFSET @ [ invoke ] dip &*BUFFER-OFFSET ! ] dip &*CURRENT-BUFFER ! ] 'preserve-buffer' define
[ "s-"     request [ swap define ] sip set-buffer ] 'named-buffer' define


"Programatic Creation of Quotes"
[ "vv-p"  swap request [ 0 store ] sip [ 1 store ] sip ] 'cons' define
[ "vp-p"  :call cons ] 'curry' define


"Values"
'*state*' variable
[ "-" &*state* on ] 'to' define
[ &*state* @ :f [ ! &*state* off ] [ @ ] if ] 'value-handler' define
[ "s-" request [ value-handler ] curry swap define ] 'value' define
[ "ns-" [ value ] sip to lookup-function invoke ] 'value!' define
[ "p-" invoke<depth?> [ value ] repeat ] 'values' define
[ '*state*'  'value-handler' ] hide-functions


"Arrays and Operations on Quotations"
[ "q-v"  @ ] 'first' define
[ "q-q"  1 over length? subslice ] 'rest' define

[ '*FOUND'  '*VALUE'  '*XT'  '*SOURCE'  '*TARGET'  '*OFFSET' ] values
[ "q-"   &*FOUND [ &*VALUE [ &*XT [ &*SOURCE [ &*TARGET [ &*OFFSET [ invoke ] preserve ] preserve ] preserve ] preserve ] preserve ] preserve ] 'localize' define

[ "vp-"    :p dup length? store ] 'array-push' define
[ "p-v"    :p [ dup get-last-index fetch ] sip dup length? 2 - swap set-last-index ] 'array-pop' define
[ "pnp-n"  [ to *XT over length? [ over array-pop *XT invoke ] repeat nip ] localize ] 'reduce' define
[ "pp-?"   [ to *XT to *SOURCE 0 to *OFFSET *SOURCE length? [ *SOURCE *OFFSET fetch *XT invoke *OFFSET 1 + to *OFFSET ] repeat ] localize ] 'for-each' define
[ "pv-f"   false to *FOUND to *VALUE dup length? 0 swap [ dup-pair fetch *VALUE types-match? [ = *FOUND or :f to *FOUND ] [ drop-pair ] if 1 + ] repeat drop-pair *FOUND ] 'contains?' define
[ "pq-p"   [ to *XT to *SOURCE request to *TARGET *TARGET array-pop drop 0 to *OFFSET *SOURCE length? [ *SOURCE *OFFSET fetch *XT invoke [ *SOURCE *OFFSET fetch *TARGET array-push ] if-true *OFFSET 1 + to *OFFSET ] repeat *TARGET ] localize ] 'filter' define
[ "pq-"    [ to *XT duplicate-slice to *SOURCE 0 to *OFFSET *SOURCE length? [ *SOURCE *OFFSET fetch *XT invoke *SOURCE *OFFSET store *OFFSET 1 + to *OFFSET ] repeat *SOURCE ] localize ] 'map' define
[ "p-p"    [ request to *TARGET invoke<depth?> 0 max [ *TARGET array-push ] repeat *TARGET 1 over length? subslice :p ] localize ] 'capture-results' define
[ "pv-n"   [ to *TARGET to *SOURCE 0 to *OFFSET -1 to *FOUND *SOURCE length? [ *SOURCE *OFFSET fetch *TARGET = [ *OFFSET to *FOUND ] if-true *OFFSET 1 + to *OFFSET ] repeat *FOUND ] localize ] 'index-of' define

[ '*FOUND'  '*VALUE'  '*XT'  '*SOURCE'  '*TARGET'  '*OFFSET'  'localize' ] hide-functions


"Text Output Buffer"
'*TOB' variable
[ "v-"   &*TOB array-push ] '.' define
[ "-..." &*TOB get-last-index [ &*TOB array-pop ] repeat ] 'show-tob' define
[ "-"    0 &*TOB set-last-index ] 'clear-tob' define


"Hashing functions"
389 'hash-prime' value!

[ "s-n" 0 swap [ :n xor ] for-each ] 'hash:xor' define
[ "s-n" 5381 swap [ over -5 shift + + ] for-each ] 'hash:djb2' define
[ :n over -6 shift + over -16 shift + swap - ] 'hash:sdbm<n>' define
[ "s-n" 0 swap [ :c swap hash:sdbm<n> ] for-each ] 'hash:sdbm' define
'hash-sdbm<n>' hide-function
[ "s-b" hash:djb2 ] 'chosen-hash' define
[ "s-n" chosen-hash hash-prime rem ] 'hash' define


"when: a conditional combinator"
"[ [ condition ] [ code to execute if true ] \"
"  [ condition ] [ code to execute if true ] \"
"  [ condition ] [ code to execute if true ] ] when"

[ '*CASES'  '*OFFSET' ] values
[ "-"    *OFFSET 1 + to *OFFSET ] 'next' define
[ "-v"   *CASES *OFFSET fetch next ] 'fetch-value' define
[ "q-"   0 to *OFFSET to *CASES *CASES length? 2 / floor [ fetch-value invoke fetch-value if-true ] repeat ] '<when>' define
[ "q-"   *CASES [ *OFFSET [ <when> ] dip to *OFFSET ] dip to *CASES ] 'when' define
[ '*CASES'  '*OFFSET'  'next'  'fetch-value'  '<when>' ] hide-functions
