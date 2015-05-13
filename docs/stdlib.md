# Overview

Upon startup, the parable language consists of one function and the functionality
exposed by the parser. The initial function is *define*. The standard libary is
provided to make Parable into a useful language.

# The Functions

## define

*define* is used to attach a name to a pointer.

    pointer string --

This is a primitive corresponding to a byte code.

## :n

Convert a value to a number.

    value -- number

This is a primitive corresponding to a byte code.

## :s

Convert a value to a string.

    value -- string

This is a primitive corresponding to a byte code.

## :c

Convert a value to a character.

    value -- character

This is a primitive corresponding to a byte code.

## :p

Convert a value to a pointer.

    value -- pointer

This is a primitive corresponding to a byte code.

## :f

Convert a value to a flag.

    value -- flag

This is a primitive corresponding to a byte code.

## type?

Return a number indicating the type of the top value on the stack. This will
correspond to *NUMBER*, *CHARACTER*, *STRING*, *POINTER*, or *FLAG*.

    value -- value number

This is a primitive corresponding to a byte code.

## +

Add A to B, returning the result.

    number:a number:b -- number:result

This is a primitive corresponding to a byte code.

## -

Subtract B from A, returning the result.

    number:a number:b -- number:result

This is a primitive corresponding to a byte code.

## *

Multiply A by B, returning a result.

    number:a number:b -- number:result

This is a primitive corresponding to a byte code.

## /

Divide A by B, returning the result.

    number:a number:b -- number:result

This is a primitive corresponding to a byte code.

## rem

Divide A by B, returning the remainder.

    number:a number:b -- number:result

This is a primitive corresponding to a byte code.

## floor

Return the largest integer value less than or equal to number.

    number -- number

This is a primitive corresponding to a byte code.

## ^

    number:a number:b -- number:result

This is a primitive corresponding to a byte code.

## log

Return the natural logarithm of number (to base e).

    number -- number

This is a primitive corresponding to a byte code.

## log10

Return the base 10 logarithm of number.

    number -- number

This is a primitive corresponding to a byte code.

## log<n>

Return the logarithm of a to the given base, calculated as log(a)/log(b)

    number:a number:b -- number:result

This is a primitive corresponding to a byte code.

## shift

    number:a number:b -- number:result

This is a primitive corresponding to a byte code.

## and

Perform a bitwise AND operation on the two values provided.

    number:a number:b -- number:result

This is a primitive corresponding to a byte code.

## or

Perform a bitwise OR operation on the two values provided.

    number:a number:b -- number:result

This is a primitive corresponding to a byte code.

## xor

Perform a bitwise XOR operation on the two values provided.

    number:a number:b -- number:result

This is a primitive corresponding to a byte code.

## random

Return a random number between zero and one.

    -- number

This is a primitive corresponding to a byte code.

## sqrt

Calculate and return the square root of a number.

    number -- number

This is a primitive corresponding to a byte code.

## <

Compare two values for less than. Returns a flag.

    number:a number:b -- flag

This is a primitive corresponding to a byte code.

## >

Compare two values for greater than. Returns a flag.

    number:a number:b -- flag

This is a primitive corresponding to a byte code.

# <=

Compare two values for less than or equal to. Returns a flag.

    number:a number:b -- flag

This is a primitive corresponding to a byte code.

## >=

Compare two values for greater than or equal to. Returns a flag.

    number:a number:b -- flag

This is a primitive corresponding to a byte code.

## =

Compare two values for equality. Returns a flag.

    value value -- flag

This is a primitive corresponding to a byte code.

## <>

Compare two values for inequality. Returns a flag.

    value value -- flag

This is a primitive corresponding to a byte code.

## if

If flag is true, execute pointer:true. Otherwise, execute pointer:false.

    flag pointer:true pointer:false --

This is a primitive corresponding to a byte code.

## while-true

Execute the code in pointer repeatedly, until the code returns a flag of *false*.
The code must return a flag after each execution cycle.

    pointer --

This is a primitive corresponding to a byte code.

## while-false

Execute the code in pointer repeatedly, until the code returns a flag of *true*.
The code must return a flag after each execution cycle.

    pointer --

This is a primitive corresponding to a byte code.

## repeat

Execute the code at pointer the specified number of times.

    number pointer --

This is a primitive corresponding to a byte code.

## invoke

Execute the code at pointer.

    pointer --

This is a primitive corresponding to a byte code.

## dip

Remove value from the stack, and execute pointer. After execution is complete,
restore the value to the stack.

    value pointer -- value

This is a primitive corresponding to a byte code.

## sip

Execute pointer with a copy of value on the stack. Restores value to the stack
after execution completes.

    value pointer -- value

