## :b

    value - bytecode

Primitive. Convert value on stack to a bytecode.

Notes:

* Currently the value is assumed to be a *number*.

## :n

    value - number

Primitive. Convert value on stack to a number.

Notes:

* If the conversion fails, #nan will be returned.

## :s

    value - string

Primitive. Convert value on stack to a string.

Notes:

* Currently strings should consist of ASCII characters. Unicode is not guaranteed to work.

## :c

    value - character

Primitive. Convert value on stack to a character.

Notes:

* Currently the value should be a number corresponding to an ASCII character code.
* If you pass a string, this will return the first character in the string.

## :p

    value - pointer

Primitive. Convert value on stack to a pointer.

## :f

    value - flag

Primitive. Convert value on stack to a flag.

## :x

    value - function-call

Primitive. Convert value on stack to a function call.

## set-type

    value number:type - value

Primitive. Set the value to a specific type.

Notes:

* This allows setting a value on the stack to a specific type without going through the conversion process (see **:b :c :n :s :call :f :p**).
* This is not limited to the built-in types.

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

Primitive. Divide the first number by the second returning the result.

## rem

    number number - number

Primitive. Divide the first number by the second returning the remainder.

## floor

    number - number

Primitive. Return the largest integer value less than or equal to the specified number.

## ^

    number number - number

Primitive. Return the first value raised to the power of the second number.

## log

    number - number

Primitive. Return the natural logarithm of the number (to base *e*).

## log10

    number - number

Primitive. Return the natural logarithm of the number (to base *10*).

## log<n>

    number number - number

Primitive. Return the natural logarithm of the number to a specified base (this is calculated as [log(first) / log(second)]).

## shift

    number number - number

Primitive. Perform a bit wise shift of the first number the specified number of bits (in the second number). Use a negative value for the second to shift left. A positive value will shift right.

## and

    number number - number

Primitive. Perform a bitwise AND operation on the two values and return the result.

## or

    number number - number

Primitive. Perform a bitwise OR operation on the two values and return the result.

## xor

    number number - number

Primitive. Perform a bitwise XOR operation on the two values and return the result.

## random

    - number

Primitive. Return a random number.

## sqrt

    number - number

Primitive. Return the square root of a number.

## lt?

    number:a number:b - flag

Primitive. Compare two numbers. Returns **true** if the first number (a) is less than the second (b) or **false** otherwise.

## gt?

    number:a number:b - flag

Primitive. Compare two numbers. Returns **true** if the first number (a) is greater than the second (b) or **false** otherwise.

## lteq?

    number:a number:b - flag

Primitive. Compare two numbers. Returns **true** if the first number (a) is less than or equal to the second (b) or **false** otherwise.

## gteq?

    number:a number:b - flag

Primitive. Compare two numbers. Returns **true** if the first number (a) is greater than or equal to the second (b) or **false** otherwise.

## eq?

    value value - flag

Primitive. Compare two values for equality, returns a Boolean flag.

## -eq?

    value value - flag

Primitive. Compare two values for inequality, returns a Boolean flag.

## if

    flag quote:true quote:false -

Primitive. Given a flag, execute the first quote if the flag is **true** or the second if the flag is **false**.

## while

    quote -

Takes a quote which returns a flag. If the flag is **true**, execute the quote again. Repeat until the quote returns **false**.

## until

    quote -

Takes a quote which returns a flag. If the flag is **false**, execute the quote again. Repeat until the quote returns **true**.

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

    value pointer pointer - ?

Primitive. Apply each quotation to a copy of the value.

## tri

    value pointer pointer pointer - ?

Primitive. Apply each quotation to a copy of the value.

## abort

    -

Primitive. Abort current execution cycle.

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

Notes:

* The slice will have an initial cell stored in offset 0 with a *number* type and a value of 0. If you need a fully empty slice you will need to use **request-empty**.

## release

    pointer -

Primitive. Tell Parable that a slice is no longer in use.

## collect-garbage

    -

Primitive. Search memory for unused slices and recover them.

## get-last-index

    pointer - number

Primitive. Return the last offset in a specified slice.

