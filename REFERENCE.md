## :b

    value - bytecode

Primitive. Convert value on stack to a bytecode.

## :n

    value - number

Primitive. Convert value on stack to a number.

## :s

    value - string

Primitive. Convert value on stack to a string.

## :c

    value - character

Primitive. Convert value on stack to a character.

## :p

    value - pointer

Primitive. Convert value on stack to a pointer.

## :f

    value - flag

Primitive. Convert value on stack to a flag.

## :call

    value - function-call

Primitive. Convert value on stack to a function call.

## set-type

    value number:type - value

Primitive. Set the value to a specific type.

## type?

    value - value number:type

Primitive. Given a value, return the value and its corresponding type.

## +

    value value - value

Primitive.

For numbers, add them and return the results.

For strings, append the second string to the first one and return the new string.

## -

    number number - number

Primitive. Subtract the second number from the first one, returning the result.

## *

    number number - number

Primitive. Multiply two numbers and return the result.

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

Primitive. Return a random number.

## sqrt

    number - number

Primitive. Return the square root of a number.

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

Primitive. Execute the specified quotation the specified number of times.

## invoke

    quote -

Primitive. Execute the specified quotation.

## dip

    value quote - value

Primitive. Remove value from the stack and execute the quotation. When execution completes restore the value.

## sip

    value quote - value

Primitive. Execute the quotation. When execution completes, restore a copy of the value to the stack.

## bi

    vpp-?

## tri

    vppp-?

## copy

    pointer:source pointer:dest -

Primitive. Copy the content of the first slice to the second one.

## fetch

    pointer number:offset - value

Primitive. Fetch a value stored in a slice.

## store

    value pointer number:offset -

Primitive. Store a value into a slice.

## request

    - pointer

Primitive. Request a new memory slice. Returns a pointer to it.

## release

    pointer -

Primitive. Tell Parable that a slice is no longer in use.

## collect-garbage

    -

Primitive. Search memory for unused slices and recover them.

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

Primitive. Remove a value from the stack.

## swap

    value:a value:b - value:b value:a

Primitive. Switch the positions of the top two items on the stack.

## over

    value:a value:b - value:a value:b value:a

## tuck

    value:a value:b - value:b value:a value:b

## nip

    value:a value:b - value:b

Primitive. Remove the second value on the stack.

## depth

    - number

Primitive. Return the number of items on the stack.

## reset

    ... -

Primitive. Remove all values from the stack.

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

Primitive. If string can be converted to a number using **:n** return **true**. Otherwise return **false**.

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

Constant. Type for numbers.

## STRING

    - number

Constant. Type for strings.

## CHARACTER

    - number

Constant. Type for characters.

## POINTER

    - number

Constant. Type for pointers.

## FLAG

    - number

Constant. Type for Boolean flag.

## BYTECODE

    - number

Constant. Type for bytecides.

## COMMENT

    - number

Constant. Type for comments.


## FUNCTION-CALL

    - number

Constant. Type for function calls.

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

Return **true** if value corresponds to a true flag, or **false** otherwise.

## false?

    value - flag

Return **true** if value corresponds to a false flag, or **false** otherwise.

## even?

    number - flag

Return **true** if the number is even or **false** otherwise.

## odd?

    number - flag

Return **true** if the number is odd or **false** otherwise.

## negative?

    number - flag

Return **true** if the number is negative or **false** otherwise.

## positive?

    number - flag

Return **true** if the number is positive or **false** otherwise.

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

Return **true** if the value is a numeric digit or **false** otherwise.

## symbol?

    value - flag

Return **true** if the value is an ASCII symbol or **false** otherwise.

## letter?

    value - flag

Return **true** if the value is an ASCII letter or **false** otherwise.

## alphanumeric?

    value - flag

Return **true** if the value is an ASCII letter or number or **false** otherwise.

## consonant?

    value - flag

Return **true** if the value is an ASCII consonant or **false** otherwise.

## vowel?

    value - flag

Return **true** if the value is an ASCII vowel or **false** otherwise.

## lowercase?

    value - flag

Return **true** if the value is lowercase or **false** otherwise.

## uppercase?

    value - flag

Return **true** if the value is uppercase or **false** otherwise.

## build-string

    quote - string

Execute a quotation, constructing a string from the values it returns.

## trim-left

    string - string

Remove leading whitespace from a string.

## trim-right

    string - string

Remove trailing whitespace from a string.

## trim

    string - string

Remove both leading and trailing whitespace from a string.

## *CURRENT-BUFFER

    N/A - Variable

Variable. Holds a pointer to the current buffer.

## *BUFFER-OFFSET

    N/A - Variable

Variable. Holds the current location in the buffer for reading/writing.

## current-buffer

    - pointer

Return the current buffer.

## buffer-position

    - pointer number

Return the current buffer slice and location.

## buffer-advance

    -

Increment the buffer location index by 1.

