## :b

    value - bytecode

## :n

    value - number

## :s

    value - string

## :c

    value - character

## :p

    value - pointer

## :f

    value - flag

## :call

    value - function-call

## set-type

    value number:type - value

## type?

    value - value number:type

## +

    value value - value

## -

    number number - number

## *

    number number - number

## /

    number number - number

## rem

    number number - number

## floor

    number - number

## ^

    number number - number

## log

    number - number

## log10

    number - number

## log<n>

    number number - number

## shift

    number number - number

## and

    number number - number

## or

    number number - number

## xor

    number number - number

## random

    - number

## sqrt

    number - number

## <

    number number - flag

## >

    number number - flag

## <=

    number number - flag

## >=

    number number - flag

## =

    value value - flag

## <>

    value value - flag

## if

    flag quote:true quote:false -

## while-true

    quote -

## while-false

    quote -

## times

    number quote -

## invoke

    quote -

## dip

    value quote - value

## sip

    value quote - value

## bi

    vpp-?

## tri

    vppp-?

## copy

    pointer:source pointer:dest -

## fetch

    pointer number:offset - value

## store

    value pointer number:offset -

## request

    - pointer

## release

    pointer -

## collect-garbage

    -
## get-last-index

    pointer - number

## set-last-index

    number pointer -

## set-stored-type

    number pointer -

## get-stored-type

    pointer - number

## dup

    value - value value

## drop

    value -

## swap

    value:a value:b - value:b value:a

## over

    value:a value:b - value:a value:b value:a

## tuck

    value:a value:b - value:b value:a value:b

## nip

    value:a value:b - value:b

## depth

    - number

## reset

    ... -

## function-exists?

    string - flag

## lookup-functiomn

    string - pointer

## hide-function

    string -

## find

    string string - number

## subslice

    pointer number number - pointer

## numeric?

    string - flag

## reverse

    pointer - pointer

## to-lowercase

    value - value

## to-uppercase

    value - value

## report-error

    string -

## sin

    number - number

## cos

    number - number

## tan

    number - number

## asin

    number - number

## acos

    number - number

## atan

    number - number

## atan2

    number - number

## NUMBER

    - number

## STRING

    - number

## CHARACTER

    - number

## POINTER

    - number

## FLAG

    - number

## BYTECODE

    - number

## COMMENT

    - number

## FUNCTION-CALL

    - number

## dup-pair

    value:a value:v - value:a value:b value:a value:b

## drop-pair

    value value -

## drop-multiple

    ? number -

## invoke<depth?>

    quote - ... number

## last-index?

    pointer - pointer number

## slice-length?

    pointer - pointer number

## adjust-slice-length

    number pointer -

## duplicate-slice

    pointer - pointer

## length?

    pointer - number


## variable

    string -

## @

    pointer - value

## !

    value pointer -

## variable!

    value string -

## off

    pointer -

## on

    pointer -

## increment

    pointer -

## decrement

    pointer -

## zero-out

    pointer -

## preserve

    pointer pointer -


## max

    number number - number

## min

    number number - number

## abs

    number - number

## bi*

    value value pointer pointer - ?

## tri*

    value value value pointer pointer pointer - ?

## bi@

    value value pointer - ?

## tri@

    value value value pointer - ?

## true

    - flag

## false

    - flag

## not

    flag - flag

## if-true

    flag quote -

## if-false

    flag quote -

## zero?

    number - flag

## true?

    value - flag

## false?

    value - flag

## even?

    number - flag

## odd?

    number - flag

## negative?

    number - flag

## positive?

    number - flag

## if-character

    value quote -

## if-string

    value quote -

## if-number

    value quote -

## if-pointer

    value quote -

## if-flag

    value quote -

## between?

    number number number - flag

## types-match?

    value value - value value flag

## expand-range

    number number - ...

## sum-range

    ... number - number

## hide-functions

    quote -

## rename-function

    string string -

## variables

    quote -

## string-contains?

    value string - flag

## digit?

    value - flag

## symbol?

    value - flag

## letter?

    value - flag

## alphanumeric?

    value - flag

## consonant?

    value - flag

## vowel?

    value - flag

## lowercase?

    value - flag

## uppercase?

    value - flag

## build-string

    quote - string

## trim-left

    string - string

## trim-right

    string - string

## trim

    string - string

## *CURRENT-BUFFER

    N/A - Variable

## *BUFFER-OFFSET

    N/A - Variable

## current-buffer

    - pointer

## buffer-position

    - pointer number

## buffer-advance

    -

## buffer-retreat

    -

## buffer-store-current

    value -

## buffer-fetch-current

    - value

## buffer-store

    value -

## buffer-fetch

    - value

## buffer-store-retreat

    value -

## buffer-fetch-retreat

    - value

## set-buffer

    pointer -

## buffer-store-items

    ... number -

## new-buffer

    -

## preserve-buffer

    pointer -

## named-buffer

    string -

## cons

    value value - pointer

## curry

    value quote - quote

## to

    -

## (value-handler)

    ? pointer -

## value

    string -

## value!

    value string -

## values

    quote -

## first

    pointer - value

## rest

    pointer - pointer

## push

    value pointer -

## pop

    pointer - value

## reduce

    pointer value pointer

## for-each

    pointer pointer - ?

## contains?

    pointer value - flag

## filter

    pointer pointer - pointer

## map

    pointer pointer - pointer

## capture-results

    pointer - pointer

## index-of

    pointer value - number

## *TOB

    N/A - Variable

## .

    value -

## show-tob

    - ...

## clear-tob

    -

## *Hash-Prime

    - value

## hash:xor

    string - number

## hash:djb2

    string - number

## hash:sdbm

    string - number

## chosen-hash

    string - number

## hash

    string - number

## when

    quote -

"when: a conditional combinator"
"[ [ [ condition ] [ code to execute if true ] ] \"
"  [ [ condition ] [ code to execute if true ] ] \"
"  [ [ true ]      [ default case ] ] \"
"] when"


## apropos

    string - string
