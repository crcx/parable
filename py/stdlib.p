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
[ "nn-f"   `220 ] 'lt?' define
[ "nn-f"   `221 ] 'gt?' define
[ "nn-f"   `222 ] 'lteq?' define
[ "nn-f"   `223 ] 'gteq?' define
[ "vv-f"   `224 ] 'eq?' define
[ "vv-f"   `225 ] '-eq?' define
[ "fpp-"   `300 ] 'if' define
[ "p-"     `301 ] 'while' define
[ "p-"     `302 ] 'until' define
[ "np-"    `303 ] 'times' define
[ "p-"     `305 ] 'invoke' define
[ "vp-v"   `306 ] 'dip' define
[ "vp-v"   `307 ] 'sip' define
[ "vpp-?"  `308 ] 'bi' define
[ "vppp-?" `309 ] 'tri' define
[ "pp-"    `400 ] 'copy' define
[ "pn-v"   `401 ] 'fetch' define
[ "vpn-"   `402 ] 'store' define
[ "-p"     `403 ] 'request' define
[ "p-"     `404 ] 'release' define
[ "-"      `405 ] 'collect-garbage' define
[ "p-n"    `406 ] 'get-last-index' define
[ "np-"    `407 ] 'set-last-index' define
[ "tpn-"   `408 ] 'set-stored-type' define
[ "pn-n"   `409 ] 'get-stored-type' define
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
[ "p-s"    `604 ] 'lookup-name' define
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
[ "v-c" COMMENT set-type ] ':comment' define


"Stack Flow"
[ "vV-vVvV"  over over ] 'dup-pair' define
[ "vv-"      drop drop ] 'drop-pair' define
[ "?n-"      [ drop ] times ] 'drop-multiple' define
[ "q-...n"   depth [ invoke ] dip depth swap - ] 'invoke<depth?>' define


"Slice Functions"
[ "p-pn"  dup get-last-index ] 'last-index?' define
[ "p-pn"  last-index? 1 + ] 'slice-length?' define
[ "np-"   [ get-last-index + ] sip set-last-index ] 'adjust-slice-length' define
[ "p-p"   request [ copy ] sip ] 'duplicate-slice' define
[ "p-n"   get-last-index 1 + ] 'length?' define


"Simple variables are just named slices, with functions to access the first element. They're useful for holding single values."
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
[ "nn-n"  over over lt? [ nip ] [ drop ] if ] 'max' define
[ "nn-n"  over over gt? [ nip ] [ drop ] if ] 'min' define
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
[ "v-f"  :s 'nan' eq? ] 'nan?' define
[ "v-f"  0 eq? ] 'zero?' define
[ "v-f"  :f :n zero? not ] 'true?' define
[ "v-f"  :f :n zero? ] 'false?' define
[ "n-f"  2 rem zero? ] 'even?' define
[ "n-f"  2 rem zero? not ] 'odd?' define
[ "n-f"  0 lt? ] 'negative?' define
[ "n-f"  0 gteq? ] 'positive?' define
[ "cp-"  [ type? CHARACTER eq? ] dip if-true ] 'if-character' define
[ "sp-"  [ type? STRING eq? ] dip if-true ] 'if-string' define
[ "np-"  [ type? NUMBER eq? ] dip if-true ] 'if-number' define
[ "pp-"  [ type? POINTER eq? ] dip if-true ] 'if-pointer' define
[ "fp-"  [ type? FLAG eq? ] dip if-true ] 'if-flag' define
[ "nnn-f"  [ [ :n ] bi@ ] dip :n dup-pair gt? [ swap ] if-true [ over ] dip lteq? [ gteq? ] dip and :f ] 'between?' define
[ "vv-vvf"  [ type? ] dip type? swap [ eq? ] dip swap ] 'types-match?' define


"numeric ranges"
[ "nn-..."  dup-pair lt? [ [ [ dup 1 + ] dip dup-pair eq? ] until ] [ [ [ dup 1 - ] dip dup-pair eq? ] until ] if drop ] 'expand-range' define
[ "...n-n"  1 - [ + ] times ] 'sum-range' define


"Misc"
[ "p-"   invoke<depth?> [ hide-function ] times ] 'hide-functions' define
[ "ss-"  swap dup function-exists? [ dup lookup-function swap hide-function swap define ] [ drop ] if ] 'rename-function' define
[ "ps-"  dup hide-function define ] 'redefine' define
[ "p-"   invoke<depth?> [ variable ] times ] 'variables' define