## set-last-index

    number pointer -

Primitive. Set the last index in a slice to the specified offset.

## set-stored-type

    number pointer offset -

Primitive. Set the stored type for the value at offset within the specified slice to the specified type.

Notes:

* This is not limited to the built-in types.

## get-stored-type

    pointer offset - number

Primitive. Get the stored type for the value at offset within the specified slice.

## dup

    value - value value

Primitive. Duplicate the top value on the stack. If the value is a string, makes a new copy of the string.

## drop

    value -

Primitive. Remove the top value from the stack.

## swap

    value:a value:b - value:b value:a

Primitive. Switch the positions of the top two items on the stack.

## over

    value:a value:b - value:a value:b value:a

Primitive. Put a copy of value a over value b.

## tuck

    value:a value:b - value:b value:a value:b

Primitive. Put a copy of value b under value a.

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

Primitive. Return **true** if the named function exists or **false** otherwise.

## lookup-function

    string - pointer

Primitive. Return a pointer to the function if the function exists or a pointer to -1 (an invalid slice) if it does not.

## hide-function

    string -

Primitive. Remove the named function from the dictionary. This removes the name, but not the definition: existing references to it will continue to work.

## lookup-name

    pointer - string

Primitive. Return the name for a function stored at the specified slice.

Note: this returns the first (canonical) name in the dictionary that corresponds to a slice. It will not return aliases.

## find

    string:haystack string:needle - number

Primitive. Search for the substring *needle* in the *haystack*. Returns an offset of -1 if no match is found.

## subslice

    pointer number:start number:end - pointer

Primitive. Return a new slice containing the contents of the original slice, starting from the specified offset and ending at (but not including) the ending offset.

## numeric?

    string - flag

Primitive. If string can be converted to a number using **:n** return **true**. Otherwise return **false**.

## reverse

    pointer - pointer

Primitive. Reverse the order of items stored in a slice.

E.g., given a slice:

    [ 1 2 3 ]

This will modify the slice to be:

    [ 3 2 1 ]

This function modifies contents of the original slice.

## to-lowercase

    value - value

Primitive. Given a string or character, return the lowercase equivalent.

## to-uppercase

    value - value

Primitive. Given a string or character, return the uppercase equivalent.

## report-error

    string -

Primitive. Send a string to the Parable error log.

## sin

    number - number

Primitive. Return the sine of a number.

## cos

    number - number

Primitive. Return the cosine of a number.

## tan

    number - number

Primitive. Return the tangent of a number.

## asin

    number - number

Primitive. Return the arc sine of a number.

## acos

    number - number

Primitive. Return the arc cosine of a number.

## atan

    number - number

Primitive. Return the arc tangent of a number.

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

Constant. Type for bytecodes.

## REMARK

    - number

Constant. Type for comments / embedded remarks.

## :r

    string - comment

Convert a string to a comment / remark.


## FUNCTION-CALL

    - number

Constant. Type for function calls.

## dup-pair

    value:a value:v - value:a value:b value:a value:b

Duplicate the top two values on the stack.

## drop-pair

    value value -

Remove the top two values from the stack.

## drop-multiple

    ? number -

Remove an arbitrary number of values from the stack.

## invoke<depth?>

    quote - ... number

Execute a quotation, returning a value indicating the stack depth change resulting from the execution.

## last-index?

    pointer - pointer number

Return the last offset in a slice. This does not consume the pointer.

## slice-length?

    pointer - pointer number

Return the length of a slice. This does not consume the pointer.

## adjust-slice-length

    number pointer -

Given a number, adjust the length of the specified slice by the requested amount. Use a negative value to shrink or positive to grow the slice.

## duplicate-slice

    pointer - pointer

Make a copy of a slice, returning a pointer to the copy.

## length?

    pointer - number

Return the length of a slice.

## variable

    string -

Create a simple named variable.

## @

    pointer - value

Fetch a value stored in a simple variable.

## !

    value pointer -

Store a value into a simple variable.

## variable!

    value string -

Create a named variable with an initial value.

## off

    pointer -

Set a simple variable to 0.

## on

    pointer -