This is a primitive corresponding to a byte code.

## bi

Apply each quotation to a copy of value.

    value pointer:a pointer:b -- ?

This is a primitive corresponding to a byte code.

## tri

Apply each quotation to a copy of value.

    value pointer:a pointer:b pointer:c -- ?

This is a primitive corresponding to a byte code.

## copy

Copy the contents of the source slice into the destination slice.

    pointer:source pointer:dest --

This is a primitive corresponding to a byte code.

## fetch

Fetch a value from the specified offset in a slice.

    pointer number:offset -- number

This is a primitive corresponding to a byte code.

## store

Store a value into a slice at a specified offset.

    value pointer number:offset --

This is a primitive corresponding to a byte code.

## request

Allocate a new slice and return a pointer to it.

    -- pointer

This is a primitive corresponding to a byte code.

## release

Release an allocated slice. This will be reclaimed by the garbage collector.

    pointer --

This is a primitive corresponding to a byte code.

## collect-garbage

Perform a garbage collection cycle.

    --

This is a primitive corresponding to a byte code.

## get-buffer-length

Return the length of a slice.

    pointer -- number

This is a primitive corresponding to a byte code.

## set-buffer-length

Set the length of a slice to the specified size.

    number pointer --

This is a primitive corresponding to a byte code.

## dup

Duplicate the top value on the stack.

    value -- value value

This is a primitive corresponding to a byte code.

## drop

Remove a value from the stack.

    value --

This is a primitive corresponding to a byte code.

## swap

Switch the positions of the top two items on the stack.

    value:a value:b -- value:b value:a

This is a primitive corresponding to a byte code.

## over

Put a copy of the second item on the stack over the first item.

    value:a value:b -- value:a value:b value:a

This is a primitive corresponding to a byte code.

## tuck

Put a copy of the first item on the stack under the second item.

    value:a value:b -- value:b value:a value:b

This is a primitive corresponding to a byte code.

## nip

Remove the second item on the stack.

    value:a value:b -- value:b

This is a primitive corresponding to a byte code.

## depth

Return the number of items on the stack.

    -- number

This is a primitive corresponding to a byte code.

## reset

Remove all items from the stack.

    ... --

This is a primitive corresponding to a byte code.

## function-exists?

Given a string containing a function name, returns *true* if the function 
exists or *false* if it does not.

    string -- flag

This is a primitive corresponding to a byte code.

## lookup-function

Given a string, return a pointer to the or data under that name. If the function does not exist, returns a pointer to -1 (a guaranteed invalid slice).

    string -- pointer

This is a primitive corresponding to a byte code.

## hide-function

Given a string, remove the header corresponding to the name. This does not remove the definition, just disassociates the name from the slice.

    string --

This is a primitive corresponding to a byte code.

## find

[ "ss-n"   `700 ] 'find' define

This is a primitive corresponding to a byte code.

## subslice

[ "pnn-p"  `701 ] 'subslice' define

This is a primitive corresponding to a byte code.

## numeric?

Given a string, returns **true** if the string is a valid number, or **false** otherwise.

    string -- flag

This is a primitive corresponding to a byte code.

## to-uppercase

[ "v-v"    `800 ] 'to-lowercase' define

This is a primitive corresponding to a byte code.

## to-lowercase

[ "v-v"    `801 ] 'to-uppercase' define

This is a primitive corresponding to a byte code.

## report-error

    string --

This is a primitive corresponding to a byte code.

## sin

    number -- number

This is a primitive corresponding to a byte code.

## cos

    number -- number

This is a primitive corresponding to a byte code.

## tan

    number -- number

This is a primitive corresponding to a byte code.

## asin

    number -- number

This is a primitive corresponding to a byte code.

## acos

    number -- number

This is a primitive corresponding to a byte code.

## atan

    number -- number

## atan2

