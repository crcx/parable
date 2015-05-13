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

...TODO...

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

...TODO...

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

...TODO...

    string string -- number

This is a primitive corresponding to a byte code.

## subslice

...TODO...

    pointer number:start number:end -- pointer:result

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

...TODO...

    string --

This is a primitive corresponding to a byte code.

## sin

...TODO...

    number -- number

This is a primitive corresponding to a byte code.

## cos

...TODO...

    number -- number

This is a primitive corresponding to a byte code.

## tan

...TODO...

    number -- number

This is a primitive corresponding to a byte code.

## asin

...TODO...

    number -- number

This is a primitive corresponding to a byte code.

## acos

...TODO...

    number -- number

This is a primitive corresponding to a byte code.

## atan

...TODO...

    number -- number

## atan2

...TODO...

[ "n-n"    `1006 ] 'atan2' define

This is a primitive corresponding to a byte code.

## NUMBER

Constant; value for the NUMBER data type.

    -- number

## STRING

Constant; value for the STRING data type.

    -- number

## CHARACTER

Constant; value for the CHARACTER data type.

    -- number

## POINTER

Constant; value for the POINTER data type.

    -- number

## FLAG

Constant; value for the FLAG data type.

    -- number

## bi*

...TODO...

    value:a value:b pointer:a pointer:b -- ?

## tri*

...TODO...

    value:a value:b value:c pointer:a pointer:b pointer:c -- ?

## bi@

...TODO...

    value:a value:b pointer -- ?

## tri@

...TODO...

    value:a value:b value:c pointer -- ?

## dup-pair

...TODO...

[ "vV-vVvV"  over over ] 'dup-pair' define

## drop-pair

Drop two values off the stack.

    value value --

## true

Return a true flag.

    -- flag

## false

Return a false flag.

    -- flag

## not

...TODO...

    flag -- flag

## if-true

Execute the code at pointer if flag is true.

    flag pointer --

## if-false

Execute the code at pointer if flag is false.

    flag pointer --

## zero?

Returns **true** if the number is equal to zero, or **false** if not.

    number -- flag

## true?

Returns **true** if the value can be converted to a **true** flag, or **false** otherwise.

    value -- flag

## false

Returns **true** if the value can be converted to a **false** flag, or **false** otherwise.

    value -- flag

## even?

...TODO...

    number -- flag

## odd?

...TODO...

    number -- flag

## negative?

...TODO...

    number -- flag

## positive?

...TODO...

    number -- flag

## if-character

Execute the code in pointer if value is a CHARACTER

    value pointer --

## if-string

Execute the code in pointer if value is a STRING

    value pointer --

## if-number

Execute the code in pointer if value is a NUMBER

    value pointer --

## if-pointer

Execute the code in pointer if value is a POINTER

    value pointer --

## if-flag

Execute the code in pointer if value is a FLAG

    value pointer --


## between?

...TODO...

    number number number -- flag

## variable

...TODO...

    string --

## variable!

...TODO...

    value string --

## @

...TODO...

    pointer -- number

## !

...TODO...

    value pointer --

## on

...TODO...

    pointer --

## off

...TODO...

    pointer --

## increment

...TODO...

    pointer --

## decrement

...TODO...

    pointer --

## zero-out

...TODO...

    pointer --

## preserve

...TODO...

    pointer pointer --

## expand-range

...TODO...

    number:lower number:upper -- ...

## sum-range

...TODO...

    ... number -- number

## slice-length

...TODO...

    pointer -- pointer number

## adjust-slice-length

...TODO...

    number pointer --

## invoke-and-count-items-returned

...TODO...

    pointer -- ? number

## invoke-and-count-items-returned-with-adjustment

    pointer number -- ? number

## drop-multiple

...TODO...

    ... n -- ?

## hide-functions

...TODO...

    pointer --

## rename-function

...TODO...

    string string --

## variables

...TODO...

    pointer --

## string-contains?

...TODO...

    value string -- flag

## digit?

...TODO...

    value -- flag

## symbol?

...TODO...

    value -- flag

## letter?

...TODO...

    value -- flag

## alphanumeric?

...TODO...

    value -- flag

## consonant?

...TODO...

    value -- flag

## vowel?

...TODO...

    value -- flag

## lowercase?

...TODO...

    value -- flag

## uppercase?

...TODO...

    value -- flag

## build-string

...TODO...

    pointer -- string

## trim-left

...TODO...

    string -- string

## trim-right

...TODO...

    string -- string

## trim

...TODO...

    string -- string

## abs

...TODO...

    number -- number

## min

...TODO...

    number number -- number

## max

...TODO...

    number number -- number

## factorial

...TODO...

    number -- number

## *current-buffer*

Variable

    -- pointer

## *buffer-offset*

Variable

    -- pointer

## current-buffer

[ "-p"     &*current-buffer* @ :p ] 'current-buffer' define

## buffer-position

[ "-pn"    current-buffer &*buffer-offset* @ ] 'buffer-position' define

## buffer-advance

[ "-"      &*buffer-offset* increment ] 'buffer-advance' define

## buffer-retreat

[ "-"      &*buffer-offset* decrement ] 'buffer-retreat' define

## buffer-store-current

[ "n-"     buffer-position store ] 'buffer-store-current' define

## buffer-fetch-current

[ "-n"     buffer-position fetch ] 'buffer-fetch-current' define

## buffer-store

[ "v-"     buffer-position store buffer-advance #0 buffer-position store ] 'buffer-store' define

## buffer-fetch

[ "-n"     buffer-position fetch buffer-advance ] 'buffer-fetch' define

## buffer-store-retreat

[ "v-"     buffer-retreat buffer-position store ] 'buffer-store-retreat' define

## buffer-fetch-retreat

[ "-n"     buffer-retreat buffer-position fetch ] 'buffer-fetch-retreat' define

## set-buffer

[ "p-"     &*current-buffer* ! &*buffer-offset* zero-out ] 'set-buffer' define

## buffer-store-items

[ "...n-"  [ buffer-store ] repeat ] 'buffer-store-items' define

## new-buffer

[ "-"      request set-buffer ] 'new-buffer' define

## preserve-buffer

[ "p-"     &*current-buffer* @ [ &*buffer-offset* @ [ invoke ] dip &*buffer-offset* ! ] dip &*current-buffer* ! ] 'preserve-buffer' define

## named-buffer

[ "s-"     request [ swap define ] sip set-buffer ] 'named-buffer' define

## array-push

[ "np-"    dup get-buffer-length over [ store ] dip #1 swap adjust-buffer-length ] 'array-push' define

## array-pop

[ "p-n"    [ #-1 swap adjust-buffer-length ] sip dup get-buffer-length fetch ] 'array-pop' define

## array-length

[ "p-n"    get-buffer-length ] 'array-length' define

## array-reduce

[ "pnp-n"  &filter ! over array-length [ over array-pop &filter @ invoke ] repeat nip ] 'array-reduce' define

## array-from-quote<in-stack-order>

[ "p-p"    [ new-buffer invoke-and-count-items-returned buffer-store-items &*current-buffer* @ ] preserve-buffer :p ] 'array-from-quote<in-stack-order>' define

## array-reverse

[ "p-p"    request [ copy ] sip &source ! [ #0 &source @ array-length [ &source @ over fetch swap #1 + ] repeat drop ] 
array-from-quote<in-stack-order> ] 'array-reverse' define

## array-from-quote

[ "p-p"    array-from-quote<in-stack-order> array-reverse ] 'array-from-quote' define

## for-each

[ "pp-?"   swap array-reverse buffer-length [ dup-pair #1 - fetch swap [ swap ] dip [ [ over invoke ] dip ] dip #1 - dup #0 > ] while-true drop-pair drop ] 'for-each' define

## array-contains

[ "pv-f"   swap needs-remap? [ swap dup set-buffer array-length #0 swap [ over buffer-fetch array<remap> = or ] repeat ] preserve-buffer nip :f ] 'array-contains?' define

## array-filter

[ "pp-p"   prepare [ &source @ array-pop dup &filter @ invoke [ &results array-push ] [ drop ] if ] repeat &results request [ copy ] sip ] 'array-filter' define

## array-map

[ "pp-p"   prepare [ &source @ array-pop &filter @ invoke &results array-push ] repeat &results request [ copy ] sip ] 'array-map' define

## array-compare

[ "pp-f"   dup-pair [ array-length ] bi@ = [ dup array-length true swap [ [ dup-pair [ array-pop ] bi@ = ] dip and ] repeat [ drop-pair ] dip :f ] [ drop-pair false ] if ] 'array-compare' define

## array-to-string

[ "pointer:array number:type - string"  #100 / #1 - &*array:conversions* swap fetch :p invoke ] 'array-to-string' define

## convert-with-base

[ "sn-n" &*conversion:base* ! #0 swap [ :c conversion:to-digit swap conversion:accumulate ] for-each ] 'convert-with-base' define

## convert-from-binary

[ "s-n"  #2 convert-with-base ] 'convert-from-binary' define

## convert-from-octal

[ "s-n"  #8 convert-with-base ] 'convert-from-octal' define

## convert-from-decimal

[ "s-n"  #10 convert-with-base ] 'convert-from-decimal' define

## convert-from-hexadecimal

[ "s-n"  #16 convert-with-base ] 'convert-from-hexadecimal' define

## curry

...TODO...

[ [ request set-buffer swap curry:compile-value curry:compile-call &*current-buffer* @ :p ] preserve-buffer ] 'curry' define

## to

...TODO...

    --

## value

...TODO...

    string --

## value!

...TODO...

    value string --

## values

...TODO...

    pointer --

## array-to-quote

...TODO...

    pointer number -- string

## array-index-of

...TODO...

    value pointer -- number

## show-tob

...TODO...

    -- ...

## clear-tob

...TODO...

    --

## .

...TODO...

    value --

## hash:djb2

...TODO...

    string -- number

## hash:sdbm

...TODO...

    string -- number

## hash:lrc

...TODO...

    string -- number

## hash:xor

...TODO...

    string -- number

## chosen-hash

...TODO...

    string -- number

## hash-prime

Constant, prime number for hash functionality

    -- number

## hash

...TODO...

    string -- number

## math:pi

Constant, value of PI (3.14159...)

    -- number

## math:tau

Constant, value of ... (...)

    -- number

[ #6.283185307 ] 'math:tau' define

## math:e


Constant, value of ... (...)

    -- number

[ #2.718281828 ] 'math:e' define

## math:golden-ration

Constant, value of ... (...)

    -- number

[ #1.618033988 ] 'math:golden-ratio' define

## math:euler-mascheroni

Constant, value of ... (...)

    -- number

[ #0.577215664 ] 'math:euler-mascheroni' define

## math:pythagora

[ #1.414213562 ] 'math:pythagora' define

Constant, value of ... (...)

    -- number

## math:inverse-golden-ratio

Constant, value of ... (...)

    -- number

[ #0.618033988 ] 'math:inverse-golden-ratio' define

## math:silver-ration/mean

Constant, value of ... (...)

    -- number

[ #2.414213562 ] 'math:silver-ratio/mean' define

## time:seconds/minute

Constant, value of ... (...)

    -- number

[ #60 ] 'time:seconds/minute' define

## time:minutes/hour

Constant, value of ... (...)

    -- number

[ #60 ] 'time:minutes/hour' define

## time:hours/day

Constant, value of ... (...)

    -- number

[ #24 ] 'time:hours/day' define

## time:days/week

Constant, value of ... (...)

    -- number

[ #7 ] 'time:days/week' define

## time:weeks/year

Constant, value of ... (...)

    -- number

[ #52 ] 'time:weeks/year' define

## time:months/year

Constant, value of ... (...)

    -- number

[ #12 ] 'time:months/year' define

## time:days/year

Constant, value of ... (...)

    -- number
[ #365 ] 'time:days/year' define

## time:days/julian-year

Constant, value of ... (...)

    -- number

[ #365.25 ] 'time:days/julian-year' define

## time:greagorian/year

Constant, value of ... (...)

    -- number

[ #365.2425 ] 'time:days/gregorian-year' define
