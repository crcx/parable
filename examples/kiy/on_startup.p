"hand tools"
"2016 kiy"

'({)'     '{' swap rename-function
'(})'     '}' swap rename-function
'+open{}' [ "-" '{' &nop . '}' &drop . ] .
'-open{}' [ "-" '{' &({) . '}' &(})  . ] .
 -open{}


'cheat' [ "ss-" + slurp-file display ] .
'txt'   [ "s-" '.txt' cheat ] .

[ 'marker'  'anew'  ] { "160224 crcx"
  [ 'needle' 'haystack' ] ::

  [ "-p" \
    @haystack dup [ @needle index-of ] [ length? ] bi subslice ] '(extract)' :

  [ "-s" vm.dict<names> tail ] 'last-name' :

  [ "s-" \
    !needle  vm.dict<names> !haystack \
    @haystack @needle contains? [ (extract) hide-functions ] if-true \
    "Remove all including and following the specified name." \
  ] 'remove-entries' :

  [ "s-" \
    var last-name [ remove-entries ] curry last-name : \
    "A marker is a function that resets the dictionary to the state it was \
     in prior to the creation of the marker." \
  ] 'marker' :

  [ "s-" \
    dup function-exists? [ dup lookup-function invoke ] if-true marker \
    "If the specified name exists, remove it and all subsequent names. Then \
     create a new marker with the specified name." \
  ] 'anew' :
}

"'on_startup.p' marker"
';'     &invoke .
';>'    &invoke<preserving> .
';t'    &invoke<time> .
'..'    &.s .
'cg'    &collect-garbage .
'gc'    &cg .
'like'  &vm.dict<names-like> .
'stop'  &abort<with-error> .
'--'    &reset .

