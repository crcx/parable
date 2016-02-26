"Name the byte codes"
[ "-"      `0 ] 'nop' :
[ "vt-v"   `1 ] 'set-type' :
[ "v-vn"   `2 ] 'type?' :
[ "nn-n"   `3 ] '+' :
[ "nn-n"   `4 ] '-' :
[ "nn-n"   `5 ] '*' :
[ "nn-n"   `6 ] '/' :
[ "nn-n"   `7 ] 'rem' :
[ "n-n"    `8 ] 'floor' :
[ "nn-n"   `9 ] '^' :
[ "n-n"    `10 ] 'log' :
[ "n-n"    `11 ] 'log10' :
[ "nn-n"   `12 ] 'log<n>' :
[ "nn-n"   `13 ] 'shift' :
[ "nn-n"   `14 ] 'and' :
[ "nn-n"   `15 ] 'or' :
[ "nn-n"   `16 ] 'xor' :
[ "-n"     `17 ] 'random' :
[ "n-n"    `18 ] 'sqrt' :
[ "n-n"    `19 ] 'round' :
[ "nn-f"   `20 ] 'lt?' :
[ "nn-f"   `21 ] 'gt?' :
[ "nn-f"   `22 ] 'lteq?' :
[ "nn-f"   `23 ] 'gteq?' :
[ "vv-f"   `24 ] 'eq?' :
[ "vv-f"   `25 ] '-eq?' :
[ "fpp-"   `26 ] 'if' :
[ "p-"     `27 ] 'while' :
[ "p-"     `28 ] 'until' :
[ "np-"    `29 ] 'times' :
[ "p-"     `31 ] 'invoke' :
[ "vp-v"   `32 ] 'dip' :
[ "vp-v"   `33 ] 'sip' :
[ "vpp-?"  `34 ] 'bi' :
[ "vppp-?" `35 ] 'tri' :
[ "-"      `36 ] 'abort' :
[ "pp-"    `38 ] 'copy' :
[ "pn-v"   `39 ] 'fetch' :
[ "vpn-"   `40 ] 'store' :
[ "-p"     `41 ] 'request' :
[ "p-"     `42 ] 'release' :
[ "-"      `43 ] 'collect-garbage' :
[ "p-n"    `44 ] 'get-last-index' :
[ "np-"    `45 ] 'set-last-index' :
[ "tpn-"   `46 ] 'set-stored-type' :
[ "pn-n"   `47 ] 'get-stored-type' :
[ "v-vv"   `48 ] 'dup' :
[ "v-"     `49 ] 'drop' :
[ "vV-Vv"  `50 ] 'swap' :
[ "-n"     `51 ] 'depth' :
[ "s-"     `55 ] 'hide-function' :
[ "ss-n"   `57 ] 'find' :
[ "pnn-p"  `58 ] 'subslice' :
[ "s-f"    `59 ] 'numeric?' :
[ "p-p"    `60 ] 'reverse' :
[ "v-v"    `61 ] 'to-lowercase' :
[ "v-v"    `62 ] 'to-uppercase' :
[ "s-"     `63 ] 'report-error' :
[ "-p"     `64 ] 'vm.dict<names>' :
[ "-p"     `65 ] 'vm.dict<slices>' :
[ "n-n"    `66 ] 'sin' :
[ "n-n"    `67 ] 'cos' :
[ "n-n"    `68 ] 'tan' :
[ "n-n"    `69 ] 'asin' :
[ "n-n"    `70 ] 'acos' :
[ "n-n"    `71 ] 'atan' :
[ "n-n"    `72 ] 'atan2' :
[ "-p"     `73 ] 'vm.memory<map>' :
[ "-p"     `74 ] 'vm.memory<sizes>' :
[ "-p"     `75 ] 'vm.memory<allocated>' :

[ "vV-vVv" [ dup ] dip swap ] 'over' :
[ "vV-VvV" [ swap ] sip ] 'tuck' :
[ "vV-V"   swap drop ] 'nip' :
[ "...-"   depth [ drop ] times ] 'reset' :
[ "sp-"    swap : ] '.' :

"Symbolic names for data types"
[ "-n"  100 ] 'NUMBER' :
[ "-n"  200 ] 'STRING' :
[ "-n"  300 ] 'CHARACTER' :
[ "-n"  400 ] 'POINTER' :
[ "-n"  500 ] 'FLAG' :
[ "-n"  600 ] 'BYTECODE' :
[ "-n"  700 ] 'REMARK' :
[ "-n"  800 ] 'FUNCALL' :
[ "-n"    0 ] 'UNKNOWN' :

