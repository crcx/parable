## :

    ps-

Attach a name to a pointer

## nop

    -

Does nothing

## set-type

    vt-v

Convert a value to the specified type

## type?

    v-vn

Return the type constant for a value

## +

    nn-n

Add two numbers or concatenate two strings, remarks, or slices

## -

    nn-n

Subtract n2 from n1

## *

    nn-n

Multiply two numbers

## /

    nn-n

Divide n1 by n2

## rem

    nn-n

Divide n1 by n2, returning the remainder

## ^

    nn-n

Return n1 to the power n2

## log&lt;n&gt;

    nn-n

Return the logarithim of a number in the specified base

## shift

    nn-n

Perform a bitwise shift

## and

    nn-n

Bitwise AND operation

## or

    nn-n

Bitwise OR operation

## xor

    nn-n

Bitwise XOR operation

## random

    -n

Return a random number

## sqrt

    n-n

Obtain the square root of a number

## round

    n-n

Round a number to the nearest integer value

## lt?

    nn-f

True if n1 < n2 or false otherwise

## gt?

    nn-f

True if n1 > n2 or false otherwise

## lteq?

    nn-f

True if n1 <= n2 or false otherwise

## gteq?

    nn-f

True if n1 >= n2 or false otherwise

## eq?

    vv-f

True if n1 == n2 or false otherwise

## -eq?

    vv-f

True if n1 != n2 or false otherwise

## if

    fpp-

If flag is true, invoke p1; otherwise invoke p2

## while

    p-

Invoke p (which should return a flag) until the returned flag is false

## until

    p-

Invoke p (which should return a flag) until the returned flag is true

## times

    np-

Invoke slice p the specified number of times

## invoke

    p-

Run the code in slice p

## dip

    vp-v

Remove value and invoke the quote. Restore value when execution completes.

## sip

    vp-v

Invoke the quote. After execution complets, restore a copy of the value to the stack

## bi

    vpp-?

Apply each quote to a copy of the value

Example:

````
100 [ 10 / ]
    [ 20 - ] bi
````

## tri

    vppp-?

Apply each quote to a copy of the value

Example:

````
100 [ 10 / ]
    [ 20 * ]
    [ 30 - ] tri
````

## abort

    -

Abort the current execution cycle

## copy

    pp-

Copy the contents of the first slice to the second one

## fetch

    pn-v

Fetch a value stored at the specified offset within the specified slice

## store

    vpn-

Store a value into the specified offset within the specified slice

## request

    -p

Request a new slice and return a pointer to it

## release

    p-

Release a previously allocated slice

## collect-garbage

    -

Tell Parable that this is a good time to scan memory for unused slices and reclaim them

## get&lt;final-offset&gt;

    p-n

Return the last offset in a slice

## set&lt;final-offset&gt;

    np-

Set the last index in a slice (can be used to shrink or grow a slice)

## store&lt;type&gt;

    tpn-

Set the stored type for the value at offset with the slice to the specified type.

## fetch&lt;type&gt;

    pn-n

Get the stored type for a value within a slice.

## dup

    v-vv

Duplicate the top value on the stack

## drop

    v-

Discard the top value on the stack

## swap

    vV-Vv

Switch the positions of the top two items on the stack

## depth

    -n

Return the number of items on the stack

## hide-word

    s-

Remove the named item from the dictionary

## find

    ss-n

Search for substring (s2) in a source string (s1). Returns #nan if not found.

## subslice

    pnn-p

Return a new slice containing the contents of the original slice, starting from the specified offset and ending at (but not including) the ending offset.

## numeric?

    s-f

If string can be converted to a number, return true, otherwise return false

## reverse

    p-p

Reverse the order of items in a slice. This modifies the original slice.

## to-lowercase

    v-v

Convert a string or character to lowercase

## to-uppercase

    v-v

Convert a string or character to uppercase

## report-error

    s-

Add a string to the error log

## vm.dict&lt;names&gt;

    -p

Return an array of strings corresponding to names in the dictionary

## vm.dict&lt;slices&gt;

    -p

Return an array of slices corresponding to the named items in the dictionary

## sin

    n-n

Return the sine of a number

## cos

    n-n

Return the cosine of a number

## tan

    n-n

Return the tangent of a number

## asin

    n-n

Return the arc sine of a number

## acos

    n-n

Return the arc cosine of a number

## atan

    n-n

Return the arc tangent of a number

## atan2

    n-n

Return the arc tangent of a number

## vm.memory&lt;map&gt;

    -p

Return an array indicating which slices are allocated and which are free. Each index corresponds to a slice. If the stored value is 0, the slice is free. If 1, the slice is allocated.