Set a simple variable to -1

## increment

    pointer -

Increment the stored value in a simple variable by 1.

## decrement

    pointer -

Decrement the stored value in a simple variable by 1.

## zero-out

    pointer -

Erase all values in a slice.

## preserve

    pointer quote -

Backup the contents of a slice and remove the pointer from the stack. Execute the quotation. Then restore the contents of the specified slice to their original state.

## max

    number number - number

Return the larger of two numbers.

## min

    number number - number

Return the smaller of two numbers.

## abs

    number - number

Return the absolute value of a number.

## bi*

    value:a value:b pointer:a pointer:b - ?

Execute pointer:a against value:a and pointer:b against value:b.

## tri*

    value:a value:b value:c pointer:a pointer:b pointer:c - ?

Execute pointer:a against value:a, pointer:b against value:b, and pointer:c against value:c.

## bi@

    value value pointer - ?

Execute pointer against each value.

## tri@

    value value value pointer - ?

Execute pointer against each value.

## true

    - flag

Return a true flag.

## false

    - flag

Return a false flag.

## not

    flag - flag

Invert the state of a flag.

## if-true

    flag quote -

Execute the quotation if the flag is true.

## if-false

    flag quote -

Execute the quotation if the flag is false.

## nan?

    number - flag

Return **true** if number is not valid (#nan) or **false** otherwise.

## zero?

    number - flag

If the value is zero, return **true** otherwise return **false**.

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

Execute the specified quote if the value is a Character.

## if-string

    value quote -

Execute the specified quote if the value is a String.

## if-number

    value quote -

Execute the specified quote if the value is a Number.

## if-pointer

    value quote -

Execute the specified quote if the value is a pointer.

## if-flag

    value quote -

Execute the specified quote if the value is a Boolean flag.

## between?

    number:check number:lower number:upper - flag

Return **true** if the number to check is within the bounds specified or **false** otherwise. The check is inclusive of the bounds.

## types-match?

    value value - value value flag

Return **true** if the types of the two values match or **false** otherwise.

## expand-range

    number number - ...

Given two values, expand the range. 

Example:

    10 90 expand-range
    10 1 expand-range

## sum-range

    ... number - number

Add an arbitrary number of values. The range will include the limits.

Example:

   1 2 3 4 5
   5 sum-range

## hide-functions

    quote -

Given an array of strings, hide the function each names.

Example:

    [ 'a'  'e'  'i'  'o'  'u' ] hide-function

## rename-function

    string:old string:new -

Remove the old name for a function and assign a new one.

Example:

    'foo' variable
    'foo'  'bar' rename

## redefine

    pointer string -

Remove the old header referred to by the string and define a new
function with the name pointing to the new pointer.

Example:

    [ "n-n" 10 * ] 'scale' define
    [ "-n"  5 scale ] 'b' define
    [ "n-n" 20 * ] 'scale' redefine
    [ "-n"  5 scale ] 'c' define
    b c

## variables

    quote -

Given an array of strings, create a new named value for each item.

    "Creates new variables named a, b, and c:"
    [ 'a'  'b'  'c' ] variables

## string-contains?

    value string - flag

Return **true** if the specified character is found in the string or **false** otherwise.

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

Example:

    [ 'Hello' 32 :c 'World!' ] build-string

See also: **interpolate**

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

Create a new buffer and set it as the current one.

## preserve-buffer

    pointer -

Executes the specified quote while saving the current buffer and location. Restores the buffer and location after execution of the quote completes.

## named-buffer

    string -

Create a new buffer with the specified name. Also assigns the buffer as the current one.

## cons

    value value - pointer

Bind two values into a new slice.

Example:

    $a $b cons :s

## curry

    value quote - quote

Bind a value and a quote, returning a new quote which will execute the original quote on the stored value.

Example:

    "Use this to create a counting function"
    [ "s-q" request [ [ @ ] [ increment ] bi ] curry ] 'counter' define

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

Example:

    100 'test' value!

## values

    quote -

Given an array of strings, create a new value for each one.

Example:

    "Creates new values named a, b, and c:"
    [ 'a'  'b'  'c' ] values

## first

    pointer - value

Return the first value in a slice.

Example:

    [ 1 2 3 4 5 ] first

## rest

    pointer - pointer

Given a slice, construct a new slice with all but the first element and return a pointer to this.

Example:

    'Eggs Are Tasty' rest :s

## last

    pointer - value

Given a slice, return the last value in it.

Example:

    'hello world!' last

## push

    value pointer -

Append a value to the specified slice. This modifies the original slice.

Tip: If you are trying to append characters to a string, this is much faster than using **+** for concatenation.

## pop

    pointer - value

Remove and return the last value from a slice. This modifies the original slice.

## request-empty

    - pointer

Return a new slice. Unlike **request** the returned slice will be fully empty.

Note: **request** allocates an initial cell in the first slot; this does not.

## reduce

    pointer value pointer - value

**reduce** takes a slice, a starting value, and a quote. It executes the quote once for each item in the slice, passing the item and the value to the quote. The quote should consume both and return a new value.

Example:

    "Sum even numbers in an array"
    [ 1 2 3 4 5 6 7 8 9 10 ] [ even? ] filter 0 [ + ] reduce

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

Given a pointer to an array and a quotation, execute the quotation once for each item in the array. Construct a new array from the value returned by the quotation and return a pointer to it.

Example:

    "Multiply all values in the array by 10"
    [ 1 2 3 4 ] [ 10 * ] map

## capture-results

    quote - pointer

Execute the code in the provided quotation, constructing a new slice with the returned values.

Exercise some caution using this: you may need to manually append values if the stack depth changes in unexpected ways during execution of the source quotation.

Example:

    [ $a $z [ :n ] bi@ expand-range ] capture-results reverse :s

Tip: the results will be appended in the order they are encountered on the stack. So the last result will be the first one in quote. Use **reverse** to alter the order if necessary.

## index-of

    pointer value - number

Given a slice and a value, return the offset that the value is located at. If the value is not found, returns an offset of -1.

Example:

    [ 1 2 3 4 5 ]  9 index-of
    [ 1 2 3 4 5 ]  3 index-of

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

## *Internals

    - value

Value. Holds a list of function names to create or remove. This is used by **{** and **}**.

## {

    pointer -

Create functions or values for each item stored in the array specified. Begins a scope sequence that will end with **}**.

