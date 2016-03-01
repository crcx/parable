"Name the byte codes"
[ "-"      `0  "Does nothing" ] 'nop' :
[ "vt-v"   `1  "Convert a value to the specified type" ] 'set-type' :
[ "v-vn"   `2  "Return the type constant for a value" ] 'type?' :
[ "nn-n"   `3  "Add two numbers or concatenate two strings, remarks, or slices" ] '+' :
[ "nn-n"   `4  "Subtract n2 from n1" ] '-' :
[ "nn-n"   `5. "Multiply two numbers" ] '*' :
[ "nn-n"   `6  "Divide n1 by n2" ] '/' :
[ "nn-n"   `7  "Divide n1 by n2, returning the remainder" ] 'rem' :
[ "n-n"    `8  "Return the smallest integer less than or equal to the starting value" ] 'floor' :
[ "nn-n"   `9  "Return n1 to the power n2" ] '^' :
[ "nn-n"   `12 "Return the logarithim of a number in the specified base" ] 'log<n>' :
[ "nn-n"   `13 "Perform a bitwise shift" ] 'shift' :
[ "nn-n"   `14 "Bitwise AND operation" ] 'and' :
[ "nn-n"   `15 "Bitwise OR operation" ] 'or' :
[ "nn-n"   `16 "Bitwise XOR operation" ] 'xor' :
[ "-n"     `17 "Return a random number" ] 'random' :
[ "n-n"    `18 "Obtain the square root of a number" ] 'sqrt' :
[ "n-n"    `19 "Round a number to the nearest integer value" ] 'round' :
[ "nn-f"   `20 "True if n1 < n2 or false otherwise" ] 'lt?' :
[ "nn-f"   `21 "True if n1 > n2 or false otherwise" ] 'gt?' :
[ "nn-f"   `22 "True if n1 <= n2 or false otherwise" ] 'lteq?' :
[ "nn-f"   `23 "True if n1 >= n2 or false otherwise" ] 'gteq?' :
[ "vv-f"   `24 "True if n1 == n2 or false otherwise" ] 'eq?' :
[ "vv-f"   `25 "True if n1 != n2 or false otherwise" ] '-eq?' :
[ "fpp-"   `26 "If flag is true, invoke p1; otherwise invoke p2" ] 'if' :
[ "p-"     `27 "Invoke p (which should return a flag) until the returned flag is false" ] 'while' :
[ "p-"     `28 "Invoke p (which should return a flag) until the returned flag is true" ] 'until' :
[ "np-"    `29 "Invoke slice p the specified number of times" ] 'times' :
[ "p-"     `31 "Run the code in slice p" ] 'invoke' :
[ "vp-v"   `32 "Remove value and invoke the quote. Restore value when execution completes." ] 'dip' :
[ "vp-v"   `33 "Invoke the quote. After execution complets, restore a copy of the value to the stack" ] 'sip' :
[ "vpp-?"  `34 "Apply each quote to a copy of the value" ] 'bi' :
[ "vppp-?" `35 "Apply each quote to a copy of the value" ] 'tri' :
[ "-"      `36 "Abort the current execution cycle" ] 'abort' :
[ "pp-"    `38 "Copy the contents of the first slice to the second one" ] 'copy' :
[ "pn-v"   `39 "Fetch a value stored at the specified offset within the specified slice" ] 'fetch' :
[ "vpn-"   `40 "Store a value into the specified offset within the specified slice" ] 'store' :
[ "-p"     `41 "Request a new slice and return a pointer to it" ] 'request' :
[ "p-"     `42 "Release a previously allocated slice" ] 'release' :
[ "-"      `43 "Tell Parable that this is a good time to scan memory for unused slices and reclaim them" ] 'collect-garbage' :
[ "p-n"    `44 "Return the last offset in a slice" ] 'get<final-offset>' :
[ "np-"    `45 "Set the last index in a slice (can be used to shrink or grow a slice)" ] 'set<final-offset>' :
[ "tpn-"   `46 "Set the stored type for the value at offset with the slice to the specified type." ] 'store<type>' :
[ "pn-n"   `47 "Get the stored type for a value within a slice." ] 'fetch<type>' :
[ "v-vv"   `48 "Duplicate the top value on the stack" ] 'dup' :
[ "v-"     `49 "Discard the top value on the stack" ] 'drop' :
[ "vV-Vv"  `50 "Switch the positions of the top two items on the stack" ] 'swap' :
[ "-n"     `51 "Return the number of items on the stack" ] 'depth' :
[ "s-"     `55 "Remove the named item from the dictionary" ] 'hide-function' :
[ "ss-n"   `57 "Search for substring (s2) in a source string (s1). Returns #nan if not found." ] 'find' :
[ "pnn-p"  `58 "Return a new slice containing the contents of the original slice, starting from the specified offset and ending at (but not including) the ending offset." ] 'subslice' :
[ "s-f"    `59 "If string can be converted to a number, return true, otherwise return false" ] 'numeric?' :
[ "p-p"    `60 "Reverse the order of items in a slice. This modifies the original slice." ] 'reverse' :
[ "v-v"    `61 "Convert a string or character to lowercase" ] 'to-lowercase' :
[ "v-v"    `62 "Convert a string or character to uppercase" ] 'to-uppercase' :
[ "s-"     `63 "Add a string to the error log" ] 'report-error' :
[ "-p"     `64 "Return an array of strings corresponding to names in the dictionary" ] 'vm.dict<names>' :
[ "-p"     `65 "Return an array of slices corresponding to the named items in the dictionary" ] 'vm.dict<slices>' :
[ "n-n"    `66 "Return the sine of a number" ] 'sin' :
[ "n-n"    `67 "Return the cosine of a number" ] 'cos' :
[ "n-n"    `68 "Return the tangent of a number" ] 'tan' :
[ "n-n"    `69 "Return the arc sine of a number" ] 'asin' :
[ "n-n"    `70 "Return the arc cosine of a number" ] 'acos' :
[ "n-n"    `71 "Return the arc tangent of a number" ] 'atan' :
[ "n-n"    `72 "Return the arc tangent of a number" ] 'atan2' :
[ "-p"     `73 "Return an array indicating which slices are allocated and which are free. Each index corresponds to a slice. If the stored value is 0, the slice is free. If 1, the slice is allocated." ] 'vm.memory<map>' :
[ "-p"     `74 "Return an array indicating the size of each slice (in cells). Each index corresponds to a slice; the stored value is the length of the slice." ] 'vm.memory<sizes>' :
[ "-p"     `75 "Return an array of slice numbers which are currently marked as allocated." ] 'vm.memory<allocated>' :