## vm.memory&lt;sizes&gt;

    -p

Return an array indicating the size of each slice (in cells). Each index corresponds to a slice; the stored value is the length of the slice.

## vm.memory&lt;allocated&gt;

    -p

Return an array of slice numbers which are currently marked as allocated.

## over

    vV-vVv

Put a copy of the second item on top of the stack

## tuck

    vV-VvV

Put a copy of the top item below the second item

## nip

    vV-V

Remove the item below the top item on the stack

## reset

    ...-

Remove all items from the stack

## .

    sp-

Attach a name to a slice

## NUMBER

    -n

Type constant

## STRING

    -n

Type constant

## CHARACTER

    -n

Type constant

## POINTER

    -n

Type constant

## FLAG

    -n

Type constant

## BYTECODE

    -n

Type constant

## REMARK

    -n

Type constant

## FUNCALL

    -n

Type constant

## UNKNOWN

    -n

Type constant

## :b

    v-b

Convert value to a BYTECODE

## :n

    v-n

Convert value to a NUMBER

## :s

    v-s

Convert value to a STRING

## :c

    v-c

Convert value to a CHARACTER

## :p

    v-p

Convert value to a POINTER

## :f

    v-f

Convert value to a FLAG

## :x

    v-f

Convert value to a FUNCALL

## :r

    v-c

Convert value to a REMARK

## :u

    v-v

Convert value to a UNKNOWN

## number?

    v-vf

Return true if value is a NUMBER or false otherwise

## string?

    v-vf

Return true if value is a STRING or false otherwise

## character?

    v-vf

Return true if value is a CHARACTER or false otherwise

## pointer?

    v-vf

Return true if value is a POINTER or false otherwise

## flag?

    v-vf

Return true if value is a FLAG or false otherwise

## bytecode?

    v-vf

Return true if value is a BYTECODE or false otherwise

## remark?

    v-vf

Return true if value is a REMARK or false otherwise

## funcall?

    v-vf

Return true if value is a FUNCALL or false otherwise

## unknown?

    v-vf

Return true if value is UNKNOWN or false otherwise

## dup-pair

    vV-vVvV

Duplicate the top two items on the stack

## drop-pair

    vv-

Discard the top two items on the stack

## drop&lt;n&gt;

    ?n-

Discard an arbitrary number of items from the stack

## invoke&lt;depth?&gt;

    q-...n

Execute a quotation, returning a value indicating th stack depth change as a result

## floor

    n-n

Return the smallest integer less than or equal to the starting value

## ceil

    n-n

Return the smallest integer greater than or equal to the starting value

## adjust-slice-length

    np-

Given a number, adjust the length of the specified slice by the requested amount.

## duplicate-slice

    p-p

Make a copy of a slice, returning a pointer to the copy

## length?

    p-n

Return the length of a slice

## var!

    vs-

Create a variable with an initial value

## var

    s-

Create a variable

## off

    p-

Set a variable to a value of 0

## on

    p-

Set a variable to a value of -1

## increment

    p-

Increment a variables value by 1

## decrement

    p-

Increment a variables value by 1

## zero-out

    p-

Erase all values in a slice

## preserve

    pp-

Backup the contents of a slice and remove the pointer from the stack. Execute the quotation. Then restore the contents of the specified slice to their original state.

## max

    nn-n

Return the greater of two values

## min

    nn-n

Return the smaller of two values

## abs

    n-n

Return the absolute value of a number

## bi*

    vvpp-?

Invoke p1 against v1 and p2 against v2

Example:

````
100 200
[ 10 / ]
[ 20 - ] bi*
````

## tri*

    vvvppp-?

Invoke p1 against v1, p2 against v2, and p3 against v3

Example:

````
100 200 300
[ 10 / ]
[ 20 - ]
[ 50 + ] tri*
````

## bi@

    vvp-?

Invoke p1 against v1 and again against v2

Example:

````
1 2
[ 10 * ] bi@
````

## tri@

    vvvp-?

Invoke p1 against v1, then v2, then v3

Example:

````
1 2 3
[ 10 * ] tri@
````

## abort&lt;with-error&gt;

    s-

Push a string to the error log and abort execution

## true

    -f

Return a true flag

## false

    -f

Return a false flag

## not

    f-f

Invert a flag

## if-true

    fp-

Invoke quote if flag is true

## if-false

    fp-

Invoke quote if flag is false

## nan?

    v-f

Return true if number is #nan or false otherwise

## zero?

    v-f

Return true if number is #0 or false otherwise

## true?

    v-f

Return true if flag is true or false otherwise

## false?

    v-f

Return true if flag is false or false otherwise

