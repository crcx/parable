# Quick Reference

Parable code consists of whitespace separated tokens. Each token can recieve a single character prefix, which tells the compiler how to process it. Tokens without a prefix are treated as function calls. All code is compiled before being run, with each physical source line being compiled and run separately.

## Function Naming

* You can use any characters except for whitespace in a function name
* Function names can not start with the following characters: $ & # [ ] ' " `

----

## Data Types

Parable supports seven primary data types:

* Numbers
* Characters
* Strings
* Pointers
* Flags
* Bytecode
* Function Calls

----

## Prefixes

You can tell Parable how to treat a token by giving it a prefix:

### Numbers

    #100
    #-40.76

Parable also attempts to recognize numbers without the # prefix.

### Characters

    $a
    $9
    $~

### Strings

    'hello'
    'this one has spaces'

### Pointers

    &100
    &collect-garbage

### Flags

Flags are returned by various functions. you can push them to the stack with:

    true
    false

### Comments

Comments get enclosed in double quotes:

    "this is a comment"

### Bytecode

Bytecodes are prefixed by a single backtick (`) character.

    `399

*In most cases you will not need to use this. The bytecode is mapped to symbolic names by the standard library.*

----

## Type Conversions

Parable allows for conversions between data types.

### :n

Converts a value to a number. for pointers, the actual value remains the same. For flags, one of the following occur:

    true    ->   -1
    false   ->    0
    other   ->    1

For strings, if the string is a valid number, it is converted and pushed to the stack. If the string is not a number, the result is not defined.

For characters, this returns the ASCII (or Unicode) value.

### :c

Converts a value to a character.

Numbers and pointers are assumed to be valid ASCII (or Unicode) values.

Strings will have their first character returned.

### :s

Numbers are converted to strings.

Pointers are assumed to point to a string, and their internal type is changed.

Characters are converted to strings.

Flags become one of:

    true    ->  'true'
    false   ->  'false'
    other   ->  'malformed flag'

### :p

The value becomes treated as a pointer.

For numbers, strings, and characters, the internal type is changed.

For flags, the results are not defined.

### :f

The value is converted to a flag.

Strings get converted as:

    'true'   ->  true
    'false'  ->  false

Numbers get converted as:

    -1  ->  true
     0  ->  false

Any other string or number results in a malformed flag.

The results for pointers and characters are not defined.

### :b

Convert a value to a bytecode.

### :call

Convert a value to a function call.

----

## Quotations

A quote is an anonymous block of code or data. These form the basis of function definition, flow control, and various stack operations. to create a new quote, wrap the code in a pair of square brackets:

    [ ]

Quotes can be nested, and are passed around via pointers.

Functions operating on quotes are called *combinators*.

----

## Flow: loops

Parable provides three looping combinators.

### repeat

repeat is used for simple counted loops. it takes a count and a quote, and
runs the quote the specified number of times.

    #10 [ $a ] repeat
    #0 #10 [ dup #1 + ] repeat

### while-true

Executes a quote repeatedly until the quote returns a non-true flag.

    #10 [ dup #1 - dup #0 <> ] while-true

### while-false

Executes a quote repeatedly until the quote returns a non-false flag.

    #10 [ dup #1 - dup #0 = ] while-false

----

## Flow: conditionals

Three conditional execution combinators are provided.

### if

Takes a flag, and two quotes. It will execute the first quote if the flag
is true, or the second if the flag is false.

    true [ #1 ] [ #2 ] if
    "will return #1"
    
    false [ #1 ] [ #2 ] if
    "will return 2"

### if-true

Takes a flag and a quote. It will execute the quote if the flag is true.

    true [ #1 ] if-true

### if-false

Takes a flag and a quote. It will execute the quote if the flag is false.

    false [ #1 ] if-false

----

## Stack Manipulation

Parable provides a number of simple shuffler functions from Forth: dup, drop, swap, over, tuck, nip

It also provides combinators: dip, sip, bi, tri, bi@, bi*

Parable does not provide a secondary stack, but some common Forth idioms can be handled easily using combinators: (both Forth and Parable code samples shown)

### Temporarily removing a value from the stack

    >r ... r>
    [ ... ] dip

### Execute a sequence of code with a copy of a value

    dup >r ... r>
    [ ... ] sip

### Execute code, preserving the contents of a variable:

    base @ >r ... r> base !
    &base [ ... ] preserve
