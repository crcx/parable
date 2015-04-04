# general syntax

parable code consists of whitespace separated tokens. each token can recieve a
single character prefix, which tells the compiler how to process it. tokens
without a prefix are treated as function calls. all code is compiled before
being run, with each physical source line being compiled and run separately.

you can use any characters except for whitespace in a function name, but the
use of $, &, #, [, ], ', and " as single character function names is not
allowed. (however you may use these if the name is two characters or longer)

----

## data types

parable supports five primary data types:

* numbers
* characters
* strings
* pointers
* flags

----

## prefixes

tell parable how to treat a token by giving it a prefix:

### numbers

    #100
    #-40.76

### characters

    $a
    $9
    $~

### strings

    'hello'
    'this one has spaces'

### pointers

    &100
    &collect-garbage

### flags

flags are returned by various functions. you can push them to the stack with:

    true
    false

### comments

comments get enclosed in double quotes:

    "this is a comment"

----

## type conversions

parable allows for conversions between data types.

### :n

converts a value to a number. for pointers, the actual value remains the
same. for flags, one of the following occur:

    true  ->   -1
    false ->    0
    other ->    1

for strings, if the string is a valid number, it is converted and pushed
to the stack. if the string is not a number, the result is not defined.

for characters, this returns the ASCII (or Unicode) value.

### :c

converts a value to a character.

numbers and pointers are assumed to be valid ASCII (or Unicode) values.

strings will have their first character returned.

### :s

numbers are converted to strings.

pointers are assumed to point to a string, and their internal type is changed.

characters are converted to strings.

flags become one of:

    true  -> 'true'
    false -> 'false'
    other -> 'malformed flag'

### :p

the value becomes treated as a pointer.

for numbers, strings, and characters, the internal type is changed.

for flags, the results are not defined.

### :f

the value is converted to a flag.

strings get converted as:

    'true'  -> true
    'false' -> false

numbers get converted as:

    -1 -> true
     0 -> false

any other string or number results in a malformed flag.

the results for pointers and characters are not defined.

----

## quotations

a quote is an anonymous block of code. These form the basis of function
definition, flow control, and various stack operations. to create a new
quote, wrap the code in a pair of square brackets:

    [ ]

quotes can be nested, and are passed around via pointers.

functions operating on quotes are called *combinators*.

----

## flow: loops

parable provides three looping combinators.

### repeat

repeat is used for simple counted loops. it takes a count and a quote, and
runs the quote the specified number of times.

    #10 [ $a ] repeat
    #0 #10 [ dup #1 + ] repeat

### while-true

executes a quote repeatedly until the quote returns a non-true flag.

    #10 [ dup #1 - dup #0 <> ] while-true

### while-false

executes a quote repeatedly until the quote returns a non-false flag.

    #10 [ dup #1 - dup #0 = ] while-false

----

## flow: conditionals

three conditional execution combinators are provided.

### if

takes a flag, and two quotes. will execute the first quote if the flag
is true, or the second if the flag is false.

    true [ #1 ] [ #2 ] if
    "will return #1"

    false [ #1 ] [ #2 ] if
    "will return 2"

### if-true

takes a flag and a quote. will execute the quote if the flag is true.

    true [ #1 ] if-true

### if-false

takes a flag and a quote. will execute the quote if the flag is false.

    false [ #1 ] if-false

----

## stack manipulation

parable provides a number of simple shuffler functions from forth:
dup, drop, swap, over, tuck, nip

it also provides combinators: dip, sip, bi, tri, bi@, bi*

parable does not provide a secondary stack, but some common forth
idioms can be handled easily using combinators: (both forth and parable
code samples shown)

### temporarily removing a value from the stack

    >r ... r>
    [ ... ] dip

### execute a sequence of code with a copy of a value

    dup >r ... r>
    [ ... ] sip

### execute code, preserving the contents of a variable:

    base @ >r ... r> base !
    &base [ ... ] preserve
