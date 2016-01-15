# Parable Language


## Syntax

Parable code consists of whitespace delimited tokens. Each token can have a prefix which tells the language how to treat it.

    Prefix    Token is...
    ------    -----------
    #         Number
    $         Character
    &         Pointer
    '         String
    "         Comment

Strings and comments start and end with the delimiter (either ' or "). Either can obtain spaces.

Everything is done using reverse polish notation. There are no functions that parse or modify the input.

## Parsing and Compiling

Parable's parser and compiler are closely coupled. All code is compiled before being run, and code has no direct access to the parser.

The basic process is:

* Split source into array of tokens
* Iterate over the tokens, compiling them based on the prefixes
* Return a pointer to the slice containing the compiled code

The second part of this is where the work gets done. An example implementation of this in Parable would be:

    [ "s-..." \
      [ [ [ current-prefix $# eq? ]  [ compile-number ] ] \
        [ [ current-prefix $$ eq? ]  [ compile-character ] ] \
        [ [ current-prefix $& eq? ]  [ compile-pointer ] ] \
        [ [ current-prefix $' eq? ]  [ compile-string ] ] \
        [ [ current-prefix $" eq? ]  [ compile-comment ] ] \
        [ [ current-token numeric? ] [ current-token :n *Slice push ] ] \
        [ [ current-token '[' eq? ]  [ handle-[ ] ] \
        [ [ current-token ']' eq? ]  [ handle-] ] ] \
        [ [ true ]                   [ compile-funcall ] ] \
      ] when ] 'compile-token' define

Basically the parser will look at each prefix and invoke a handling function for the specific type.

There are a couple of special cases: **[** and **]**.

In Parable code is compiled into anonymous functions called *quotations*. These start with **[** and end with **]**. The compiler itself handles this; these do not exist as separate functions within the language.

If the token is not handled by one of the prefixes, it will be treated as a function call.

----

# Overview

Parable consists of a compiler and bytecode interpreter.

The compiler takes each line of source, parses it into tokens, and then creates a new *quotation* containing the bytecode appropriate to each token. The behaviour of each token is determined by *prefixes* (single characters at the start of the token).

After compilation is completed, the bytecode interpreter will execute the code in the newly compiled quotation.

*Unlike Forth, all Parable code is compiled before being run. There is no concept of "interpret vs compile time actions" in Parable.*

The language is rigidly built around reverse polish structure and the data stack. The language does not provide access to the parser and no facilities exist for modifying the compiler behaviour from user level code.

*The compiler and bytecode interpreter can be extended, but only by the user interface layer, not in Parable itself.*

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

# Data Types

Parable recognizes a variety of data types. These have been briefly covered earlier, this section aims to expand on them.

## Numbers

Numbers are signed, floating point values. They can be specified using the **#** prefix or Parable will attempt to recognize them automatically.

Examples:

    1
    -40
    3.14159
    #inf
    #-inf
    #nan

Some notes:

* Numbers are only recognized in base 10.
* All numbers are floating point and suffer from the inaccuracies that implies

Conversions:

* Strings are parsed as signed, decimal, floating point values.
* Characters are converted to their character code (normally an ASCII value).
* For flags, **true** is -1, **false** is 0, and any other value returns the flag value.
* For other types, change the internal type to number.

## Characters

A character is a single symbol prefixed by **$**. Parable only guarantees recognition of the ASCII character set; but work on Unicode support is being performed.

Examples:

    $a
    $1
    $$
    $?
    $~

Notes:

* Unicode support is being worked on, but should not be considered reliable at this point

Conversion rules:

* If the source value is a number, treat the number as the character code
* If the source is a string, return the first character

## Strings and Comments

A string is a slice containing a sequence of characters. They are denoted using a single quote at the beginning and end.

A comment is a string that is ignored by the language. It is denoted using a double quote at the beginning and end.

Examples:

    'hello, world'
    'this is a string'
    'yet another, much longer string containing a bunch of data'
    
    "this is a comment"
    "(and so is this)"

Each string is stored in a separate slice. String length is the same as the corresponding slice length.

Notes:

* Make sure to use use single quotes (') for strings. Double quotes are used for comments.
* All restrictions on characters apply to strings (and comments)

Conversions:

* For strings, convert to a string and store in a new slice.
* For characters, return a new string containing the character as the only value.
* For flags, return *'true'* for **true**, *'false'* for **false**, and *'malformed flag'* for invalid flag.
* For pointer, convert the internal type to string.
* If the value is any other type, silently ignore the request.
* No conversions to or from the comment type are possible.

## Pointers

In Parable, a pointer is a numeric value that points to a slice. They do not point to any specific offset (offsets are numbers). Pointers are created using the **&** prefix or via the **:p** function. The **&** prefix can be used with a symbol name, in which case it will lookup the corresponding slice in the dictionary.

Some examples:

    &100
    &50
    &capture-results

Conversions:

* For all types, change the internal type to pointer.
* This really only has meaning for numbers and strings.

## Flags

A flag is a boolean value. They are typically returned by comparison functions or by the **true** and **false** functions.

Flags have three states:

* true
* false
* invalid

A **true** flag corresponds to a numeric value of -1. A **false** flag corresponds to a value of 0. Any other value is considered invalid.

Conversions:

* For numbers, -1 is **true**, 0 is **false**, and any other value is *invalid*.
* For strings, a value of *true* is **true**, *false* is **false**, and other values are *invalid*.
* For other types, the raw value is treated as a conversion from the *number* type.

## Bytecode

A bytecode corresponds to an instruction understood by the bytecode interpreter. When compiling, they are prefixed by a single backtick (**`**). In normal circumstances you should not need to use this. If you are storing bytecodes, use **:b** to convert a number to the *bytecode* type prior to storing.

Conversions:

* Only numbers can be converted to bytecode type.
* Calling **:b** with any other type will be silently ignored.

## Function Calls

A function call corresponds to a compiled call to a function. When compiling, there is no prefix for this: just refer to a function by name. If you are storing function calls use **:call** to convert the pointer to a function call prior to storing.

Conversions:

* Only numbers and pointers can be converted to function calls.
* Calling **:call** with any other type will be silently ignored.

# Variables and Values

Parable provides two simple data structures: variables and values.

Variables are a quick and dirty way to store single values in a slice. Typically access to values is done by using **fetch** and **store**. This can get messy. For instance:

    request 'a' define
    100 &a 0 store
    &a 0 fetch 1 + &a 0 store

The need to reference the offsets obscures the intent. Variables simplify this to:

    'a' variable
    100 &a !
    &a @ 1 + &a !

The **@** replaces the **0 fetch** and **!** replaces **0 store**. It's a small, but useful improvement. 

Values take this a step further. A value provides a named function that either returns or updates a single value. The above example can become:

    'a' value
    100 to a
    a 1 + to a

In this, referencing the function itself returns the stored value. Using **to** sets an internal flag that tells the function to replace its stored value with the top value on the stack.

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
    [ 20 lt? ] filter

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

*Offset*: a location within a slice.

*Quotation*: a *slice* used as a function.

*Slice*: a linear collection of memory cells.

*Stack*: a last in, first out (*LIFO*) buffer that is used for passing data between functions.

*Word*: a named slice.

# Appendix: Compiler Forms

Parable's compiler lays down very simple forms for each data type. It does not do any optimizations. This is intentional, to allow for easier decompilation and debugging. *It is possible to write an optimizer that scans the compiled bytecode and generates more optimal code prior to running, but this is left as an exercise for the interface layer developer.*

### Bytecode

The compiler lays down the numeric value of the bytecode, and set the type to *TYPE_BYTECODE*.

### Flags

The compiler lays down the numeric value of the flag, and set the type to *TYPE_FLAG*.

### Numbers

The compiler lays down the numeric value of the token, and set the type to *TYPE_NUMBER*.

### Character

The compiler lays down the numeric value (normally ASCII code) of the token, and set the type to *TYPE_CHARACTER*.

### Strings

The parser concatenates tokens until it encounters one ending in a single quote. It then stores the character codes into a new slice and stores a pointer to this slice into the current one. When done, it sets the type to *TYPE_STRING*.

### Comments

The parser concatenates tokens until it encounters one ending in a double quote. It then stores the character codes into a new slice and stores a pointer to this slice into the current one. When done, it sets the type to *TYPE_COMMENT*.

### Pointers

If the token maps to a name in the dictionary, this will store a pointer to the slice that corresponds to it. Otherwise, the token is converted to a number, and the type is set to *TYPE_POINTER*. 

### Function Calls

If the token maps to a name in the dictionary, this will store a pointer to the slice that corresponds to it and the type is set to *TYPE_FUNCTION_CALL*. If the dictionary search fails, report an error and compiles nothing.

### Nested Quotations

A new slice is allocated, and compilation switches to this slice. When the ending ] is encountered, switch back to the previous slice and compile a pointer into the original slice. The pointer has a *TYPE_POINTER* assigned.

A special case exists if the quotation is empty (a **[ ]** pair). In this case a return instruction is compiled into the otherwise empty quote and then the pointer is compiled.


# Appendix: Error Messages

Parable provides several standard error messages for various cases. These are currently:

## E01: Stack Underflow

This will also report the slice and offset where the error occurred.

## E02: Type Mismatch

This will also report the slice and offset where the error occurred.

## E03: Compile Error

This can be thrown in the following conditions:

* A non-numeric pointer does not correspond to a name in the dictionary
* When using #, the token is not a valid base 10 number
* When compiling a function call, the token does not correspond to a name in the dictionary

## E04: Divide by Zero

# Appendix: Garbage Collection

Parable's memory model leads to a lot of slices being allocated and used for short periods of time. While it's possible to manually track and release these, this is not something that is normally needed. The memory manager in Parable includes a *garbage collector* which is capable of finding slices that are no longer in use and reclaiming them when necessary.

The garbage collector scans all named slices and pointers on the stack (including strings and comments) for references to other slices. Each reference is added to a list of slices to be kept. When all slices have been scanned, any allocated slices that are not referenced are released.

This process occurs in the following circumstances:

* When a **request** fails initially garbage will be collected and the request will be reattempted.
* When **collect-garbage** is manually called.
* Some interfaces will collect garbage periodically as well. E.g., many will perform a collection after initial processing of *stdlib.p* or at the end of a long execution cycle.

The following are considered references:

* Pointers
* Strings
* Comments
* Function Calls