[ "vV-vVv" [ dup ] dip swap "Put a copy of the second item on top of the stack" ] 'over' :
[ "vV-VvV" [ swap ] sip "Put a copy of the top item below the second item" ] 'tuck' :
[ "vV-V"   swap drop "Remove the item below the top item on the stack" ] 'nip' :
[ "...-"   depth [ drop ] times "Remove all items from the stack" ] 'reset' :
[ "sp-"    swap : "Attach a name to a slice" ] '.' :

"Symbolic names for data types"
[ "-n"  100 "Type constant" ] 'NUMBER' :
[ "-n"  200 "Type constant" ] 'STRING' :
[ "-n"  300 "Type constant" ] 'CHARACTER' :
[ "-n"  400 "Type constant" ] 'POINTER' :
[ "-n"  500 "Type constant" ] 'FLAG' :
[ "-n"  600 "Type constant" ] 'BYTECODE' :
[ "-n"  700 "Type constant" ] 'REMARK' :
[ "-n"  800 "Type constant" ] 'FUNCALL' :
[ "-n"    0 "Type constant" ] 'UNKNOWN' :

[ "v-b" BYTECODE  set-type "Convert value to a BYTECODE" ] ':b' :
[ "v-n" NUMBER    set-type "Convert value to a NUMBER" ] ':n' :
[ "v-s" STRING    set-type "Convert value to a STRING" ] ':s' :
[ "v-c" CHARACTER set-type "Convert value to a CHARACTER" ] ':c' :
[ "v-p" POINTER   set-type "Convert value to a POINTER" ] ':p' :
[ "v-f" FLAG      set-type "Convert value to a FLAG" ] ':f' :
[ "v-f" FUNCALL   set-type "Convert value to a FUNCALL" ] ':x' :
[ "v-c" REMARK    set-type "Convert value to a REMARK" ] ':r' :
[ "v-v" UNKNOWN   set-type "Convert value to a UNKNOWN" ] ':u' :

