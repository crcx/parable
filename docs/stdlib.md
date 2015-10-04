# Overview

Upon startup, the parable language consists of one function and the functionality exposed by the parser. The initial function is *define*. The standard libary is provided to make Parable into a useful language.

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

math.pow(x, y)

Return A raised to the power of B.

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

Perform a bitwise shift of A by B bits. If B is negative, shift left, otherwise shift right.

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

## get-last-index

Return the last index in a slice.

    pointer -- number

This is a primitive corresponding to a byte code.

## set-last-index

Set the last index of a slice.

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

Find substring *needle* in string *haystack*. Returns the starting offset, or -1 if no match is found.

    string:haystack string:needle -- number

This is a primitive corresponding to a byte code.

## subslice

Return a new slice containing the contents of the slice at pointer, starting from the specified offset, and ending at (but not including) the ending offset.

    pointer number:start number:end -- pointer:result

This is a primitive corresponding to a byte code.

## numeric?

Given a string, returns **true** if the string is a valid number, or **false** otherwise.

    string -- flag

This is a primitive corresponding to a byte code.

## to-uppercase

Convert a CHARACTER or STRING to uppercase.

    value -- value

This is a primitive corresponding to a byte code.

## to-lowercase

Convert a CHARACTER or STRING to lowercase.

    value -- value

This is a primitive corresponding to a byte code.

## report-error

Add the specified string to the system error log.

    string --

This is a primitive corresponding to a byte code.

## sin

Calculate the sine of a number, with the result in radians.

    number -- number

This is a primitive corresponding to a byte code.

## cos

Calculate the cosine of a number, with the result in radians.

    number -- number

This is a primitive corresponding to a byte code.

## tan

Calculate the tangent of a number, with the result in radians.

    number -- number

This is a primitive corresponding to a byte code.

## asin

Calculate the arcsine of a number, with the result in radians.

    number -- number

This is a primitive corresponding to a byte code.

## acos

Calculate the arccosine of a number, with the result in radians.

    number -- number

This is a primitive corresponding to a byte code.

## atan

Calculate the arctangent of a number, with the result in radians.

    number -- number

## atan2

Return atan(y / x), in radians

    number:x number:y -- number

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


## variable

Create a simple named variable

    string --

## @

Fetch the value stored in a simple variable.

    pointer -- number

## !

Store value into a simple variable.

    value pointer --

## length?

Return the length of a slice.

    pointer -- number

This works with all pointers, including strings and arrays.

## min

Return the lesser of two numbers.

    number number -- number

## max

Return the greater of two numbers.

    number number -- number

## abs

Return the absolute value of a number.

    number -- number

## invoke<depth?>

Return the results of executing a quote and a number indicating the change in stack depth.

    pointer - ... number

Note that this can be problematic if the executed quotation does extensive stack manipulations. Watch your inputs when using this, and make necessary adjustments manually as needed.

## bi*

Apply pointer:a to value:a and pointer:b to value:b. Returns the results.

    value:a value:b pointer:a pointer:b -- ?

## tri*

Apply pointer:a to value:a, pointer:b to value:b, and pointer:c to value:c. Returns the results.

    value:a value:b value:c pointer:a pointer:b pointer:c -- ?

## bi@

Apply code at pointer to a value:a and value:b. Returns the results.

    value:a value:b pointer -- ?

## tri@

Apply code at pointer to a value:a, value:b, and value:c. Returns the results.

    value:a value:b value:c pointer -- ?

## dup-pair

Duplicate the top two values on the stack.

    value:a value:b -- value:a value:b value:a value:b 

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

Invert the flag on the stack.

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

Return **true** if number is even, or **false** otherwise.

    number -- flag

## odd?

Return **true** if number is odd, or **false** otherwise.

    number -- flag

## negative?

Return **true** if number is negative, or **false** otherwise.

    number -- flag

## positive?

Return **true** if number is positive, or **false** otherwise.

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

Return **true** if A is between B and C, inclusive. Or **false** otherwise.

    number:a number:b number:c -- flag

## variable!

Create a simple named variable with an initial value.

    value string --

## off

Set a simple variable to a value of 0.

    pointer --

## on

Set a simple variable to a value of -1.

    pointer --

## increment

Increment the value of a simple variable by 1.

    pointer --

## decrement

Decrement the value of a simple variable by 1.

    pointer --

## zero-out

Set a slice to a length of zero and wipe out any stored values in the process.

    pointer --

## preserve

Execute code in *pointer:code*, preserving and restoring the data in the *pointer:data*.

    pointer:data pointer:code --

## expand-range

Return a numeric range starting with lower and ending with upper, inclusive. All values are placed on the stack.

    number:lower number:upper -- ...

## sum-range

Add *number* values on the stack.

    ... number -- number

## slice-last-index

Return the last index in a slice. This preserves the pointer.

    pointer -- pointer number

## get-slice-length

Return the length of a slice.

    pointer -- number

## slice-length

Return the length of a slice. Unlike **get-slice-length** this does not consume the pointer.

    pointer -- pointer number

## adjust-slice-length

Adjust the length of a slice. You can use this to shrink or grow slices as needed.

    number pointer --

## drop-multiple

Drop the specified number of values from the stack.

    ... number -- ?

## slice-duplicate

