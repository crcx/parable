# Parable Compiler Implementation

The compiler in Parable has a trivial, single-pass design. For the sake of
simplicity, the compiler only deals with a small subset of byte codes and
a very rigid syntax.

## Input Preparation

- source string gets leading and tailing whitespace (space, tab, cr, lf)
  stripped.
- some interfaces will join strings ending with \ to allow for multiline
  definitions
- the string is broken into tokens, with each token separated by a
  space.

## Processing of Tokens

Once prepared, each token gets examined and code is laid down. The
code generated is dependent on the first character of the token.

- if the first character is a #, then the token contains a number

  If the token does not parse as a number, the compiler will set the value to 0
  before generating code and report an error. This will lay down:

        value

  With a stored type of TYPE_NUMBER

- if the first character is a $, then the token is a character

  If more than one character follows the initial $, then only the first is
  compiled. All others are discarded. This will lay down:

        character value

  With a stored type of TYPE_CHARACTER


- if the first character is a &, then the token is a pointer

  The compiler will first try to parse the token as a number. If this
  fails, it will look up the token in the dictionary and compile the
  corresponding slice. This generates the following code:

        pointer

  With a stored type of TYPE_POINTER

  If the token does not correspond to a slot number or named item,
  the compiler will compile a pointer to slot 0, and report an error.

- if the first character is a ', then the token is the start of a string

  This (and the similar " prefix) are more complex. It will check to see
  if the token ends in a ', and if so, extract the text between the quotes
  and store that in a slice, with a zero terminator. If it does not end
  in a quote, it appends the next token and rechecks. This repeats until
  the string ends in a single quote or the end of the input stream is
  reached.

  Once the string is built, the internal text is extracted, and stored into
  a newly allocated slice. Then the compiler generates:

        pointer to new slice

  With a stored type of TYPE_STRING

- if the first character is a ", then the token is the start of a comment

  This behaves like the ' prefix, but looks for a double quote. The generated
  code will be:

        pointer

  With a stored type of TYPE_COMMENT

- if the first character is a `, then the token is a numeric bytecode

  This parses the token as a number, and stores the number directly into the
  generated code. As an example, `300 will compile as:

        300

  With a stored type of TYPE_BYTECODE

- if the token is a [, compilation of a new quote begins

  The compiler will save the current slice and offset, then allocate a new
  slice and switch to compiling into it.

- if the token is a ], compilation of the current quote ends

  In the current slice, this compiles:

        BC_FLOW_RETURN

  Then, it returns to the prior slice and offset and compiles:

        pointer to new slice

  With a stored type of TYPE_POINTER

  NOTE: the new slice will only be appended with a BC_FLOW_RETURN if the
  slice is otherwise empty.

- if none of the prefixes match, compile a call to a function.

  If the token is not matched to a name in the dictionary, the
  compiler will report an error unless the value appears to be a
  number, in which case it will be compiled as in the case of the
  # prefix.

  If it is found, the following code is generated:

        pointer

  With a stored type of TYPE_FUNCTION_CALL

## Other Notes

Byte codes get wrapped into named functions. This is less than ideal from
a performance standpoint, since there is a subroutine call for everything
that corresponds to primitives, apart from pushes.

A more optimal compiler would recognize function calls that correspond to
single instructions and inline the actual instructions. This would have
two immediate benefits:

* smaller code (save one cell per eliminated call)
* faster code (save the call/return overhead)

The disadvantages to this are:

* removes possibility of redefining primitives
* makes decompilation more difficult

Implementing this (or other performance improvements) to the compiler are
worth investigating, but outside the scope of this specification.