[ "v-vf" type? NUMBER    eq? "Return true if value is a NUMBER or false otherwise" ] 'number?' :
[ "v-vf" type? STRING    eq? "Return true if value is a STRING or false otherwise" ] 'string?' :
[ "v-vf" type? CHARACTER eq? "Return true if value is a CHARACTER or false otherwise" ] 'character?' :
[ "v-vf" type? POINTER   eq? "Return true if value is a POINTER or false otherwise" ] 'pointer?' :
[ "v-vf" type? FLAG      eq? "Return true if value is a FLAG or false otherwise" ] 'flag?' :
[ "v-vf" type? BYTECODE  eq? "Return true if value is a BYTECODE or false otherwise" ] 'bytecode?' :
[ "v-vf" type? REMARK    eq? "Return true if value is a REMARK or false otherwise" ] 'remark?' :
[ "v-vf" type? FUNCALL   eq? "Return true if value is a FUNCALL or false otherwise" ] 'funcall?' :
[ "v-vf" type? UNKNOWN   eq? "Return true if value is UNKNOWN or false otherwise" ] 'unknown?' :

"Stack Flow"
[ "vV-vVvV"  over over "Duplicate the top two items on the stack" ] 'dup-pair' :
[ "vv-"      drop drop "Discard the top two items on the stack" ] 'drop-pair' :
[ "?n-"      [ drop ] times "Discard an arbitrary number of items from the stack" ] 'drop-multiple' :
[ "q-...n"   depth [ invoke ] dip depth swap - "Execute a quotation, returning a value indicating th stack depth change as a result" ] 'invoke<depth?>' :


"Slice Functions"
[ "np-"   [ get<final-offset> + ] sip set<final-offset> \
  "Given a number, adjust the length of the specified slice by the requested amount." \
] 'adjust-slice-length' :

[ "p-p"   request [ copy ] sip "Make a copy of a slice, returning a pointer to the copy" ] 'duplicate-slice' :

[ "p-n"   get<final-offset> 1 + "Return the length of a slice" ] 'length?' :


"Simple variables are just named slices, with functions to access the first element. They're useful for holding single values."

[ "vs-"  [ request [ 0 store ] sip ] dip : \
  "Create a variable with an initial value" \
] 'var!' :

[ "s-"   0 :u swap var! "Create a variable" ] 'var' :

[ "p-"   0 swap 0 store "Set a variable to a value of 0" ] 'off' :

[ "p-"   -1 swap 0 store "Set a variable to a value of -1" ] 'on' :

[ "p-"   [ 0 fetch 1 + ] sip 0 store \
  "Increment a variables value by 1" \
] 'increment' :

[ "p-"   [ 0 fetch 1 - ] sip 0 store \
  "Increment a variables value by 1" \
] 'decrement' :

[ "p-"   request swap copy "Erase all values in a slice" ] 'zero-out' :

[ "pp-"  swap request dup-pair copy swap [ [ invoke ] dip ] dip copy \
  "Backup the contents of a slice and remove the pointer from the stack. Execute the quotation. Then restore the contents of the specified slice to their original state." \
] 'preserve' :