## }

    -

End a sequence begun by **{**. Removes the names created by executing **{**.

Example:

    [ 'a' '*B' ] {
        ... do something with a and *B ...
    }

    "a and *B are no longer in the dictionary at this point"

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

## split

    string value - pointer

Given a string, split it into pieces wherever the value (a character or string) is found and construct an array from these pieces. Return the array.

Example:

    'hello brave new world'
    ' ' split

## join

    pointer value - string

Given an array and a value, convert the values in the array to strings and construct a new string, concatenating the pieces together with the specified value (a string or a character) between them.

Example:

    [ 'this' 'is' 'a' 'series' 'of' 'values' ]
    '---' join

## clean-string

    string - string

Remove all non basic ASCII characters from a string. This will filter out anything less than 32 and greater than 128 and should be used if you find yourself with strings that have control characters or other problematic values.

## replace

    string:source string:seek string:replace - string

Replace all instances of *string:seek* in *string:source* with *string:replace*.

Example:

    'Apples are horrible'
    'horrible'

## interpolate

    pointer string - string

Takes an array and a string. Replaces instances of {v} in the string with values from the array.

Example:

    [ 1 2 3 ] '{v} + {v} = {v}' interpolate

Note: if the array has fewer values than the number of replace points this will replace the remaining points with an empty string.

See also: **build-string**

## interpolate<cycling>

    pointer string - string

Takes an array and a string. Replaces instances of {v} in the string with values from the array.

Example:

    [ 1 2 3 ] '{v} + {v} = {v}' interpolate<cycling>

Note: if the array has fewer values than the number of replace points this will cycle through the data until all replace points are exhausted.

## apropos

    string - string

Given a function name, return the stack comment for it as a string.

## stack-values

    - pointer

Returns a pointer to an array with copies of all values on the stack.
