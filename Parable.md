# Parable Language

*It's time to gather all of the Parable documentation together, into a single document explaining the language, virtual machine, and features.*

# Overview

Parable consists of a compiler and bytecode interpreter.

The compiler takes each line of source, parses it into tokens, and then creates a new *quotation* containing the bytecode appropriate to each token. The behaviour of each token is determined by *prefixes* (single characters at the start of the token).

After compilation is completed, the bytecode interpreter will execute the code in the newly compiled quotation.

*Unlike Forth, all Parable code is compiled before being run. There is no concept of "interpret vs compile time actions" in Parable.*

The language is rigidly built around reverse polish structure and the data stack. The language does not provide access to the parser and no facilities exist for modifying the compiler behaviour from user level code.

*The compiler and bytecode interpreter can be extended, but only by the _user interface layer_, not in Parable itself.*

Parable itself has no user interface. The interface is defined as a separate layer, and can be adapted for specific platform(s) as desired. The user interfaces should provide the *standard library* which defines names for the bytecodes and various commonly used functions.

Parable includes two user interfaces: *pre* and *legend*.

*Pre* is the *Parable Runtime Environment* and is a command line wrapper that processes code in source files and displays the results to the standard output device. It is not interactive.

*Legend* is an interactive, terminal based user interface that processes input from the standard input device and displays the results of execution immediately.

A third option, *Apologue* is available for iOS users. This encompasses a code editor, evaluation of source, documentation, and a decompiler.

# Compiler

The Parable compiler is a fairly simple construction. It takes a single line of source, breaks it into whitespace delimited tokens, and then iterates over the tokens, compiling them into a new slice as instructed by the *prefixes* each token optionally has.

The compiler recognizes the following prefixes: # $ & ` " '

Numbers are *floating point*, and canonically have a # prefix. E.g.,

    #1
    #NaN
    #-121.1124

To aid in simplicity and readability, the # prefix is considered optional: Parable will attempt to recognize numbers without the prefix, but this is not guaranteed to work in all cases. 

The next prefix, $, is used to mark the token as a *character*. Currently this compiles the character immediately following the prefix into the quotation. 

    $a
    $1
    $_

*Currently the only reliably recognized characters are ASCII. Extended Unicode character values may not work.*

The & prefix is used to mark the token as a pointer to a slice. The following value can be either a name or a slice number.

    &invoke
    &capture-results
    &12345