"Number functions"
[ "nn-n"  over over lt? [ nip ] [ drop ] if "Return the greater of two values" ] 'max' :
[ "nn-n"  over over gt? [ nip ] [ drop ] if "Return the smaller of two values" ] 'min' :
[ "n-n"   dup -1 * max "Return the absolute value of a number" ] 'abs' :

"The basic bi/tri combinators provided as part of the primitives allow application of multiple quotes to a single data element. Here we add new forms that are very useful."
"We consider the bi/tri variants to consist of one of three types."
"Cleave combinators (bi, tri) apply multiple quotations to a single value (or set of values)."


"Spread combinators (bi*, tri*) apply multiple quotations to multiple values."
[ "vvpp-?"   [ dip ] dip invoke "Invoke p1 against v1 and p2 against v2" ] 'bi*' :

[ "vvvppp-?" [ [ swap [ dip ] dip ] dip dip ] dip invoke \
  "Invoke p1 against v1, p2 against v2, and p3 against v3" \
] 'tri*' :


"Apply combinators (bi@, tri@) apply a single quotation to multiple values."
[ "vvp-?"    dup bi* "Invoke p1 against v1 and again against v2" ] 'bi@' :
[ "vvvp-?"   dup dup tri* "Invoke p1 against v1, then v2, then v3" ] 'tri@' :


"Expand the basic conditionals into a more useful set."
[ "s-"   report-error abort "Push a string to the error log and abort execution" ] 'abort<with-error>' :
[ "-f"   -1 :f "Return a true flag" ] 'true' :
[ "-f"   0  :f "Return a false flag" ] 'false' :
[ "f-f"  :f :n -1 xor :f "Invert a flag" ] 'not' :
[ "fp-"  [ ] if "Invoke quote if flag is true" ] 'if-true' :
[ "fp-"  [ ] swap if "Invoke quote if flag is false" ] 'if-false' :
[ "v-f"  :s 'nan' eq? "Return true if number is #nan or false otherwise" ] 'nan?' :
[ "v-f"  0 eq? "Return true if number is #0 or false otherwise" ] 'zero?' :
[ "v-f"  :f :n zero? not "Return true if flag is true or false otherwise" ] 'true?' :
[ "v-f"  :f :n zero? "Return true if flag is false or false otherwise" ] 'false?' :
[ "n-f"  2 rem zero? "Return true if number is even or false otherwise" ] 'even?' :
[ "n-f"  2 rem zero? not "Return true if number is odd or false otherwise" ] 'odd?' :
[ "n-f"  0 lt? "Return true if number is less than zero or false otherwise" ] 'negative?' :
[ "n-f"  0 gteq? "Return true if number is greater than or equal to zero or false otherwise" ] 'positive?' :
[ "nnn-f"  [ [ :n ] bi@ ] dip :n dup-pair gt? [ swap ] if-true [ over ] dip lteq? [ gteq? ] dip and :f \
  "Return true if the number (n1) is betwen n2 and n3, inclusive or false otherwise" \
] 'between?' :
[ "vv-vvf"  [ type? ] dip type? swap [ eq? ] dip swap \
  "Return true if the type of both values is the same, or false otherwise" \
] 'types-match?' :


"numeric ranges"
[ "nn-..." \
  dup-pair lt? \
    [ [ [ dup 1 + ] dip dup-pair eq? ] until ] \
    [ [ [ dup 1 - ] dip dup-pair eq? ] until ] if \
  drop \
  "Given two values, expand the range" \
] 'expand-range' :
[ "...n-n"  1 - [ + ] times "Given a series of values and a count, sum the values" ] 'sum-range' :


"Misc"
[ "p-"   invoke<depth?> [ hide-function ] times "Given an array of names, hide each named item" ] 'hide-functions' :
[ "ps-"  dup hide-function : "Remove the old name for a function and assign it to a new one" ] 'redefine' :
[ "p-"   invoke<depth?> [ var ] times "Given a list of names, create a variable for each one" ] '::' :


