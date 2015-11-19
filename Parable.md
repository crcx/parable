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