"String and Character"
"Note that this is only supporting the basic ASCII character set presently."
[ "vs-f" swap :s find not true? ] 'string-contains?' define
[ "v-f"  :c $0 $9 between? ] 'digit?' define
[ "v-f"  '`~!@#$%^&*()'"<>,.:;[]{}\|-_=+'                    string-contains? ] 'symbol?' define
[ "v-f"  to-lowercase 'abcdefghijklmnopqrstuvwxyz'           string-contains? ] 'letter?' define
[ "v-f"  to-lowercase 'abcdefghijklmnopqrstuvwxyz1234567890' string-contains? ] 'alphanumeric?' define
[ "v-f"  to-lowercase 'bcdfghjklmnpqrstvwxyz'                string-contains? ] 'consonant?' define
[ "v-f"  to-lowercase 'aeiou'                                string-contains? ] 'vowel?' define
[ "v-f"  dup to-lowercase eq? ] 'lowercase?' define
[ "v-f"  dup to-uppercase eq? ] 'uppercase?' define
[ "p-s"  invoke<depth?> 1 - [ [ :s ] bi@ + ] times ] 'build-string' define

"Functions for trimming leading and trailing whitespace off of a string. The left side trim is iterative; the right side trim is recursive."
[ "s-s"  :s #0 [ dup-pair fetch :n 32 eq? [ 1 + ] dip ] while 1 - [ last-index? ] dip swap subslice :s ] 'trim-left' define
[ ] 'trim-right' define
[ "s-s"  :s last-index? dup-pair 1 - fetch :n nip 32 eq? [ last-index? 1 - 0 swap subslice :s trim-right ] if-true ] 'trim-right' define
[ "s-s"  trim-left trim-right ] 'trim' define


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
[ "...n-"  [ buffer-store ] times ] 'buffer-store-items' define
[ "-"      request set-buffer ] 'new-buffer' define
[ "p-"     &*CURRENT-BUFFER @ [ &*BUFFER-OFFSET @ [ invoke ] dip &*BUFFER-OFFSET ! ] dip &*CURRENT-BUFFER ! ] 'preserve-buffer' define
[ "s-"     request [ swap define ] sip set-buffer ] 'named-buffer' define


"Programatic Creation of Quotes"
[ "vv-p"  swap request [ 0 store ] sip [ 1 store ] sip ] 'cons' define
[ "vp-p"  :call cons ] 'curry' define


"Values"
'_STATE' variable
[ "-"    &_STATE on ] 'to' define
[ "?p-"  &_STATE @ :f [ ! &_STATE off ] [ @ ] if ] '(value-handler)' define
[ "s-"   request [ (value-handler) ] curry swap define ] 'value' define
[ "ns-"  [ value ] sip to lookup-function invoke ] 'value!' define
[ "p-"   invoke<depth?> [ value ] times ] 'values' define
'_STATE' hide-function


"Arrays and Operations on Quotations"
[ "q-v"  @ ] 'first' define
[ "q-q"  1 over length? subslice ] 'rest' define
[ "p-v"  slice-length? 1 - fetch ] 'last' define

[ '*Found'  '*Value'  '*XT'  '*Source'  '*Target'  '*Offset' ] values
[ "q-"   &*Found [ &*Value [ &*XT [ &*Source [ &*Target [ &*Offset [ invoke ] preserve ] preserve ] preserve ] preserve ] preserve ] preserve ] 'localize' define

[ "vp-"    :p dup length? store ] 'push' define
[ "p-v"    :p [ dup get-last-index fetch ] sip dup length? 2 - swap set-last-index ] 'pop' define
[ "-p"     request [ pop drop ] sip ] 'request-empty' define
[ "pnp-n"  [ to *XT over length? [ over pop *XT invoke ] times nip ] localize ] 'reduce' define
[ "pp-?"   [ to *XT to *Source 0 to *Offset *Source length? [ *Source *Offset fetch *XT invoke *Offset 1 + to *Offset ] times ] localize ] 'for-each' define
[ "pv-f"   false to *Found to *Value dup length? 0 swap [ dup-pair fetch *Value types-match? [ eq? *Found or :f to *Found ] [ drop-pair ] if 1 + ] times drop-pair *Found ] 'contains?' define
[ "pq-p"   [ to *XT to *Source request-empty to *Target 0 to *Offset *Source length? [ *Source *Offset fetch *XT invoke [ *Source *Offset fetch *Target push ] if-true *Offset 1 + to *Offset ] times *Target ] localize ] 'filter' define
[ "pq-"    [ to *XT duplicate-slice to *Source 0 to *Offset *Source length? [ *Source *Offset fetch *XT invoke *Source *Offset store *Offset 1 + to *Offset ] times *Source ] localize ] 'map' define
[ "p-p"    [ request to *Target invoke<depth?> 0 max [ *Target push ] times *Target 1 over length? subslice :p ] localize ] 'capture-results' define
[ "pv-n"   [ to *Target to *Source 0 to *Offset -1 to *Found *Source length? [ *Source *Offset fetch *Target eq? [ *Offset to *Found ] if-true *Offset 1 + to *Offset ] times *Found ] localize ] 'index-of' define

[ '*Found'  '*Value'  '*XT'  '*Source'  '*Target'  '*Offset'  'localize' ] hide-functions


"Text Output Buffer"
'*TOB' variable
[ "v-"   &*TOB push ] '.' define
[ "-..." &*TOB get-last-index [ &*TOB pop ] times ] 'show-tob' define
[ "-"    0 &*TOB set-last-index ] 'clear-tob' define


"Scope"
'*Internals' value
[ "q-" \
  to *Internals \
  *Internals duplicate-slice \
  [ dup @ $* eq? [ value ] [ variable ] if ] for-each ] '{' define
[ "-"  *Internals hide-functions ] '}' define


"Hashing functions"
[ 'hash:sdbm<n>' ] {
  389 '*Hash-Prime' value!
  [ "s-n" 0 swap [ :n xor ] for-each ] 'hash:xor' define
  [ "s-n" 5381 swap [ over -5 shift + + ] for-each ] 'hash:djb2' define
  [ :n over -6 shift + over -16 shift + swap - ] 'hash:sdbm<n>' define
  [ "s-n" 0 swap [ :c swap hash:sdbm<n> ] for-each ] 'hash:sdbm' define
  [ "s-b" hash:djb2 ] 'chosen-hash' define
  [ "s-n" chosen-hash *Hash-Prime rem ] 'hash' define
}


[ '*Offset'  '*Tests'  '*Done' ] {
  [ "q-" \
    *Offset \
    [ *Done \
      [ *Tests \
        [ to *Tests false to *Done 0 to *Offset \
          [ *Tests *Offset fetch @ invoke \
            [ true to *Done *Tests *Offset fetch 1 fetch invoke ] if-true \
            *Offset 1 + to *Offset *Done \
          ] until \
        ] dip to *Tests \
      ] dip to *Done \
    ] dip to *Offset \
  ] 'when' define
}


[ '*Source'  '*Value'  '*Target'  'extract'  'next-piece' ] {
  [ "n-"  [ *Source 0 ] dip subslice :s ] 'extract' define
  [ "n-"  *Source swap *Value length? + over length? subslice :s to *Source ] 'next-piece' define

  [ "ss-p" \
    :s to *Value \
    to *Source \
    request-empty to *Target \
    [ *Source *Value find dup \
      -1 -eq? [ [ extract *Target push ] sip next-piece true ] \
              [ drop *Source *Target push false ] if \
    ] while \
    *Target \
  ] 'split' define

  [ "pv-s" \
    :s to *Value \
    reverse '' [ :s + *Value + ] reduce \
    "This leaves the join value appended to the string. Remove it." \
    0 over length? *Value length? - subslice rest :s \
  ] 'join' define
}

[ "s-s"  [ :n 32 128 between? ] filter :s ] 'clean-string' define

[ "sss-s"  [ split ] dip join clean-string ] 'replace' define


[ '*Data'  '*Source'  '*String'  '(accumulate)'  '(next)' ] {
  [ "-"  *String *Source first *Data first type? POINTER eq? [ invoke ] if-true :s + + to *String ] '(accumulate)' define
  [ "-"  *Source rest to *Source  *Data rest to *Data ] '(next)' define

  [ "ps-s" \
    '{v}' split to *Source \
    to *Data \
    request-empty :s to *String \
    *Data length? [ (accumulate) (next) ] times \
    "Merge any remaining items" \
    *String *Source ' ' join + clean-string \
  ] 'interpolate' define
}


"apropos"
[ "s-s" \
  dup function-exists? \
  [ lookup-function @ ] \
  [ drop 'function not found' report-error ] if \
] 'apropos' define