[ "v-b" BYTECODE  set-type ] ':b' :
[ "v-n" NUMBER    set-type ] ':n' :
[ "v-s" STRING    set-type ] ':s' :
[ "v-c" CHARACTER set-type ] ':c' :
[ "v-p" POINTER   set-type ] ':p' :
[ "v-f" FLAG      set-type ] ':f' :
[ "v-f" FUNCALL   set-type ] ':x' :
[ "v-c" REMARK    set-type ] ':r' :
[ "v-v" UNKNOWN   set-type ] ':u' :

[ "v-vf" type? NUMBER    eq? ] 'number?' :
[ "v-vf" type? STRING    eq? ] 'string?' :
[ "v-vf" type? CHARACTER eq? ] 'character?' :
[ "v-vf" type? POINTER   eq? ] 'pointer?' :
[ "v-vf" type? FLAG      eq? ] 'flag?' :
[ "v-vf" type? BYTECODE  eq? ] 'bytecode?' :
[ "v-vf" type? REMARK    eq? ] 'remark?' :
[ "v-vf" type? FUNCALL   eq? ] 'funcall?' :
[ "v-vf" type? UNKNOWN   eq? ] 'unknown?' :

"Stack Flow"
[ "vV-vVvV"  over over ] 'dup-pair' :
[ "vv-"      drop drop ] 'drop-pair' :
[ "?n-"      [ drop ] times ] 'drop-multiple' :
[ "q-...n"   depth [ invoke ] dip depth swap - ] 'invoke<depth?>' :


"Slice Functions"
[ "p-pn"  dup get-last-index ] 'last-index?' :
[ "p-pn"  last-index? 1 + ] 'slice-length?' :
[ "np-"   [ get-last-index + ] sip set-last-index ] 'adjust-slice-length' :
[ "p-p"   request [ copy ] sip ] 'duplicate-slice' :
[ "p-n"   get-last-index 1 + ] 'length?' :


"Simple variables are just named slices, with functions to access the first element. They're useful for holding single values."
[ "vs-"  [ request [ 0 store ] sip ] dip : ] 'var!' :
[ "s-"   0 :u swap var! ] 'var' :
[ "p-"   0 swap 0 store ] 'off' :
[ "p-"   -1 swap 0 store ] 'on' :
[ "p-"   [ 0 fetch 1 + ] sip 0 store ] 'increment' :
[ "p-"   [ 0 fetch 1 - ] sip 0 store ] 'decrement' :
[ "p-"   request swap copy ] 'zero-out' :
[ "pp-"  swap request dup-pair copy swap [ [ invoke ] dip ] dip copy ] 'preserve' :


"Number functions"
[ "nn-n"  over over lt? [ nip ] [ drop ] if ] 'max' :
[ "nn-n"  over over gt? [ nip ] [ drop ] if ] 'min' :
[ "n-n"   dup -1 * max ] 'abs' :

"The basic bi/tri combinators provided as part of the primitives allow application of multiple quotes to a single data element. Here we add new forms that are very useful."
"We consider the bi/tri variants to consist of one of three types."
"Cleave combinators (bi, tri) apply multiple quotations to a single value (or set of values)."


"Spread combinators (bi*, tri*) apply multiple quotations to multiple values."
[ "vvpp-?"   [ dip ] dip invoke ] 'bi*' :
[ "vvvppp-?" [ [ swap [ dip ] dip ] dip dip ] dip invoke ] 'tri*' :


"Apply combinators (bi@, tri@) apply a single quotation to multiple values."
[ "vvp-?"    dup bi* ] 'bi@' :
[ "vvvp-?"   dup dup tri* ] 'tri@' :


"Expand the basic conditionals into a more useful set."
[ "s-"   report-error abort ] 'abort<with-error>' :
[ "-f"   -1 :f ] 'true' :
[ "-f"   0  :f ] 'false' :
[ "f-f"  :f :n -1 xor :f ] 'not' :
[ "fp-"  [ ] if ] 'if-true' :
[ "fp-"  [ ] swap if ] 'if-false' :
[ "v-f"  :s 'nan' eq? ] 'nan?' :
[ "v-f"  0 eq? ] 'zero?' :
[ "v-f"  :f :n zero? not ] 'true?' :
[ "v-f"  :f :n zero? ] 'false?' :
[ "n-f"  2 rem zero? ] 'even?' :
[ "n-f"  2 rem zero? not ] 'odd?' :
[ "n-f"  0 lt? ] 'negative?' :
[ "n-f"  0 gteq? ] 'positive?' :
[ "nnn-f"  [ [ :n ] bi@ ] dip :n dup-pair gt? [ swap ] if-true [ over ] dip lteq? [ gteq? ] dip and :f ] 'between?' :
[ "vv-vvf"  [ type? ] dip type? swap [ eq? ] dip swap ] 'types-match?' :