[ "n-n"    `1006 ] 'atan2' define

This is a primitive corresponding to a byte code.

## NUMBER

    -- number

## STRING

    -- number

## CHARACTER

    -- number

## POINTER

    -- number

## FLAG

    -- number

## bi*

    value:a value:b pointer:a pointer:b -- ?

## tri*

    value:a value:b value:c pointer:a pointer:b pointer:c -- ?

## bi@

    value:a value:b pointer -- ?

## tri@

    value:a value:b value:c pointer -- ?

## dup-pair

[ "vV-vVvV"  over over ] 'dup-pair' define

## drop-pair

Drop two values off the stack.

    value value --

----

"Expand the basic conditionals into a more useful set."

## true

    -- flag

## false

    -- flag

## not

    flag -- flag

## if-true

    flag pointer --

## if-false

    flag pointer --

## zero?

    number -- flag

## true?

    value -- flag

## false

    value -- flag

## even?

    number -- flag

## odd?

    number -- flag

## negative?

    number -- flag

## positive?

    number -- flag

[ "cp-"  [ type? CHARACTER = ] dip if-true ] 'if-character' define
[ "sp-"  [ type? STRING = ] dip if-true ] 'if-string' define
[ "np-"  [ type? NUMBER = ] dip if-true ] 'if-number' define
[ "pp-"  [ type? POINTER = ] dip if-true ] 'if-pointer' define
[ "fp-"  [ type? FLAG = ] dip if-true ] 'if-flag' define
[ "nnn-f"  [ [ :n ] bi@ ] dip :n dup-pair > [ swap ] if-true [ over ] dip <= [ >= ] dip and :f ] 'between?' define

"Simple variables are just named slices, with functions to access the first element. They're useful for holding single values, but don't track data types."
[ "s-"   request swap define ] 'variable' define
[ "vs-"  request [ swap define ] sip #0 store ] 'variable!' define
[ "p-n"  #0 fetch ] '@' define
[ "vp-"  #0 store ] '!' define
[ "p-"   #0 swap ! ] 'off' define
[ "p-"   #-1 swap ! ] 'on' define
[ "p-"   [ @ #1 + ] sip ! ] 'increment' define
[ "p-"   [ @ #1 - ] sip ! ] 'decrement' define
[ "p-"   request swap copy ] 'zero-out' define
[ "pp-"  swap request dup-pair copy swap [ [ invoke ] dip ] dip copy ] 'preserve' define

[ "nn-..."  dup-pair < [ [ [ dup #1 + ] dip dup-pair = ] while-false ] [ [ [ dup #1 - ] dip dup-pair = ] while-false ] if drop ] 'expand-range' define
[ "...n-"   #1 - [ + ] repeat ] 'sum-range' define

[ "p-pn"  dup get-buffer-length ] 'buffer-length' define
[ "np-"   [ get-buffer-length + ] sip set-buffer-length ] 'adjust-buffer-length' define
[ "p-?n"  depth [ invoke ] dip depth swap - ] 'invoke-and-count-items-returned' define
[ "pn-?n" [ depth [ invoke ] dip depth swap - ] + ] 'invoke-and-count-items-returned-with-adjustment' define
[ "?n-"   [ drop ] repeat ] 'drop-multiple' define

[ "p-"   invoke-and-count-items-returned [ hide-function ] repeat ] 'hide-functions' define
[ "ss-"  swap dup function-exists? [ dup lookup-function swap hide-function swap define ] [ drop ] if ] 'rename-function' define
[ "p-"   invoke-and-count-items-returned [ variable ] repeat ] 'variables' define

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

## trim-left
    string -- string

## trim-right

    string -- string

## trim

    string -- string

## abs

    number -- number

## min

    number number -- number

## max

    number number -- number

## factorial

    number -- number

[ '*current-buffer*'  '*buffer-offset*' ] variables
[ "-p"     &*current-buffer* @ :p ] 'current-buffer' define
[ "-pn"    current-buffer &*buffer-offset* @ ] 'buffer-position' define
[ "-"      &*buffer-offset* increment ] 'buffer-advance' define
[ "-"      &*buffer-offset* decrement ] 'buffer-retreat' define
[ "n-"     buffer-position store ] 'buffer-store-current' define
[ "-n"     buffer-position fetch ] 'buffer-fetch-current' define
[ "v-"     buffer-position store buffer-advance #0 buffer-position store ] 'buffer-store' define
[ "-n"     buffer-position fetch buffer-advance ] 'buffer-fetch' define
[ "v-"     buffer-retreat buffer-position store ] 'buffer-store-retreat' define
[ "-n"     buffer-retreat buffer-position fetch ] 'buffer-fetch-retreat' define
[ "p-"     &*current-buffer* ! &*buffer-offset* zero-out ] 'set-buffer' define
[ "...n-"  [ buffer-store ] repeat ] 'buffer-store-items' define
[ "-"      request set-buffer ] 'new-buffer' define
[ "p-"     &*current-buffer* @ [ &*buffer-offset* @ [ invoke ] dip &*buffer-offset* ! ] dip &*current-buffer* ! ] 'preserve-buffer' define
[ "s-"     request [ swap define ] sip set-buffer ] 'named-buffer' define


[ "np-"    dup get-buffer-length over [ store ] dip #1 swap adjust-buffer-length ] 'array-push' define
[ "p-n"    [ #-1 swap adjust-buffer-length ] sip dup get-buffer-length fetch ] 'array-pop' define
[ "p-n"    get-buffer-length ] 'array-length' define
[ "pnp-n"  &filter ! over array-length [ over array-pop &filter @ invoke ] repeat nip ] 'array-reduce' define
[ "p-p"    [ new-buffer invoke-and-count-items-returned buffer-store-items &*current-buffer* @ ] preserve-buffer :p ] 'array-from-quote<in-stack-order>' define
[ "p-p"    request [ copy ] sip &source ! [ #0 &source @ array-length [ &source @ over fetch swap #1 + ] repeat drop ] array-from-quote<in-stack-order> ] 'array-reverse' define
[ "p-p"    array-from-quote<in-stack-order> array-reverse ] 'array-from-quote' define
[ "pp-?"   swap array-reverse buffer-length [ dup-pair #1 - fetch swap [ swap ] dip [ [ over invoke ] dip ] dip #1 - dup #0 > ] while-true drop-pair drop ] 'for-each' define

[ "pv-f"   swap needs-remap? [ swap dup set-buffer array-length #0 swap [ over buffer-fetch array<remap> = or ] repeat ] preserve-buffer nip :f ] 'array-contains?' define

[ "pp-p"   prepare [ &source @ array-pop dup &filter @ invoke [ &results array-push ] [ drop ] if ] repeat &results request [ copy ] sip ] 'array-filter' define
[ "pp-p"   prepare [ &source @ array-pop &filter @ invoke &results array-push ] repeat &results request [ copy ] sip ] 'array-map' define
[ "pp-f"   dup-pair [ array-length ] bi@ = [ dup array-length true swap [ [ dup-pair [ array-pop ] bi@ = ] dip and ] repeat [ drop-pair ] dip :f ] [ drop-pair false ] if ] 'array-compare' define

[ "pointer:array number:type - string"  #100 / #1 - &*array:conversions* swap fetch :p invoke ] 'array-to-string' define

[ "sn-n" &*conversion:base* ! #0 swap [ :c conversion:to-digit swap conversion:accumulate ] for-each ] 'convert-with-base' define
[ "s-n"  #2 convert-with-base ] 'convert-from-binary' define
[ "s-n"  #8 convert-with-base ] 'convert-from-octal' define
[ "s-n"  #10 convert-with-base ] 'convert-from-decimal' define
[ "s-n"  #16 convert-with-base ] 'convert-from-hexadecimal' define

[ [ request set-buffer swap curry:compile-value curry:compile-call &*current-buffer* @ :p ] preserve-buffer ] 'curry' define

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
[ "s-" request #2 over set-buffer-length [ value-handler ] curry swap define ] 'value' define
[ "ns-" [ value ] sip to lookup-function invoke ] 'value!' define
[ "p-" array-from-quote #0 [ :p :s value ] array-reduce drop ] 'values' define
[ '*types*'  '*state*'  'restore-stored-type'  'preserve-type'  'restore-type'  'value-handler' ] hide-functions

"More Arrays"
'reconstruct' named-buffer
[ ] buffer-store
[ "number"    #100 buffer-store buffer-store ] buffer-store
[ "string"    #101 buffer-store buffer-store ] buffer-store
[ "character" #102 buffer-store buffer-store ] buffer-store
[ "pointer"   #103 buffer-store buffer-store ] buffer-store
[ "flag"      #100 buffer-store buffer-store #114 buffer-store ] buffer-store
[ #100 / &reconstruct swap fetch invoke ] 'compile-value' define

[ 'data' 'types' ] values
[ to types to data ] 'prepare' define
[ #399 buffer-store &*current-buffer* @ :p ] 'terminate' define
[ types over fetch [ data over fetch ] dip compile-value ] 'process' define
[ "pn-s" prepare new-buffer #0 data array-length [ process #1 + ] repeat drop terminate ] 'array-to-quote' define
[ 'reconstruct' 'compile-value' 'data' 'types' 'prepare' 'extract' 'terminate' ] hide-functions

[ 'source' 'v' 'i' 'idx' ] values
[ type? STRING = [ [ :p :s ] dip ] [ :n ] if ] 'resolve-types' define
[ "vp-n"  to source to v #0 to i #-1 to idx source array-length [ source i fetch v resolve-types = [ i to idx ] if-true i #1 + to i ] repeat idx ] 'array-index-of' define
[ 'source'  'v'  'i'  'idx'  'resolve-types' ] hide-functions


"Text Output Buffer"
'TOB' variable
[ &TOB array-push ] 'append-value' define
[ "-..." &TOB array-length [ &TOB array-pop :p :s ] repeat ] 'show-tob' define
[ "-" #0 &TOB set-buffer-length ] 'clear-tob' define

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
