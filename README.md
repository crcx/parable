# Parable

This is a small language, built over a compact, byte coded virtual machine. It is concatenative, but unlike Forth it has some awareness of data types 
(characters, strings, numbers, pointers, and flags). The syntax is much more rigidly defined. The compiler is part of the virtual machine, all 
functions are built around reverse polish notation, and all code is compiled before being executed.

It draws from my earlier work on Toka and Retro, with extensive use of anonymous, nestable functions (called quotations) for function definition and 
control structure. The language also depends heavily on prefixes to help the compiler decide how to handle tokens. (These are a lot like colors in 
ColorForth, but are represented as single characters rather than color or stylistic elements).

One other major difference from my earlier work is the memory model. Parable divides memory into distinct regions called slices. These are of a fixed 
length (implementation defined), and memory accesses are done by referencing a slice and an offset. This differs from Retro and Toka which both used 
a single linear memory area for all code and data. The use of slices has allowed for some interesting things, including a simple garbage collector, 
and much simpler decompilation back to usable source code.

The core language does not provide a specified I/O model. This is intentional; I now work with a variety of platforms and languages, and enforcing 
the existence of a traditional console environment has proven to be a limiting factor. Parable frees me to implement custom I/O functionality on a 
per-application basis, through the use of custom byte code additions. I have written numerous interfaces, including a simple script interpreter, an 
interactive full screen REPL, browser based interfaces, and an implementation for iOS that provides touch and basic drawing primitives. There is also 
a console script interpreter with support for file I/O, basic output and command line argument support.