Make a copy of a slice.

    pointer -- new-pointer

## hide-functions

Execute code at pointer, and remove the function names it pushes to the stack.

    pointer --

## rename-function

Remove the old header for a function and attach the new one to it.

    string:old string:new --

## variables

Execute code at pointer, and create a simple variable for each name that it returns.

    pointer --

## string-contains?

Returns **true** if value is found in the specified string, or **false** otherwise.

    value string -- flag

## digit?

Return **true** if value is a numeric digit, or **false** otherwise.

    value -- flag

## symbol?

Return **true** if value is an ASCII symbol, or **false** otherwise.

    value -- flag

## letter?

Return **true** if value is a letter, or **false** otherwise.

    value -- flag

## alphanumeric?

Return **true** if value is a letter or numeric digit, or **false** otherwise.

    value -- flag

## consonant?

Return **true** if the value is a consonant, or **false** otherwise.

    value -- flag

## vowel?

Return **true** if the value is a vowel, or **false** otherwise.

    value -- flag

## lowercase?

Return **true** if the value is a lowercase character, or **false** otherwise.

    value -- flag

## uppercase?

Return **true** if the value is an uppercase character, or **false** otherwise.

    value -- flag

## build-string

Execute the code in the specified slice, and construct a string from the returned values.

    pointer -- string

## trim-left

Trim leading white space from a string.

    string -- string

## trim-right

Trim trailing white space from a string.

    string -- string

## trim

Trim all leading and trailing white space from a string.

    string -- string

## factorial

Return the factorial of a number.

    number -- number

## *CURRENT-BUFFER

Variable.

Variable holding the current buffer slice number.

    -- pointer

## *BUFFER-OFFSET

Variable.

Variable holding the current offset into the current buffer.

    -- pointer

## current-buffer

Return a pointer to the current buffer.

    -- pointer

## buffer-position

Returns the current buffer and offset pair.

    -- pointer number

## buffer-advance

Increment the current buffer offset.

    --

## buffer-retreat

Decrement the current buffer offset.

    --

## buffer-store-current

Store a value into the current location in the buffer.

    value --

## buffer-fetch-current

Fetch the value at the current location in the buffer.

    -- number

## buffer-store

Store a value into the current location in the buffer, and then increment to the next offset.

    value --

## buffer-fetch

Fetch a value from the current location in the buffer, and then increment to the next offset.

    -- number

## buffer-store-retreat

Store a value into the current location in the buffer, and then decrement to the next offset.

    value --

## buffer-fetch-retreat

Fetch a value from the current location in the buffer, and then decrement to the next offset.

    -- number

## set-buffer

Set pointer as the active buffer.

    pointer --

## buffer-store-items

Store the specified number of values into the buffer.

    ... number --

## new-buffer

Allocate a new buffer and set it as the active one.

    --

## preserve-buffer

Execute the code at *pointer*, while preserving and restoring the current buffer and offset. (This
allows the code in the slice to allocate a new buffer, and restores the old settings when done.)

    pointer --

## named-buffer

Create a new buffer, and attach a name to it.

    string --

## curry

Given a value and a quotation, return a new quotation that applies the original to the value.

    value pointer -- pointer

## to

Set a flag so that the next value will update it's stored value rather than returing it.

    --

## value

Create a new value.

    string --

## value!

Create a new value with an initial value.

    value string --

## values

Execute code in pointer, creating a new value for each name. The code should return a series of strings.

    pointer --

## array-push

Push a value to the end of an array.

    value pointer --

## array-pop

Pop a value off of an array.

    pointer -- number

## array-from-quote

Execute code in slice, and return an array constructed from the values in it.

    pointer -- pointer

## array-reduce

Reduce an array to a single value.

    pointer:array number pointer:code -- number

Example:

    [ #1 #2 #3 ] array-from-quote
    #0 [ + ] array-reduce

## for-each

Execute a quote once for each element in an array.

    pointer:data pointer:quote -- ?

## array-contains?

Check an array to see if it contains a value.

    pointer:data value -- flag

## array-filter

Execute a quote for each item in an array. If the quote returns true, copy the corresponding value to a new quote.

    pointer:data pointer:quote -- pointer:results

## array-map

Execute a quote for each item in an array. Construct a new array from the modified values.

    pointer:data pointer:quote -- pointer:results

## array-compare

Compare two arrays to determine if they are identical.

    pointer pointer -- flag

## array-to-string

Construct a string representation of an array.

    pointer type -- string

## array-index-of

Return the offset of the specified value in the array.

    value pointer -- number

## show-tob

Push the strings in the text output buffer to the stack.

    -- ...

## clear-tob

Remove all items from the text output buffer.

    --

## .

Append a value to the text output buffer.

    value --

## hash:djb2

Hash a string using the DJB2 algo.

    string -- number

## hash:sdbm

Hash a string using the SDBM algo.

    string -- number

## hash:lrc

Hash a string using the LRC algo.

    string -- number

## hash:xor

Hash a string using the XOR algo.

    string -- number

## chosen-hash

This should be set to the preferred hash function. Defaults to **hash:djb2**.

    string -- number

## hash-prime

Constant, prime number for hash functionality

    -- number

## hash

Invoke **chosen-hash**, then modulus against the **hash-prime**.

    string -- number