"String and Character"
"Note that this is only supporting the basic ASCII character set presently."
[ "vs-f" swap :s find not true? "Return true if the value is found in the specified string, or false otherwise" ] 'string-contains?' :
[ "v-f"  :c $0 $9 between? "Return true if value is a decimal digit, or false otherwise" ] 'digit?' :
[ "v-f"  '`~!@#$%^&*()<>,.:;[]{}\|-_=+"'' string-contains? "Return true if value is an ASCII symbol, or false otherwise" ] 'symbol?' :
[ "v-f"  to-lowercase 'abcdefghijklmnopqrstuvwxyz'           string-contains? "Return true if value is an ASCII letter, or false otherwise" ] 'letter?' :
[ "v-f"  to-lowercase 'abcdefghijklmnopqrstuvwxyz1234567890' string-contains? "Return true if value is a ASCII letter or digit, or false otherwise" ] 'alphanumeric?' :
[ "v-f"  to-lowercase 'bcdfghjklmnpqrstvwxyz'                string-contains? "Return true if value is a consonant, or false otherwise" ] 'consonant?' :
[ "v-f"  to-lowercase 'aeiou'                                string-contains? "Return true if value is a vowel, or false otherwise" ] 'vowel?' :
[ "v-f"  dup to-lowercase eq? "Return true if value is a lowercase string or ASCII character, or false otherwise" ] 'lowercase?' :
[ "v-f"  dup to-uppercase eq? "Return true if value is an uppercase string or ASCII character, or false otherwise" ] 'uppercase?' :
[ "p-s"  invoke<depth?> 1 - [ [ :s ] bi@ + ] times "Execute a quotation, constructing a string from the values it returns." ] 'build-string' :

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
[ "vv-p"  swap request [ 0 store ] sip [ 1 store ] sip \
  "Bind two values into a new slice" \
] 'cons' :
[ "vp-p"  :x cons "Bind a value and a quote, returning a new quote which executes the specified one against the provided value" ] 'curry' :
[ "p-p"   :x request [ 0 store ] sip "Wrap a pointer into a new quote, converting the pointer into a FUNCALL" ] 'enquote' :

"Arrays and Operations on Quotations"
[ "q-v"  0 fetch "Return the first item in a slice" ] 'head' :
[ "q-q"  1 over length? subslice ] 'body' :
[ "p-v"  dup length? 1 - fetch "Return the second through last items in a slice" "Return the last item in a slice" ] 'tail' :

[ 'Found'  'Value'  'XT'  'Source'  'Target'  'Offset' ] ::
[ "q-" \
  @Found [ @Value [ @XT [ @Source [ @Target [ @Offset [ invoke ] dip !Offset ] dip !Target ] dip !Source ] dip !XT ] dip !Value ] dip !Found ] 'localize' :

[ "vp-"    :p dup length? store "Append a value to the specified slice. This modifies the original slice." ] 'push' :

[ "p-v"    :p [ dup get<final-offset> fetch ] sip dup length? 2 - swap set<final-offset> "Remove the last value from the specified slice. This modifies the original slice." ] 'pop' :

[ "-p"     request [ pop drop ] sip "Request a slice with no stored values" ] 'request-empty' :

[ "pnp-n"  [ !XT over length? [ over pop @XT invoke ] times nip ] localize \
  "Takes a slice, a starting value, and a quote. It executes the quote once for each item in the slice, passing the item and the value to the quote. The quote should consume both and return a new value." \
] 'reduce' :

[ "pp-?"   [ !XT !Source 0 !Offset @Source length? [ @Source @Offset fetch @XT invoke @Offset 1 + !Offset ] times ] localize \
  "Takes a slice and a quotation. It then executes the quote once for each item in the slice, passing the individual items to the quote." \
] 'for-each' :

[ "pv-f"   false !Found !Value dup length? 0 swap [ dup-pair fetch @Value types-match? [ eq? @Found or :f !Found ] [ drop-pair ] if 1 + ] times drop-pair @Found \
  "Given a slice and a value, return true if the value is found in the slice, or false otherwise." \
 ] 'contains?' :

[ "pq-p"   [ !XT !Source request-empty !Target 0 !Offset @Source length? [ @Source @Offset fetch @XT invoke [ @Source @Offset fetch @Target push ] if-true @Offset 1 + !Offset ] times @Target ] localize \
  "Given a slice and a quotation, this will pass each value to the quotation (executing it once per item in the slice). The quotation should return a Boolean flag. If the flag is true, copy the value to a new slice. Otherwise discard it." \
] 'filter' :

[ "pq-"    [ !XT duplicate-slice !Source 0 !Offset @Source length? [ @Source @Offset fetch @XT invoke @Source @Offset store @Offset 1 + !Offset ] times @Source ] localize \
  "Given a pointer to an array and a quotation, execute the quotation once for each item in the array. Construct a new array from the value returned by the quotation and return a pointer to it." \
] 'map' :

[ "p-p"    [ request !Target invoke<depth?> 0 max [ @Target push ] times @Target 1 over length? subslice :p ] localize \
  "Invoke a quote and capture the results into a new array" \
] 'capture-results' :

[ "pv-n" \
  [ dup-pair !Value !Source \
    contains? \
    [ 0 !Offset #nan !Found @Source length? [ @Source @Offset fetch @Value types-match? [ eq? [ @Offset !Found ] if-true ] [ drop-pair ] if @Offset 1 + !Offset ] times @Found ] \
    [ #nan ] if \
  ] localize \
  "Given a slice and a value, return the offset the value is located at, or #nan if not found" \
] 'index-of' :

[ 'Found'  'Value'  'XT'  'Source'  'Target'  'Offset'  'localize' ] hide-functions


[ "s-f"  vm.dict<names> swap contains? "Return true if the named function exists or false otherwise" ] 'function-exists?' :

[ "s-p"  vm.dict<names> swap index-of vm.dict<slices> swap fetch "Return a pointer to the named function if it exists, or #nan otherwise" ] 'lookup-function' :

[ "p-s"  :p vm.dict<slices> over contains? [ vm.dict<slices> swap index-of vm.dict<names> swap fetch ] [ drop '' ] if "If the pointer corresponds to a named item, return the name. Otherwise return an empty string." ] 'lookup-name' :


[ "ss-"  swap dup function-exists? [ dup lookup-function swap hide-function swap : ] [ drop ] if "Change a name from s1 to s2" ] 'rename-function' :

"Functions for trimming leading and trailing whitespace off of a string. The left side trim is iterative; the right side trim is recursive."
[ "s-s" :s #0 [ dup-pair fetch :n 32 eq? [ 1 + ] dip ] while 1 - [ dup get<final-offset> 1 + ] dip swap subslice :s "Remove leading whitespace from a string" ] 'trim-left' :
[ "s-s" reverse trim-left reverse :s "Remove trailing whitespace from a string" ] 'trim-right' :
[ "s-s" trim-right trim-left "Remove leading and trailing whitespace from a string" ] 'trim' :


"Text Output Buffer"
'TOB' var
[ "v-"   &TOB push "Append a value to the TOB" ] 'to-tob' :
[ "-..." &TOB get<final-offset> [ &TOB pop ] times "Push each item in the TOB to the stack" ] 'show-tob' :
[ "-"    0 &TOB set<final-offset> "Remove all items in the TOB" ] 'clear-tob' :


"Scope"
[ 'Public'  'Private' ] ::
[ "-" vm.dict<names> !Private "Begin a lexically scoped area" ] '{' :
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
  "End a lexically scoped region, removing any headers not specified in the provided array." \
] '}' :
[ 'Public'  'Private' ] hide-functions

"Vocabularies"
[ 'with' 'without' 'vocab' '}vocab' '}}' ] {
  [ 'Vocabulary' ] ::

  [ "p-"  [ invoke : ] for-each "Add words in a vocabulary to the dictionary" ] 'with' :
  [ "p-"  [ tail hide-function ] for-each "Remove words in a vocabulary from the dictionary" ] 'without' :

  [ "ps-" \
    request-empty !Vocabulary \
    @Vocabulary swap : \
    [ dup lookup-function swap cons @Vocabulary push ] for-each \
    @Vocabulary without \
    "Create a new vocabulary" \
  ] 'vocab' :

  [ "ps-" \
    over } vocab \
    "Close a lexical scope and create a vocabulary with the exposed functions" \
  ] '}}' :
}


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
    "Executes the code quotation, preserving and restoring the contents of the variables specified." \
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
    "For each item in source1, push the item and the corresponding item from source2 to the stack. Execute the specified code. Push results into a new array, repeating until all items are exhausted. Returns the new array. This expects the code to return a single value as a result. It also assumes that both sources are the same size (or at least that the second does not contain less than the first" \
  ] 'zip' :
}