## buffer-retreat

    -

Decrement the buffer location index by 1.

## buffer-store-current

    value -

Store the value into the current location in the buffer. Does not alter the location.

## buffer-fetch-current

    - value

Fetch a value from the current location in the buffer. Does not alter the location.

## buffer-store

    value -

Store the value into the current location in the buffer and increment the location.

## buffer-fetch

    - value

Return the current value in the buffer and increment the location.

## buffer-store-retreat

    value -

Store the value into the current location in the buffer and decrement the location.

## buffer-fetch-retreat

    - value

Return the current value in the buffer and decrement the location.

## set-buffer

    pointer -

Set the current buffer to the specified slice and set the current location to 0.

## buffer-store-items

    ... number -

Store an arbitrary number of items into the current buffer.

## new-buffer

    -

Create a new buffer.

## preserve-buffer

    pointer -

Executes the specified quote while saving the current buffer and location. Restores the buffer and location after execution of the quote completes.

## named-buffer

    string -

## cons

    value value - pointer

Bind two values into a new slice.

## curry

    value quote - quote

Bind a value and a quote, returning a new quote which will execute the original quote on the stored value.

Example:

    "Use this to create a counting function"
    [ "s-q" request [ dup @ 1 + over ! @ ] curry ] 'counter' define

    counter 'c' define
    5 [ c ] times
 

## to

    -

Sets an internal flag telling the next value encountered to update the stored value instead of returning it.

## (value-handler)

    ? pointer -

Internal helper function used by values. This will either return the stored value or update it, depending on the value state set by **to**. If the state requires an update, toggle it back to returning the value instead.

## value

    string -

Create a new value with the specified name.

## value!

    value string -

Create a new value with the specified name and set its initial contents to the specified value.

## values

    quote -

Given an array of strings, create a new value for each one.

Example:

    "Creates new values named a, b, and c:"
    [ 'a'  'b'  'c' ] values

## first

    pointer - value

Return the first value in a slice.

## rest

    pointer - pointer

Given a slice, construct a new slice with all but the first element and return a pointer to this.

## push

    value pointer -

Append a value to the specified slice. This modifies the original slice.

## pop

    pointer - value

Remove and return the last value from a slice. This modifies the original slice.

## reduce

    pointer value pointer - value

**reduce** takes a slice, a starting value, and a quote. It executes the quote once for each item in the slice, passing the item and the value to the quote. The quote should consume both and return a new value.

Example:

    "Sum even numbers in an array"
    [ 1 2 3 4 5 6 7 8 9 10 ] [ even?] filter 0 [ + ] reduce

## for-each

    pointer pointer - ?

**for-each** takes a slice and a quotation. It then executes the quote once for each item in the slice, passing the individual items to the quote.

## contains?

    pointer value - flag

Given a slice and a value, return **true** if the value is found in the slice, or **false** otherwise.

## filter

    pointer pointer - pointer

Given a slice and a quotation, this will pass each value to the quotation (executing it once per item in the slice). The quotation should return a Boolean flag. If the flag is **true**, copy the value to a new slice. Otherwise discard it.

Example:

    'The quick brown fox jumped over the lazy dogs'
    [ vowel? ] filter :s

## map

    pointer pointer - pointer

## capture-results

    quote - pointer

Execute the code in the provided quotation, constructing a new slice with the returned values.

Exercise some caution using this: you may need to manually append values if the stack depth changes in unexpected ways during execution of the source quotation.

## index-of

    pointer value - number

Given a slice and a value, return the offset that the value is located at. If the value is not found, returns an offset of -1.

## *TOB

    N/A - Variable

Variable. This is an array that contains values intended for later display.

## .

    value -

Append a value to the *text output buffer*.

## show-tob

    - ...

Push the values in the *text output buffer* to the stack.

## clear-tob

    -

Remove all entries from the *text output buffer*.

## *Hash-Prime

    - value

Value. Holds the prime number used to salt the raw hash. This is used by **hash**.

## hash:xor

    string - number

Hash a string using the XOR algorithm.

## hash:djb2

    string - number

Hash a string using the DJB2 algorithm.

## hash:sdbm

    string - number

Hash a string using the SDBM algorithm.

## chosen-hash

    string - number

A function that calls the preferred hash algorithm. This should be redefined as desired.

## hash

    string - number

Hash a string (using **chosen-hash**) and **\*Hash-Prime**.

## when

    quote -

Takes a pointer to a set of quotations. Each quote in the set should consist of two other quotes: one that returns a flag, and one to be executed if the condition returns true. Executes each until one returns true, then exits.

Example:

    [ \
      [ [ dup even? ] [ 'number is even!' ] ] \
      [ [ dup odd? ] [ 'number is odd!' ] ] \
      [ [ true ] [ 'hmm, this is a strange number!' ] ] \
    ] when

## apropos

    string - string

Given a function name, return the stack comment for it as a string.