Strings start and end with a single quotation character ('). They contain *character* data, and can contain spaces. The compiler will concatenate tokens together until encountering one ending in '.

    'hello world'
    '1234567890'

Comments start and end with double quotes ("). They contain *character* data, and can contain spaces. Like strings, the compiler will concatenate tokens until encountering one ending in ".

    "this does something"
    "string -- number"

Bytecodes are prefixes by  a backtick. The remainder of the token should contain a number corresponding to the desired bytecode.

    `100

Anything not recognized as a type is assumed to be a function call. Tokens without a prefix are looked up in the dictionary, and if found, mapped to their corresponding slice and a function call is compiled. If the token is not mapped to a valid name, an error is logged and compilation continues.

Two special cases exist: [ and ]. When the compiler encounters a [ it begins compiling a new quotation, and when a ] is encountered a pointer to this new quote is compiled into the previous one.

# Memory Model

Parable's memory model consists of an array of variable sized regions called *slices*.  Each slice contains one or more values. Both the value and data type are stored.

New slices are allocated by the compiler and bytecode interpreter as needed, and can be allocated on demand using the **request** function. When done with a slice, it can be safely discarded using **release**, or the user interface layer will attempt to reclaim it once no remaining references are found. (This can also be done manually, using **collect-garbage**).

Accessing stored values can be done using **fetch**, and modifications can be made using **store**. Specific values within a slice are referenced using a slice pointer and offset number. Indexing is zero based.

The number of items in a slice can be returned using **length?**.

When a slice is used as a function it is called a *quotation*. Functions operating on *quotations* are called *combinators*.

# The Stack

The stack is a special, global buffer used to pass data between functions. It is setup as a *last in, first out* buffer. Functions can consume or push data to the stack.

## Reordering Data

**dup** duplicates the top item on the stack.

**drop** removes the top item from the stack.

**swap** switches the position of the top two items on the stack.

**over** puts a copy of the second item on the stack on the top of the stack.

**nip** removes the second item from the stack.

**tuck** puts a copy of the top item on the stack under the second item on the stack.

**dup-pair** duplicates the top two items on the stack.

**drop-pair** removes the top two items on the stack.

## Type Conversions

**:n** converts the top item on the stack to a number.

Strings get parsed as a number.

Characters are converted to their ASCII value.

Flags are processed as follows: **true** to -1, **false** to 0.

**:c** converts the top item on the stack to a character.

For strings, this returns the first character in the string.

For numbers, the number is treated as the ASCII character code.

**:s** converts the top item on the stack to a string.

**:p** converts the top item on the stack to a pointer.

**:comment** converts the top item on the stack to a comment.

**:f** converts the top item on the stack to a boolean flag.

**:b** converts the top item on the stack to a bytecode.

**:call** converts the top item on the stack to a function call.

# Arrays

All slices are effectively usable as arrays. The length is stored by the VM as the size of the slice, with the values stored sequentially in the slice. This is simplistic, but easy to understand and makes working with them at low level easy.

Arrays can be created directly as quotations or from the results of executing a quote (**capture-results**). Attaching a permanent name can be done with **define**. Additionally, strings are just character arrays.:

    [ 1 2 3 ] capture-results
    'hello world'
    [ 4 5 6 ]

*All of the above are valid arrays*

New values can be added with **array-push** and removed with **array-pop**.

    #100 &name array-push
    &name array-pop

The length can be obtained with **length?**.

You can use the standard **fetch** and **store** functions to access array elements.

All of this is good, but the array combinators are what make arrays truely useful. There are currently six of interest: **filter**, **map**,  **reduce**, **for-each**, **contains?**, and **index-of**.

**Filter** takes an array and a quote which filters values, and returns a new array that contains values that match the filter. So to find all vowels in a string, we could do:

    'this is a string of sorts'
    [ vowel? ] filter :s

Or, to return values greather than 20:

    [ 10 20 30 4 40 5 50 60 8 98 ]
    [ 20 < ] filter

**Filter** executes the quotation passed once for each item in the array. It passes each item on the stack to the quotation, and then checks the value returned. If **true**, it appends the stored value into a new quote, otherwise it ignores it. The quotation you pass to **filter** should consume the value passed to it and return a valid flag.

**Map** applies a quote to each value in an array. We could square all values in an array like:

    [ 1 2 3 4 5 6 7 8 9 ]
    [ dup * ] map

The quotation should return a single value; this will replace the original value in the array.

**Reduce** takes an array, a value, and a quote. It's useful for doing something with each value in an array. Some examples:

    "add all values in an array"
    [ 1 2 3 4 5 6 7 8 ] 
    0 [ + ] reduce
    
    "find the max value in an array"
    [ 1 2 3 4 5 6 7 8 ] 
    0 [ max ] reduce
    
    "count vowels in a string"
    'this is a string of text' :p
    0 [ vowel? [ 1 + ] if-true ] reduce

**For-each** takes an array and a quote which is applied to each item in the array.

    '*COUNT' value
    'this is a string of sorts'
    [ vowel? [ *COUNT 1 + to *COUNT ] if-true ] for-each
    *COUNT

**For-each** executes the quotation passed once for each item in the array. It passes each item on the stack to the quotation.

**Contains?** takes an array and a value. It returns **true** if the array contains the value, or **false** otherwise.

**Index-of** takes an array and a value. If the value is in the array, it returns the offset. Otherwise it returns an offset of -1.

# Appendix: Terms

*Cell*: a single location within a slice.

*Combinator*: a function operating on a *quotation*.

*Dictionary*: a map of names to slices.

*Quotation*: a *slice* used as a function.

*Slice*: a linear collection of memory cells.

*Stack*: a last in, first out (*LIFO*) buffer that is used for passing data between functions.

*Word*: a named slice.

# Appendix: A List of Words