"Hashing functions"
389 'Hash-Prime' var!
[ "s-n" 0 swap [ :n xor ] for-each "Hash a string using the XOR algorithim" ] 'hash:xor' :
[ "s-n" 5381 swap [ over -5 shift + + ] for-each "Hash a string using the DJB2 algorithim" ] 'hash:djb2' :
[ :n over -6 shift + over -16 shift + swap - ] 'hash:sdbm<n>' :
[ "s-n" 0 swap [ :c swap hash:sdbm<n> ] for-each "Hash a string using the SDBM algorithim" ] 'hash:sdbm' :
[ "s-b" hash:djb2 "The preferred hash algorithim (defaults to DJB2)" ] 'chosen-hash' :
[ "s-n" chosen-hash @Hash-Prime rem "Hash a string using chosen-hash and HashPrime" ] 'hash' :
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
    "Takes a pointer to a set of quotations. Each quote in the set should consist of two other quotes: one that returns a flag, and one to be executed if the condition returns true. Executes each until one returns true, then exits." \
  ] 'when' :
}


[ 'split'  'join' ] {
  [ 'Source'  'Value'  'Target' ] ::
  [ "n-"  [ @Source 0 ] dip subslice :s ] 'extract' :
  [ "n-"  @Source swap @Value length? + over length? subslice :s !Source ] 'next-piece' :

  [ "ss-p" \
    dup length? 0 eq? \
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
    "Given a string and a delimiter, split the string into an array" \
  ] 'split' :

  [ "pv-s" \
    :s !Value \
    reverse '' [ :s + @Value + ] reduce \
    "This leaves the join value appended to the string. Remove it." \
    0 over length? @Value length? - subslice :s \
    "Given an array of values and a string, convert each value to a string and merge, using the provided string between them" \
  ] 'join' :
}

[ "s-s"  [ :n 32 128 between? ] filter :s "Remove any non-printable characters from a string" ] 'clean-string' :

[ "sss-s"  [ split ] dip join clean-string "Replace all instances of s2 in s1 with s3" ] 'replace' :


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
    "Given an array of values and a string with insertion points, construct a new string, copying the values into the insertion points." \
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
    "Given an array of values and a string with insertion points, construct a new string, copying the values into the insertion points. If the array of values is less than the number of insertion points, cycle through them again." \
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
    dup length? \
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
    "Lookup the stack comment and description (if existing) for a named item" \
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
    "Return an array with the items currently on the stack" \
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


[ "-n"   2.71828182846 "Mathmatical constant for Euler's Number" ] 'E' :
[ "-n"   3.14159265359 "Mathmatical constant for PI" ] 'PI' :
[ "n-n"  E log<n> "Return the base E logarithim of a number" ] 'log' :
[ "n-n"  10 log<n> "Return the base 10 logarithim of a number" ] 'log10' :