## even?

    n-f

Return true if number is even or false otherwise

## odd?

    n-f

Return true if number is odd or false otherwise

## negative?

    n-f

Return true if number is less than zero or false otherwise

## positive?

    n-f

Return true if number is greater than or equal to zero or false otherwise

## between?

    nnn-f

Return true if the number (n1) is betwen n2 and n3, inclusive or false otherwise

## types-match?

    vv-vvf

Return true if the type of both values is the same, or false otherwise

## expand-range

    nn-...

Given two values, expand the range

Example:

````
[ $a $z [ :n ] bi@ expand-range ] capture-results reverse :s

````

## sum-range

    ...n-n

Given a series of values and a count, sum the values

Example:

````
1 2 3 4 5
5 sum-range

````

## hide-words

    p-

Given an array of names, hide each named item

Example:

````
[ 'a'  'e'  'i'  'o'  'u' ] hide-words

````

## redefine

    ps-

Remove the old name for a word and assign it to a new one

Example:

````
[ "n-n" 10 * ] 'scale' :
[ "-n"  5 scale ] 'b' :
[ "n-n" 20 * ] 'scale' redefine
[ "-n"  5 scale ] 'c' :
b c

````

## ::

    p-

Given a list of names, create a variable for each one

Example:

````
"Creates new variables named a, b, and c:"
[ 'a'  'b'  'c' ] ::

````

## string-contains?

    vs-f

Return true if the value is found in the specified string, or false otherwise

## digit?

    v-f

Return true if value is a decimal digit, or false otherwise

## symbol?

    v-f

Return true if value is an ASCII symbol, or false otherwise

## letter?

    v-f

Return true if value is an ASCII letter, or false otherwise

## alphanumeric?

    v-f

Return true if value is a ASCII letter or digit, or false otherwise

## consonant?

    v-f

Return true if value is a consonant, or false otherwise

## vowel?

    v-f

Return true if value is a vowel, or false otherwise

## lowercase?

    v-f

Return true if value is a lowercase string or ASCII character, or false otherwise

## uppercase?

    v-f

Return true if value is an uppercase string or ASCII character, or false otherwise

## build-string

    p-s

Execute a quotation, constructing a string from the values it returns.

Example:

````
[ 'Hello' 32 :c 'World!' ] build-string

````

## cons

    vv-p

Bind two values into a new slice

Example:

````
$a $b cons :s

````

## curry

    vp-p

Bind a value and a quote, returning a new quote which executes the specified one against the provided value

Example:

````
"Use this to create a counting function"
[ "s-q" request [ [ head ] [ increment ] bi ] curry ] 'counter' :

counter 'c' :
5 [ c ] times

````

## enquote

    p-p

Wrap a pointer into a new quote, converting the pointer into a FUNCALL

## head

    q-v

Return the first item in a slice

Example:

````
[ 1 2 3 4 5 ] head

````

## body

    q-q

Return the second through last items in a slice

Example:

````
'Eggs Are Tasty' body :s

````

## tail

    p-v

Return the last item in a slice

Example:

````
'hello world!' tail

````

## push

    vp-

Append a value to the specified slice. This modifies the original slice.

## pop

    p-v

Remove the last value from the specified slice. This modifies the original slice.

## request-empty

    -p

Request a slice with no stored values

## reduce

    pnp-n

Takes a slice, a starting value, and a quote. It executes the quote once for each item in the slice, passing the item and the value to the quote. The quote should consume both and return a new value.

Example:

````
"Sum even numbers in an array"
[ 1 2 3 4 5 6 7 8 9 10 ] [ even? ] filter 0 [ + ] reduce

````

## for-each

    pp-?

Takes a slice and a quotation. It then executes the quote once for each item in the slice, passing the individual items to the quote.

## contains?

    pv-f

Given a slice and a value, return true if the value is found in the slice, or false otherwise.

## filter

    pq-p

Given a slice and a quotation, this will pass each value to the quotation (executing it once per item in the slice). The quotation should return a Boolean flag. If the flag is true, copy the value to a new slice. Otherwise discard it.

Example:

````
'The quick brown fox jumped over the lazy dogs'
[ vowel? ] filter :s

````

## map

    pq-

Given a pointer to an array and a quotation, execute the quotation once for each item in the array. Construct a new array from the value returned by the quotation and return a pointer to it.

Example:

````
"Multiply all values in the array by 10"
[ 1 2 3 4 ] [ 10 * ] map

````

## capture-results

    p-p

Invoke a quote and capture the results into a new array

## index-of

    pv-n

Given a slice and a value, return the offset the value is located at, or #nan if not found

Example:

