# Parable

Parable is a programming language and collection of development tools.

## Language

This is a small language, built over a compact, byte coded virtual machine. It is concatenative, but unlike Forth it provides data types (characters, strings, numbers, pointers, comments, function calls, and flags). The syntax is much more rigidly defined with all functionality being built around reverse Polish notation and the data stack. The compiler is an integral piece of the language and all code is compiled before being executed.

It draws from Toka and Retro, making extensive use of anonymous, nestable functions (called quotations) for function definition and control structure. The language also depends heavily on prefixes to help the compiler decide how to handle tokens. (These are a lot like colors in ColorForth, but are represented as single characters rather than color or stylistic elements).

One other major difference is the memory model. Parable divides memory into distinct regions called slices. These grow and shrink as needed, and memory accesses are done by referencing a slice and an offset. Each memory cell in a slice is tagged with the data type stored in it, allowing Parable to treat code and data interchangeably. The use of slices has allowed for some interesting things, including a simple garbage collector, and much simpler decompilation back to usable source code.

## Interfaces

The core Parable language does not provide a user interface. Various interface layers are available. The following are included with the standard Parable distribution:

*Legend* is a full screen interface for terminals.

*Pre* is the basic command line scripting environment.

*Ika* is a better command line scripting environment which adds file I/O and additional I/O functions.

*Punga* is a CGI based interface.

Additional interfaces are available separately:

*Cyanide* is a command line and CGI capable scripting environment with additional functions for file and terminal I/O as well as CGI form processing and dispatch.

*Apologue* is a development environment for iOS. It uses a CGI backend for processing code, and includes browsers for results, documentation, and a memory browser (with integral decompiler).

## License

Parable is open source under the ISC License. See the LICENSE file for full details.