"numeric ranges"
[ "nn-..."  dup-pair lt? [ [ [ dup 1 + ] dip dup-pair eq? ] until ] [ [ [ dup 1 - ] dip dup-pair eq? ] until ] if drop ] 'expand-range' :
[ "...n-n"  1 - [ + ] times ] 'sum-range' :


"Misc"
[ "p-"   invoke<depth?> [ hide-function ] times ] 'hide-functions' :
[ "ps-"  dup hide-function : ] 'redefine' :
[ "p-"   invoke<depth?> [ var ] times ] '::' :


"String and Character"
"Note that this is only supporting the basic ASCII character set presently."
[ "vs-f" swap :s find not true? ] 'string-contains?' :
[ "v-f"  :c $0 $9 between? ] 'digit?' :
[ "v-f"  '`~!@#$%^&*()'"<>,.:;[]{}\|-_=+'                    string-contains? ] 'symbol?' :
[ "v-f"  to-lowercase 'abcdefghijklmnopqrstuvwxyz'           string-contains? ] 'letter?' :
[ "v-f"  to-lowercase 'abcdefghijklmnopqrstuvwxyz1234567890' string-contains? ] 'alphanumeric?' :
[ "v-f"  to-lowercase 'bcdfghjklmnpqrstvwxyz'                string-contains? ] 'consonant?' :
[ "v-f"  to-lowercase 'aeiou'                                string-contains? ] 'vowel?' :
[ "v-f"  dup to-lowercase eq? ] 'lowercase?' :
[ "v-f"  dup to-uppercase eq? ] 'uppercase?' :
[ "p-s"  invoke<depth?> 1 - [ [ :s ] bi@ + ] times ] 'build-string' :


"Slice as a linear buffer"
[ 'CurrentBuffer'  'BufferOffset' ] ::
[ "-pn"    @CurrentBuffer @BufferOffset ] 'buffer-position' :
[ "-"      &BufferOffset increment ] 'buffer-advance' :
[ "-"      &BufferOffset decrement ] 'buffer-retreat' :
[ "n-"     buffer-position store ] 'buffer-store-current' :
[ "-n"     buffer-position fetch ] 'buffer-fetch-current' :
[ "v-"     buffer-position store buffer-advance ] 'buffer-store' :
[ "-n"     buffer-position fetch buffer-advance ] 'buffer-fetch' :
[ "v-"     buffer-retreat buffer-position store ] 'buffer-store-retreat' :
[ "-n"     buffer-retreat buffer-position fetch ] 'buffer-fetch-retreat' :
[ "p-"     !CurrentBuffer 0 !BufferOffset ] 'set-buffer' :
[ "...n-"  [ buffer-store ] times ] 'buffer-store-items' :
[ "-"      request set-buffer ] 'new-buffer' :
[ "p-"     @CurrentBuffer [ @BufferOffset [ invoke ] dip !BufferOffset ] dip !CurrentBuffer ] 'preserve-buffer' :
[ "s-"     request [ swap : ] sip set-buffer ] 'named-buffer' :


"Programatic Creation of Quotes"
[ "vv-p"  swap request [ 0 store ] sip [ 1 store ] sip ] 'cons' :
[ "vp-p"  :x cons ] 'curry' :


"Arrays and Operations on Quotations"
[ "q-v"  0 fetch ] 'head' :
[ "q-q"  1 over length? subslice ] 'body' :
[ "p-v"  slice-length? 1 - fetch ] 'tail' :

[ 'Found'  'Value'  'XT'  'Source'  'Target'  'Offset' ] ::
[ "q-" \
  @Found [ @Value [ @XT [ @Source [ @Target [ @Offset [ invoke ] dip !Offset ] dip !Target ] dip !Source ] dip !XT ] dip !Value ] dip !Found ] 'localize' :

[ "vp-"    :p dup length? store ] 'push' :
[ "p-v"    :p [ dup get-last-index fetch ] sip dup length? 2 - swap set-last-index ] 'pop' :
[ "-p"     request [ pop drop ] sip ] 'request-empty' :
[ "pnp-n"  [ !XT over length? [ over pop @XT invoke ] times nip ] localize ] 'reduce' :
[ "pp-?"   [ !XT !Source 0 !Offset @Source length? [ @Source @Offset fetch @XT invoke @Offset 1 + !Offset ] times ] localize ] 'for-each' :
[ "pv-f"   false !Found !Value dup length? 0 swap [ dup-pair fetch @Value types-match? [ eq? @Found or :f !Found ] [ drop-pair ] if 1 + ] times drop-pair @Found ] 'contains?' :
[ "pq-p"   [ !XT !Source request-empty !Target 0 !Offset @Source length? [ @Source @Offset fetch @XT invoke [ @Source @Offset fetch @Target push ] if-true @Offset 1 + !Offset ] times @Target ] localize ] 'filter' :
[ "pq-"    [ !XT duplicate-slice !Source 0 !Offset @Source length? [ @Source @Offset fetch @XT invoke @Source @Offset store @Offset 1 + !Offset ] times @Source ] localize ] 'map' :
[ "p-p"    [ request !Target invoke<depth?> 0 max [ @Target push ] times @Target 1 over length? subslice :p ] localize ] 'capture-results' :

[ "pv-n" \
  [ dup-pair !Value !Source \
    contains? \
    [ 0 !Offset #nan !Found @Source length? [ @Source @Offset fetch @Value types-match? [ eq? [ @Offset !Found ] if-true ] [ drop-pair ] if @Offset 1 + !Offset ] times @Found ] \
    [ #nan ] if \
  ] localize \
] 'index-of' :

[ 'Found'  'Value'  'XT'  'Source'  'Target'  'Offset'  'localize' ] hide-functions


[ "s-f"  vm.dict<names> swap contains? ] 'function-exists?' :
[ "s-p"  vm.dict<names> swap index-of vm.dict<slices> swap fetch ] 'lookup-function' :
[ "p-s"  vm.dict<slices> over contains? [ vm.dict<slices> swap index-of vm.dict<names> swap fetch ] [ drop '' ] if ] 'lookup-name' :


[ "ss-"  swap dup function-exists? [ dup lookup-function swap hide-function swap : ] [ drop ] if ] 'rename-function' :

"Functions for trimming leading and trailing whitespace off of a string. The left side trim is iterative; the right side trim is recursive."
[ "s-s" :s #0 [ dup-pair fetch :n 32 eq? [ 1 + ] dip ] while 1 - [ last-index? 1 + ] dip swap subslice :s ] 'trim-left' :
[ "s-s" reverse trim-left reverse :s ] 'trim-right' :
[ "s-s" trim-right trim-left ] 'trim' :


"Text Output Buffer"
'TOB' var
[ "v-"   &TOB push ] 'to-tob' :
[ "-..." &TOB get-last-index [ &TOB pop ] times ] 'show-tob' :
[ "-"    0 &TOB set-last-index ] 'clear-tob' :


"Scope"
[ 'Public'  'Private' ] ::
[ "-" vm.dict<names> !Private ] '{' :
[ "p-" \
  [ string? nip ] filter !Public \
  "Extract names in scope" \
  vm.dict<names> @Private length? over length? subslice !Private \
  \
  "Filter out the functions to keep" \
  @Private [ @Public swap contains? not ] filter \
  \
  "Hide the remaining names" \
  [ hide-function ] for-each \
] '}' :
[ 'Public'  'Private' ] hide-functions


[ 'invoke<preserving>' ] {
  [ 'Prior'  'List' ] ::
  [ "qq-" \
    @Prior [ \
      @List [ \
        swap duplicate-slice !List \
        [ @List [ head ] for-each ] capture-results reverse !Prior \
        invoke \
        @Prior length? [ @Prior pop @List pop 0 store ] times \
      ] dip !List \
    ] dip !Prior \
  ] 'invoke<preserving>' :
}

[ 'zip' ] {
  [ 'A'  'B'  'X'  'C' ] ::

  [ "ppp-p" \
    [ A B X C ] \
    [ !X !B !A request-empty !C \
      @A length? [ @A head @B head @X invoke @C push @A body !A @B body !B ] times \
      @C duplicate-slice \
    ] invoke<preserving> \
  ] 'zip' :
}


"Hashing functions"
389 'Hash-Prime' var!
[ "s-n" 0 swap [ :n xor ] for-each ] 'hash:xor' :
[ "s-n" 5381 swap [ over -5 shift + + ] for-each ] 'hash:djb2' :
[ :n over -6 shift + over -16 shift + swap - ] 'hash:sdbm<n>' :
[ "s-n" 0 swap [ :c swap hash:sdbm<n> ] for-each ] 'hash:sdbm' :
[ "s-b" hash:djb2 ] 'chosen-hash' :
[ "s-n" chosen-hash @Hash-Prime rem ] 'hash' :
'hash:sdbm<n>' hide-function



[ 'when' ] {
  [ 'Offset'  'Tests'  'Done' ] ::

  [ "q-" \
    [ Offset Tests Done ] \
    [ !Tests false !Done 0 !Offset \
      [ @Tests @Offset fetch head invoke \
        [ true !Done @Tests @Offset fetch 1 fetch invoke ] if-true \
        @Offset 1 + !Offset @Done \
      ] until \
    ] invoke<preserving> \
  ] 'when' :
}


[ 'split'  'join' ] {
  [ 'Source'  'Value'  'Target' ] ::
  [ "n-"  [ @Source 0 ] dip subslice :s ] 'extract' :
  [ "n-"  @Source swap @Value length? + over length? subslice :s !Source ] 'next-piece' :

  [ "ss-p" \
    slice-length? 0 eq? \
    [ drop [ :s ] map ] \
    [ :s !Value \
      !Source \
      request-empty !Target \
      [ @Source @Value find dup \
        -1 -eq? [ [ extract @Target push ] sip next-piece true ] \
                [ drop @Source @Target push false ] if \
      ] while \
      @Target \
    ] if \
  ] 'split' :

  [ "pv-s" \
    :s !Value \
    reverse '' [ :s + @Value + ] reduce \
    "This leaves the join value appended to the string. Remove it." \
    0 over length? @Value length? - subslice :s \
  ] 'join' :
}

[ "s-s"  [ :n 32 128 between? ] filter :s ] 'clean-string' :

[ "sss-s"  [ split ] dip join clean-string ] 'replace' :


[ 'interpolate' ] {
  [ 'Data'  'Source'  'String' ] ::

  [ "-"  @String @Source head @Data head pointer? [ invoke ] if-true :s + + !String ] '(accumulate)' :
  [ "-"  @Source body !Source  @Data body !Data ] '(next)' :

  [ "ps-s" \
    [ Data Source String ] \
    [ '{v}' split !Source \
      !Data \
      request-empty :s !String \
      @Data length? [ (accumulate) (next) ] times \
      "Merge any remaining items" \
      @String @Source '' join + clean-string \
    ] invoke<preserving> \
  ] 'interpolate' :
}


[ 'interpolate<cycling>' ] {
  [ 'D'  'S'  'L' ] ::

  [ "qs-s" \
    [ S D L ] \
    [ !S  !D \
      @S '{v}' split length? !L \
      [ @D length? @L lt? dup [ @D duplicate-slice @D + !D ] if-true ] while \
      [ @D length? @L lt? dup [ @D pop drop ] if-false ] until \
      @D @S interpolate \
    ] invoke<preserving> \
  ] 'interpolate<cycling>' :
}


"?"
[ '?' ] {
  [ 'Probability' ] ::
  [ "f-"   [ &Probability increment ] if-true ] 'check' :
  [ "s-s"  head uppercase? check ] 'initial' :
  [ "s-s"  1 fetch lowercase? check ] 'second' :
  [ "s-s"  lookup-function head remark? not check drop ] 'no-comment?' :
  [ "s-f" \
    0 !Probability \
    slice-length? \
    1 eq? [ &initial &no-comment? bi @Probability 2 eq? ] \
          [ &initial &second &no-comment? tri @Probability 3 eq? ] if \
    "Given a function name, try to determine if it is a variable." \
  ] 'var?' :


  [ "p-?"  &head &tail bi [ remark? &drop if-false ] bi@ ] 'describe-func' :
  [ "s-s"  drop 'Variable' &:r bi@ ] 'describe-var' :

  [ "s-s | s-ss" \
    dup function-exists? \
    [ dup var? \
      [ describe-var ] \
      [ lookup-function \
        [ head ] [ tail ] bi \
        [ remark? [ drop ] if-false ] bi@ \
      ] if \
    ] \
    [ 'function "' swap + '" not found' + report-error ] \
    if \
  ] '?' :
}


"unsorted"
[ 'stack-values' ] {
  'S' var

  [ "-p" \
    request-empty !S \
    depth [ @S push ] times \
    @S reverse dup !S invoke \
    @S \
  ] 'stack-values' :
}



[ 'vm.dict<names-like>' ] {
 'Pattern' var
 [ "s-f" @Pattern swap string-contains? ] 'matches' :
 [ "s-p" \
   !Pattern vm.dict<names> &matches filter \
   "Return an array of names in the dictionary that match a given substring." \
 ] 'vm.dict<names-like>' :
}