'unk'   [ "-u"    #nan :u        ] .
'unk?'  [ "n-nf"  dup   unknown? ] .
'nan?>' [ "n-nf"  dup       nan? ] .
  '0?'  [ "n-nf"  dup      zero? ] .
 '-1?'  [ "n-nf"  dup #-1    eq? ] .
  '1?'  [ "n-nf"  dup #1     eq? ] .
 '0+?'  [ "n-nf"  dup #0   gteq? ] .
 '0-?'  [ "n-nf"  dup #0   lteq? ] .
  '-?'  [ "n-nf"  dup #0     lt? ] .
  '+?'  [ "n-nf"  dup #0     gt? ] .
 '-0?'  [ "n-nf"  dup #0    -eq? ] .
  '=?'  [ "nN-nf" over       eq? ] .
 '-=?'  [ "nN-nf" over      -eq? ] .
  '>?'  [ "nN-nf" over       lt? ] .
  '<?'  [ "nN-nf" over       gt? ] .
 '=<?'  [ "nN-nf" over     gteq? ] .
 '>=?'  [ "nN-nf" over     lteq? ] .
'len?'  [ "?-?n"  dup    length? ] .
'1+'    [ "n-n" #1 + ] .
'1-'    [ "n-n" #1 - ] .

'bytes'   [ "n-n" #16 "bytes/cell" * #2 "cells/entry" * "cells to bytes converseion" ] .
'bytes?'  [ "p-n" length? bytes "slice size in bytes" ] .
'B?'      [ "-n" vm.memory<sizes> #0 &+ reduce bytes "memory used in bytes" ] .
'MB?'     [ "-n" B? #2 [ #1024 / ] times #10 [ * round ] sip / "memory used in MB" ] .

 'enslice'    &stack-values .
'-enslice'    [ "p-.." &nop for-each "slice to stack" ] .
 'rot'        [ "Vvv-vvV" &swap dip swap ] .
'-rot'        [ "vvV-Vvv" rot rot ] .
'roll'        [ "...-..." enslice &reset dip &head &body bi &push sip -enslice \
                "Roll the last item on the stack to the top" ] .
'rolls'       [ "..n-.." &roll times ] .
'pick'        [ "...n-..." &enslice dip swap [ 1+ rolls dup ] dip [ &reset dip ] dip swap &-enslice dip \
                "pick from stack n" ] .
'nips'        [ "..v-" &nip  times ] .
 'drops'      [ "..n-" &drop times ] .
'2drops'      &drop-pair .
 'drop-from'  [ "..n-.." depth swap - 1- drops \
                "drop from n to the top of stack"    ] .
 'drop-to'    [ "..n-.." 1+ [ &roll times ] sip drops \
                "drop from 0 to n of the stack" ] .
 'drop-all'   &reset .
[ 'drop-pick' ] {
      'mark-unknown' [ "pn-p" &dup dip #nan :u swap &swap dip store ] .
      'erase-unknown' [ "p-p" dup pop unknown? &drop &swap if ] .
  'drop-pick'  [ "..p or ..n - .." &enslice dip pointer? [ &mark-unknown for-each ] &mark-unknown if \
                 reverse &reset dip len? &erase-unknown times drop ] . }
 'stack-values<n>' [ "..n-p" request-empty swap [ &push sip ] times reverse ] .

 '0@'       [ "p-v" #0 fetch ] . "consider using @ prefix"
 '0!'       [ "vp-" #0 store ] . "consider using ! prefix"
 '1@'       [ "p-v" #1 fetch ] .
 '1!'       [ "vp-" #1 store ] .
 '0_1+'     &increment .
 '0_1-'     &decrement .
 '1_1+'     [ "p-" [ 1@ 1+ ] sip 1! ] .
 '1_1-'     [ "p-" [ 1@ 1- ] sip 1! ] .
'0remark!'  [ "sp-" swap :r swap 0! ] . 
'[].'       [ "s-" '-?' request &0remark! sip #nan :u over push . ] .
'behead'    [ "p-p" reverse [ pop drop ] sip reverse ] .
'dim?'      &get<final-offset> .
'dim!'      &set<final-offset> .

[ '-1@' '-1!' '-1_1+' '-1_1-' 'head-remark?' 'tail-remark?' 'vector?' 'envector' 'assert-vector' \
  'vpush' 'vpop' 'vdrop' 'vreset' ] { 
"a vector may be used as a constant function, an array, or a stack."
"each vector must have one head remark and no tail remark."
"define an empty vector by 'name' []. "
"use '0remark!' to reset the head remark."
"use '1!' to reset its first value."
    'bottom?'       [ "p-pf" len? #2 lteq? ] .
    '1unk?'         [ "p-pf" dup 1@ unknown? nip ] .
    '1unk!'         [ "p-" #nan :u swap 1! ] .
    'fetch.unk!'    [ "p-v" &1@ sip 1unk! ] .
  '-1@'       [ "p-v" bottom? &fetch.unk! &tail if ] .
  '-1!'       [ "vp-" dup dim? store ] .
  '-1_1+'     [ "p-" dup -1@ 1+ swap -1! ] .
  '-1_1-'     [ "p-" dup -1@ 1- swap -1! ] .
    'value-absent?' [ "p-pf" bottom? &1unk? &false if ] .
  'head-remark?'  [ "p-pf" dup  0@ remark? nip ] . 
  'tail-remark?'  [ "p-pf" dup -1@ remark? nip ] .
    'vector?'     [ "p-pf" head-remark? [ tail-remark? not ] dip and \
                      "+head -tail  =>  true; actually, there are more conditions to fulfill" ] .
    'vector-stop'   [ "sp-" drop 'ERROR: vector \'{v}\' must have a head remark and no tail remark' \
                      interpolate stop ] .
  'assert-vector' [ "sp-" dup-pair . vector? [ 2 drops ] &vector-stop if ] .
    'add-remark-to-head'    [ "sp-" [ :r enquote ] dip &+ sip ] .
    'merge-remarks-to-head' [ "p-p" dup [ 0@ :s ' | ' + ] sip [ pop :s ] sip [ + :r ] dip 0! ] .
  'envector'      [ "p-p" head-remark? [ '-?' add-remark-to-head ] if-false \
                      tail-remark? &merge-remarks-to-head if-true "turn a function into a vector" ] .
  'vpop'          [ "p-v" bottom? &fetch.unk! &pop  if ] .
  'vdrop'         [ "p-" dup len? #2 - #1 max swap dim! len? #2 eq? &1unk! if-true ] .
  'vreset'        [ "p-" 1unk! #1 dim! ] .
  'vpush'         [ "vp-" value-absent? &1! &push if ] . }

[ 'dump' ] { "dump a slice to the stack, as a set of strings indicating raw values and types."
  'v:t'  [ "pn-s" fetch :p :n :s ':' + [ dup-pair fetch<type> :n :s ] dip swap + ] .
  'dump' [ "p-..." len? #0 swap [ dup-pair v:t swap &swap dip #1 + ] times 2drops ] . }

[ '-zip' ] { "unzip, inverse of [ &cons zip ] "
    'left'  [].
    'right' [].
  '-zip'  [ "p-p" request-empty &left 1! request-empty &right 1! \
            [ [ 0 fetch &left 1@ push ] for-each ] sip [ 1 fetch &right 1@ push ] for-each \
            &left 1@ &right 1@ cons ] . }

'->'        [ "v &left &right - v" [ swap index-of ] dip swap fetch "uses the first found" ] .
'frac'      [ "n-n" #1 rem ] .
'newline'   [ "s-s" '\n' + ] .
'newlines'  [ "sn-s" &newline times ] .
'space'     [ "s-s" '\ ' + ] .
'spaces'    [ "sn-s" &space times ] .
'zero'      [ "s-s" '0' + ] .
'zeros'     [ "sn-s" &zero times ] .
'prepend'   [ "ss-s" swap + ] .
'enclose'   [ "ss - s1 s0 s1" &prepend sip + ] .
'-frac'     [ "s-s" dup numeric? over $. swap string-contains? and \
              [ dup $. index-of #0 swap subslice :s ] if-true "eliminate fraction" ] .
'digits'    [ "sn-s" over length? - '' swap spaces prepend \
              "n-digit integer string with leading spaces" ] .
'integer?'  [ "n-nf" dup frac 0? nip ] .
'counter'   [ "s-q" request [ &head &increment bi ] curry ] .
'lengths?'  [ "p-p" [ &length? for-each ] capture-results &push sip reverse ] .
[ 'all=?' 'lengths=?' ] {
    'equal?'  [ "n-f" nop =? nip ] .
     'all=?'  [ "[n..n]-f" dup 0@ &equal? 1! &equal? map true &and reduce ] .
  'lengths=?' [ "p-f" lengths? all=? "test if all lengths are equal" ] . }

[ 'int~0?' ] { "is the number representable as an integer for printing?"
  'with-e?' [ "s-s" $e over string-contains? ] .
  'int~0?'  [ "n-nf" integer? [ dup :s with-e? not nip ] [ false ] if ] . }
'n>s'       [ "n-s" nan?> [ drop 'nan' ] [ int~0? [ :s -frac ] if-true ] if ] .

'HERE'      [ "n-" n>s ' here!\n' + display "for lion fence debugging" ] .
'BREAK'     [ "n-" n>s ' breakpoint!' + stop ] .

[ '[]' ] { "dump detailed"

    'addr'  [ "p-s" dup lookup-name dup '' eq? [ drop :n n>s ] &nip if ] .
    'n.do'  [ "sn-s" n>s     '#'  prepend + ] .
    's.do'  [ "ss-s"         '\'' enclose + ] .
    'c.do'  [ "sc-s" :s      '$'  prepend + ] .
    'p.do'  [ "sp-s" :n addr '&'  prepend + ] .
    'f.do'  [ "sf-s" :f :s                + ] .
    'b.do'  [ "sb-s" :n n>s  '`'  prepend + ] .
            "what is the easiest way to convert a binary code to its name?"
    'r.do'  [ "sr-s" :s      '"'  enclose + ] .
    'x.do'  [ "sx-s" :p addr 'x&' prepend + ] .
    'u.do'  [ "s?-s" drop    '?unknown'   + ] .

    'type.do' [ "sv-s" [ \
                [ &number?    &n.do ] \
                [ &string?    &s.do ] \
                [ &character? &c.do ] \
                [ &pointer?   &p.do ] \
                [ &flag?      &f.do ] \
                [ &bytecode?  &b.do ] \
                [ &remark?    &r.do ] \
                [ &funcall?   &x.do ] \
                [ &unknown?   &u.do ] \
                [ &true       &u.do ] ] when ] .
    'type.pick'  [ "pn-ss" &fetch sip n>s #3 digits space swap ] .
    'cell'  [ "pn-s" type.pick type.do ] .

    'i'     [].
    'init'  [ "p:src - p:src p:tgt n:len" 0 &i 1! request-empty over length? ] .
    'cells' [ "p-p" init [ over i cell swap &push sip &i 1_1+ ] times nip ] .
    'title' [ "p-s" dup '' swap p.do space swap lookup-name '\'' enclose + ] .

  '[]'  [ "p-s.." dup title swap cells &:s for-each "usage: -- &name []" ] . }

'(?)'   '?' swap rename-function
 '?'    [ "s-.." (?) .. ] .
'??'    [ "s-.." lookup-function [] .. ] . 

'clear' [ "-" 'clear'                    sys.run drop ] .
'date'  [ "-" 'date \"+%Y-%m-%d %H:%M\"' sys.run drop ] .
'ls'    [ "-" 'ls'                       sys.run drop ] .
'ps'    [ "-" 'ps -al'                   sys.run drop ] .
'pwd'   [ "-" 'pwd'                      sys.run drop ] .
'todo'  [ "-" 'cat todo.txt'             sys.run drop ] .
 
+ignore
  'units.p' include "a collection of units for conversion"
-ignore

'allegory.on-start' [ MB? gc MB? .. 2drops ] .
'alle' save-as