````
[ 1 2 3 4 5 ]  9 index-of
[ 1 2 3 4 5 ]  3 index-of

````

## word-exists?

    s-f

Return true if the named word exists or false otherwise

## lookup-word

    s-p

Return a pointer to the named word if it exists, or #nan otherwise

## lookup-name

    p-s

If the pointer corresponds to a named item, return the name. Otherwise return an empty string.

## rename-word

    ss-

Change a name from s1 to s2

Example:

````
'foo' var
'foo'  'bar' rename-word

````

## trim-left

    s-s

Remove leading whitespace from a string

## trim-right

    s-s

Remove trailing whitespace from a string

## trim

    s-s

Remove leading and trailing whitespace from a string

## {

    -

Begin a lexically scoped area

## }

    p-

End a lexically scoped region, removing any headers not specified in the provided array.

Example:

````
{
    [ 'a' 'b' ] ::
    [ ... do something with a and b ... ] 'c' :

    [ 'c' ]
}

"a and b are no longer in the dictionary at this point"

````

## with

    p-

Add words in a vocabulary to the dictionary

## without

    p-

Remove words in a vocabulary from the dictionary

## vocab

    ps-

Create a new vocabulary

## }}

    ps-

Close a lexical scope and create a vocabulary with the exposed words

Example:

````
[ 'a' 'c' ] 'EiEiO~' {
  [ "-n" 100 ] 'a' :
  [ "-n" 200 ] 'b' :
  [ "-n" a b + ] 'c' :
}}
````

## invoke&lt;preserving&gt;

    qq-

Executes the code quotation, preserving and restoring the contents of the variables specified.

Example:

````
100 'A' var!
[ A ]  [ 200 !A  @A dup * ] invoke<preserving>
@A

````

## zip

    ppp-p

For each item in source1, push the item and the corresponding item from source2 to the stack. Execute the specified code. Push results into a new array, repeating until all items are exhausted. Returns the new array. This expects the code to return a single value as a result. It also assumes that both sources are the same size (or at least that the second does not contain less than the first

Example:

````
[ 1 2 3 ]  [ 4 5 6 ]  [ + ] zip

"This would return a new array identical to:"

[ 5 7 9 ]

````

## Hash-Prime

    -v

## hash:xor

    s-n

Hash a string using the XOR algorithim

## hash:djb2

    s-n

Hash a string using the DJB2 algorithim

## hash:sdbm

    s-n

Hash a string using the SDBM algorithim

## chosen-hash

    s-b

The preferred hash algorithim (defaults to DJB2)

## hash

    s-n

Hash a string using chosen-hash and Hash-Prime

## when

    q-

Takes a pointer to a set of quotations. Each quote in the set should consist of two other quotes: one that returns a flag, and one to be executed if the condition returns true. Executes each until one returns true, then exits.

Example:

````
[ \
  [ [ dup even? ] [ 'number is even!' ] ] \
  [ [ dup odd? ] [ 'number is odd!' ] ] \
  [ [ true ] [ 'hmm, this is a strange number!' ] ] \
] when

````

## split

    ss-p

Given a string and a delimiter, split the string into an array

Example:

````
'hello brave new world'
' ' split

````

## join

    pv-s

Given an array of values and a string, convert each value to a string and merge, using the provided string between them

Example:

````
[ 'this' 'is' 'a' 'series' 'of' 'values' ]
'---' join

````

## clean-string

    s-s

Remove any non-printable characters from a string

## replace

    sss-s

Replace all instances of s2 in s1 with s3

Example:

````
'Apples are horrible.'
'horrible'  'tasty' replace

````

## interpolate

    ps-s

Given an array of values and a string with insertion points, construct a new string, copying the values into the insertion points.

Example:

````
[ 1 2 3 ] '{v} + {v} = {v}' interpolate

````

## interpolate&lt;cycling&gt;

    qs-s

Given an array of values and a string with insertion points, construct a new string, copying the values into the insertion points. If the array of values is less than the number of insertion points, cycle through them again.

Example:

````
[ 1 2 3 ] '{v} + {v} = {v}' interpolate<cycling>

````

## ?

    s-s | s-ss

Lookup the stack comment and description (if existing) for a named item

## stack-values

    -p

Return an array with the items currently on the stack

## vm.dict&lt;names-like&gt;

    s-p

Return an array of names in the dictionary that match a given substring.

## E

    -n

Mathmatical constant for Euler's Number

## PI

    -n

Mathmatical constant for PI

## log

    n-n

Return the base E logarithim of a number

## log10

    n-n

Return the base 10 logarithim of a number

## strip-remarks

    p-p

Return a copy of the slice with embedded comments removed

