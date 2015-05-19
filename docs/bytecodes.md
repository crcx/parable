# Byte Codes Overview

Parable is built over a byte coded virtual machine.

In memory, the byte codes are stored sequentially in a slice. E.g., given a tiny
definition:

    [ #1 #2 + #3 * ]

The compiler will allocate a slice, and compile the following byte code:

    BC_PUSH_N
    1
    BC_PUSH_N
    2
    BC_ADD
    BC_PUSH_N
    3
    BC_MULTIPLY
    BC_FLOW_RETURN

Most byte codes are single values and occupy a single cell. The few exceptions
to this are the instructions which push values to the stack or directly call a
function. Where the byte codes require more than one cell, a diagram with the
expected structure is provided.

The descriptions of the byte codes will also include a *stack comment*. This
is a single line that indicates what stack values are consumed, and what is
returned after execution. A typical stack comment will look like:

    character string -- number

In this case, the input is on the left side of the --, and the results are on
the right. On each side, the item to the right is the top of stack.


# Byte Code Listing

## BC\_PUSH\_N

Opcode: 100

This pushes the value in the next memory cell to the stack. The type is
set to NUMBER.

In memory, this is structured as:

    +-----------+
    | BC_PUSH_N |
    +-----------+
    | value     |
    +-----------+

Stack Effect:

    -- number

----

## BC\_PUSH\_S

Opcode: 101

This pushes the value in the next memory cell to the stack. The type is
set to STRING.

In memory, this is structured as:

    +-----------+
    | BC_PUSH_S |
    +-----------+
    | pointer   |
    +-----------+

Stack Effect:

    -- string

----

## BC\_PUSH\_C

Opcode: 102

This pushes the value in the next memory cell to the stack. The type is
set to CHARACTER.

In memory, this is structured as:

    +-------------+
    | BC_PUSH_C   |
    +-------------+
    | ASCII value |
    +-------------+

Stack Effect:

    -- character

----

## BC\_PUSH\_F

Opcode: 103

This pushes the value in the next memory cell to the stack. The type is
set to FUNCTION.

In memory, this is structured as:

    +-----------+
    | BC_PUSH_F |
    +-----------+
    | pointer   |
    +-----------+

Stack Effect:

    -- pointer

----

## BC\_PUSH\_COMMENT

Opcode: 104

This ignores the value in the next cell. The following cell will contain a
pointer to a comment.

In memory, this is structured as:

    +-----------------+
    | BC_PUSH_COMMENT |
    +-----------------+
    | pointer         |
    +-----------------+

Comments are kept by the compiler, but ignored at runtime. This allows for
easier decompilation, at a slight performance hit if you use them
extensively.

Stack Effect:

    --

----

## BC\_TYPE\_N

Opcode: 110

Convert the value on the stack to a NUMBER.

If the value is a STRING, it is parsed as a number and the result is pushed.

If the value is a CHARACTER, it is converted to the corresponding ASCII code.

If the value is a POINTER, the type is converted to number.

If the value is a FLAG, one of the following is returned: -1 for *true*, 0 for
*false*, or 1 for *malformed flag*.

If the value is a NUMBER, no change occurs.

Stack Effect:

    value -- number

----

## BC\_TYPE\_S

Opcode: 111

Convert the value on the stack to a new STRING. If the value is already a STRING
this does nothing.

Stack Effect:

    value -- string

----

## BC\_TYPE\_C

Opcode: 112

Convert the value on the stack to a CHARACTER.

Stack Effect:

    value -- character

----

## BC\_TYPE\_F

Opcode: 113

Convert the value on the stack to a POINTER.

Stack Effect:

    value -- pointer

----

## BC\_TYPE\_FLAG

Opcode: 114

Convert the value on the stack to a FLAG.

If value is a NUMBER, the following applies:

    +--------+----------------+
    | -1     | true           |
    +--------+----------------+
    |  0     | false          |
    +--------+----------------+
    | others | malformed flag |
    +--------+----------------+

If the value is a STRING, the following applies:

    +---------+----------------+
    | 'true'  | true           |
    +---------+----------------+
    | 'false' | false          |
    +---------+----------------+
    | others  | malformed flag |
    +---------+----------------+

Behaviour for CHARACTER and POINTER types is not defined.

Stack Effect:

    value -- flag

----

## BC\_GET\_TYPE

Opcode: 120

Pushes a NUMBER to the stack indicating the data type of the top element. Valid
types are:

    +-----+-------------+
    | 100 | *NUMBER*    |
    +-----+-------------+
    | 200 | *STRING*    |
    +-----+-------------+
    | 300 | *CHARACTER* |
    +-----+-------------+
    | 400 | *POINTER*   |
    +-----+-------------+
    | 500 | *FLAG*      |
    +-----+-------------+

Stack Effect:

    value -- value number:type

----

## BC\_ADD

Opcode: 200

If the top two values are NUMBER, pop them off the stack, add them together, and
push the resulting NUMBER back to the stack.

If the top two values are STRING, pop them off, concatencate them together, and
push the new STRING to the stack.

The use of this instruction is not defined for other types of values.

Stack Effect:

    number:A number:B -- number:(A+B)

----

## BC\_SUBTRACT

Opcode: 201

Pop two NUMBER values off the stack, subtract them, and push the resulting
NUMBER back to the stack.

The use of this instruction is not defined for other types of values.

Stack Effect:

    number:A number:B -- number:(A-B)

----

## BC\_MULTIPLY

Opcode: 202

Pop two NUMBER values off the stack, multiply them, and push the resulting
NUMBER back to the stack.

The use of this instruction is not defined for other types of values.

Stack Effect:

    number:A number:B -- number:(A*B)

----

## BC\_DIVIDE

Opcode: 203

Pop two NUMBER values off the stack, divide them, and push the resulting
NUMBER back to the stack.

The use of this instruction is not defined for other types of values.

Stack Effect:

    number:A number:B -- number:(A/B)

----

## BC\_REMAINDER

Opcode: 204

Pop two NUMBER values off the stack, find the remainder, and push the resulting
NUMBER back to the stack.

The use of this instruction is not defined for other types of values.

Stack Effect:

    number:A number:B -- number:(A % B)

----

## BC\_FLOOR

Opcode: 205

Round the NUMBER on top of stack down to the nearest integer value.

The use of this instruction is not defined for other types of values.

Stack Effect:

    number -- number

----

## BC\_POW

Opcode: 206

... TODO ...

----

## BC\_LOG

Opcode: 207

Return the natural logarithm of a value (to base e)

Stack Effect:

    number -- log(number)

----

## BC\_LOG10

Opcode: 208

Return the base 10 logarithm of a value

Stack Effect:

    number -- log10(number)

----

## BC\_LOG\_N

Opcode: 209

Given a stack:

    +--------------+-----+
    | number:base  | TOS |
    +--------------+-----+
    | number:value |     |
    +--------------+-----+

Return the logarithm of a value to a given base

Stack Effect:

    number:value number:base -- number:log(base, value)

----

## BC\_BITWISE\_SHIFT

Opcode: 210

Shifts a value left or right by the specified number of bits. Shifts right if
positive, or left if negative.

----

## BC\_BITWISE\_AND

Opcode: 211

Perform a bitwise AND operation on two NUMBER values.

Stack Effect:

    number:A number:B -- number

----

## BC\_BITWISE\_OR

Opcode: 212

Perform a bitwise OR operation on two NUMBER values.

Stack Effect:

    number:A number:B -- number

----

## BC\_BITWISE\_XOR

Opcode: 213

Perform a bitwise XOR operation on two NUMBER values.

Stack Effect:

    number:A number:B -- number

----

## BC\_RANDOM

Opcode: 214

Return a random value between 0 and 1.

Stack Effect:

    -- number

----

## BC\_SQRT

Opcode: 215

Returns the square root of a value.

Stack Effect:

    number -- number

----

## BC\_COMPARE\_LT

Opcode: 220

Compare two values to see if one is less than the other.

Given a stack:

    +----+-----+
    | B  | TOS |
    +----+-----+
    | A  |     |
    +----+-----+

This will compare A < B, and return a flag

Stack Effect:

    value:A value:B -- flag

----

## BC\_COMPARE\_GT

Opcode: 221

Compare two values to see if one is greater than the other.

Given a stack:

    +----+-----+
    | B  | TOS |
    +----+-----+
    | A  |     |
    +----+-----+

This will compare A > B, and return a flag

Stack Effect:

    value:A value:B -- flag

----

## BC\_COMPARE\_LTEQ

Opcode: 222

Compare two values to see if one is less than or equal to the other.

Given a stack:

    +----+-----+
    | B  | TOS |
    +----+-----+
    | A  |     |
    +----+-----+

This will compare A <= B, and return a flag

Stack Effect:

    value:A value:B -- flag

----

## BC\_COMPARE\_GTEQ

Opcode: 223

Compare two values to see if one is less than or equal to the other.

Given a stack:

    +----+-----+
    | n0 | TOS |
    +----+-----+
    | n1 |     |
    +----+-----+

This will compare n1 >= n0, and return a flag

Stack Effect:

    value:A value:B -- flag

----

## BC\_COMPARE\_EQ

Opcode: 224

Compare two values for equality.

If the values are strings, it compares the actual strings, not their pointers.

Stack Effect:

    value:A value:B -- flag

----

## BC\_COMPARE\_NEQ

Opcode: 225

Compare two values for inequality.

If the values are strings, it compares the actual strings, not their pointers.

Stack Effect:

    value:A value:B -- flag

----

## BC\_FLOW\_IF

Opcode: 300

Takes three elements (two quotes, and a flag), and conditionally executes
one of the quotes based on the flag.

Example stack:

    +------+-----+
    | q0   | TOS |
    +------+-----+
    | q1   |     |
    +------+-----+
    | flag |     |
    +------+-----+

If FLAG is true, executes q1. If false, executes q0.

Stack Effect:

    flag quote:true quote:false --

----

## BC\_FLOW\_WHILE

Opcode: 301

Takes a quote from the stack, and executes the quote. If the quote returns a
true FLAG, executes it again until the returned flag is false.

Stack Effect:

    quote --

----

## BC\_FLOW\_UNTIL

Opcode: 302

Takes a quote from the stack, and executes the quote. If the quote returns a
false FLAG, executes it again until the returned flag is true.

Stack Effect:

    quote --

----

## BC\_FLOW\_TIMES

Opcode: 303

Execute the code in quote the specified number of times.

Stack Effect:

    number quote --

----

## BC\_FLOW\_CALL

Opcode: 304

Calls a function.

In memory, this is structured as:

    +--------------+
    | BC_FLOW_CALL |
    +--------------+
    | pointer      |
    +--------------+

Stack Effect:

    --

----

## BC\_FLOW\_CALL\_F

Opcode: 305

Call a function. Takes a pointer to the function from the stack.

Stack Effect:

    pointer --

----

## BC\_FLOW\_DIP

Opcode: 306

Execute a quotation with a value temporarily removed from the stack.

In a traditional Forth this would be the equivilent of:

    >r ... r>

Stack Effect:

    value quote -- value

----

## BC\_FLOW\_SIP

Opcode: 307

Execute a quotation with a value on the stack that will be restored
after execution completes.

In a traditional Forth this would be the equivilent of:

    dup >r ... r>

Stack Effect:

    value quote -- value

----

## BC\_FLOW\_BI

Opcode: 308

----

## BC\_FLOW\_TRI

Opcode: 309

----

## BC\_FLOW\_RETURN

Opcode: 399

Return from the current function. This is generally stored as the last value in
a function definition.

Stack Effect:

    --

----

## BC\_MEM\_COPY

Opcode: 400

----

## BC\_MEM\_FETCH

Opcode: 401

Fetch a value from a specified location in a slice.

Stack Effect:

    pointer number:offset -- number

----

## BC\_MEM\_STORE

Opcode: 402

Store a value into a slice at the specified location.

Stack Effect:

    number:value pointer number:offset --

----

## BC\_MEM\_REQUEST

Opcode: 403

Request a memory slice. Pushes a pointer to the stack.

Stack Effect:

    -- pointer

----

## BC\_MEM\_RELEASE

Opcode: 404

Remove a pointer from the stack and release the corresponding slice.

Stack Effect:

    pointer --

----

## BC\_MEM\_COLLECT

Opcode: 405

Scan memory and recover unused slices where possible.

The approach I used was to:

- scan the dictionary and stack for pointers to named slices
- keep any slices referenced by these, or their dependencies
- free everything else

Stack Effect:

    --

----

## BC\_GET\_SLICE\_LENGTH

Opcode: 406

Stack Effect:

    pointer -- number

----

## BC\_SET\_SLICE\_LENGTH

Opcode: 407

Stack Effect:

    number pointer --

----

## BC\_STACK\_DUP

Opcode: 500

Make a copy of the top item on the stack. (For STRING values, this creates
a copy of the original string).

Stack Effect:

    value -- value value

----

## BC\_STACK\_DROP

Opcode: 501

Remove the top value from the stack.

Stack Effect:

    value --

----

## BC\_STACK\_SWAP

Opcode: 502

Exchange the positions of the top two items on the stack.

Stack Effect:

    value:A value:B -- value:B value:A

----

## BC\_STACK\_OVER

Opcode: 503

Stack Effect:

    value:A value:B -- value:A value:B value:A

----

## BC\_STACK\_TUCK

Opcode: 504

Stack Effect:

    value:A value:B -- value:B value:A value:B

----

## BC\_STACK\_NIP

Opcode: 505

Remove the second item on the stack.

Stack Effect:

    value:A value:B -- value:B

----

## BC\_STACK\_DEPTH

Opcode: 506

Pushes the a NUMBER indicating the number of items on the stack.

Stack Effect:

    -- number

----

## BC\_STACK\_CLEAR

Opcode: 507

Removes all values from the stack.

Stack Effect:

    ... --

----

## BC\_QUOTE\_NAME

Opcode: 600

Attaches a name to a quotation. This is mapped to *define* by the core language,
and is considered a built-in part of the core language (along with the core
syntax).

Stack Effect:

    pointer string:name --

----

## BC\_FUNCTION\_EXISTS

Opcode: 601

Given a string, returns a flag of *true* if the function exists in the dictionary,
or *false* if it does not.

Stack Effect:

    string -- flag

----

## BC\_LOOKUP\_FUNCTION

Opcode: 602

Given a string, returns a pointer to the slice corresponding to it. If the
function does not exist, a pointer to slice -1 will be returned.

Stack Effect:

    string -- pointer

----

## BC\_HIDE\_FUNCTION

Opcode: 603

Remove a function name from the dictionary. Takes a string, returns nothing.

Stack Effect:

    string --

----

## BC\_STRING\_SEEK

Opcode: 700

Find needle in haystack, return a pointer to it, or -1 if not found.

Stack Effect:

    string:haystack string:needle -- number

----

## BC\_SLICE\_SUBSLICE

Opcode: 701

Extract a portion of a slice, starting at *start* and ending at (but not
including) *end*.

slice, start, end

returns new-slice

Stack Effect:

    pointer number:start number:end -- pointer

----

## BC\_STRING\_NUMERIC

Opcode: 702

Returns a TRUE flag if the string on TOS can be parsed as a NUMBER, or FALSE
otherwise. This consumes the string.

Stack Effect:

    string -- flag

----

## BC\_TO\_LOWER

Opcode: 800

Convert the CHARACTER or STRING value on the stack to lower case. If the value
is a STRING, returns a new STRING.

Stack Effect:

    value -- value

----

## BC\_TO\_UPPER

Opcode: 801

Convert the CHARACTER or STRING value on the stack to upper case. If the value
is a STRING, returns a new STRING.

Stack Effect:

    value -- value

----

## BC\_REPORT\_ERROR

Opcode: 900

Takes a string, and adds it to the error log.

Stack Effect:

    string --

----

## BC\_SIN

Opcode: 1000

Calculate and return the sine of a radian value

Stack Effect:

    number -- number

----

## BC\_COS

Opcode: 1001

Calculate and return the cosine of a radian value

Stack Effect:

    number -- number

----

## BC\_TAN

Opcode: 1002

Calculate and return the tangent of a radian value

Stack Effect:

    number -- number

----

## BC\_ASIN

Opcode: 1003

Calculate and return the arc sine of a radian value

Stack Effect:

    number -- number

----

## BC\_ACOS

Opcode: 1004

Calculate and return the arc cosine of a radian value

Stack Effect:

    number -- number

----

## BC\_ATAN

Opcode: 1005

Calculate and return the arc tangent of a radian value

Stack Effect:

    number -- number

----

## BC\_ATAN2

Opcode: 1006

Calculate and return atan(y / x) in radians

----

