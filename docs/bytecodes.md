# BC\_PUSH\_N

Opcode: 100

This pushes the value in the next memory cell to the stack. The type is
set to NUMBER.

In memory, this is structured as:

    +-----------+
    | BC_PUSH_N |
    +-----------+
    | value     |
    +-----------+

----

# BC\_PUSH\_S

Opcode: 101

This pushes the value in the next memory cell to the stack. The type is
set to STRING.

In memory, this is structured as:

    +-----------+
    | BC_PUSH_S |
    +-----------+
    | pointer   |
    +-----------+

----

# BC\_PUSH\_C

Opcode: 102

This pushes the value in the next memory cell to the stack. The type is
set to CHARACTER.

In memory, this is structured as:

    +-------------+
    | BC_PUSH_C   |
    +-------------+
    | ASCII value |
    +-------------+

----

# BC\_PUSH\_F

Opcode: 103

This pushes the value in the next memory cell to the stack. The type is
set to FUNCTION.

In memory, this is structured as:

    +-----------+
    | BC_PUSH_F |
    +-----------+
    | pointer   |
    +-----------+

----

# BC\_PUSH\_COMMENT

Opcode: 104

This ignores the value in the next cell. The following cell will contain a
pointer to a comment.

In memory, this is structured as:

    +-----------------+
    | BC_PUSH_COMMENT |
    +-----------------+
    | pointer         |
    +-----------------+

----

# BC\_TYPE\_N

Opcode: 110

Convert the value on the stack to a NUMBER.

If the value is a STRING, it is parsed as a number and the result is pushed.

If the value is a CHARACTER, it is converted to the corresponding ASCII code.

If the value is a POINTER, the type is converted to number.

If the value is a FLAG, one of the following is returned: -1 for *true*, 0 for
*false*, or 1 for *malformed flag*.

If the value is a NUMBER, no change occurs.

----

# BC\_TYPE\_S

Opcode: 111

Convert the value on the stack to a new STRING. If the value is already a STRING
this does nothing.

----

# BC\_TYPE\_C

Opcode: 112

Convert the value on the stack to a CHARACTER.

----

# BC\_TYPE\_F

Opcode: 113

Convert the value on the stack to a POINTER.

----

# BC\_TYPE\_FLAG

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

----

# BC\_GET\_TYPE

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

----

# BC\_ADD

Opcode: 200

If the top two values are NUMBER, pop them off the stack, add them together, and
push the resulting NUMBER back to the stack.

If the top two values are STRING, pop them off, concatencate them together, and
push the new STRING to the stack.

The use of this instruction is not defined for other types of values.

----

# BC\_SUBTRACT

Opcode: 201

Pop two NUMBER values off the stack, subtract them, and push the resulting
NUMBER back to the stack.

The use of this instruction is not defined for other types of values.

----

# BC\_MULTIPLY

Opcode: 202

Pop two NUMBER values off the stack, multiply them, and push the resulting
NUMBER back to the stack.

The use of this instruction is not defined for other types of values.

----

# BC\_DIVIDE

Opcode: 203

Pop two NUMBER values off the stack, divide them, and push the resulting
NUMBER back to the stack.

The use of this instruction is not defined for other types of values.

----

# BC\_REMAINDER

Opcode: 204

Pop two NUMBER values off the stack, find the remainder, and push the resulting
NUMBER back to the stack.

The use of this instruction is not defined for other types of values.

----

# BC\_FLOOR

Opcode: 205

Round the NUMBER on top of stack down to the nearest integer value.

The use of this instruction is not defined for other types of values.

----

# BC\_POW

Opcode: 206

... TODO ...

----

# BC\_LOG

Opcode: 207

Return the natural logarithm of a value (to base e)

----

# BC\_LOG10

Opcode: 208

Return the base 10 logarithm of a value

----

# BC\_LOG\_N

Opcode: 209

Given a stack:

    +--------------+-----+
    | number:base  | TOS |
    +--------------+-----+
    | number:value |     |
    +--------------+-----+

Return the logarithm of a value to a given base

----

# BC\_BITWISE\_SHIFT

Opcode: 210

Shifts a value left or right by the specified number of bits. Shifts right if
positive, or left if negative.

----

# BC\_BITWISE\_AND

Opcode: 211

Perform a bitwise AND operation on two NUMBER values.

----

# BC\_BITWISE\_OR

Opcode: 212

Perform a bitwise OR operation on two NUMBER values.

----

# BC\_BITWISE\_XOR

Opcode: 213

Perform a bitwise XOR operation on two NUMBER values.

----

# BC\_RANDOM

Opcode: 214

Return a random value.

----

# BC\_COMPARE\_LT

Opcode: 220

Compare two values to see if one is less than the other.

Given a stack:

    +----+-----+
    | n0 | TOS |
    +----+-----+
    | n1 |     |
    +----+-----+

This will compare n1 < n0, and return a flag

----

# BC\_COMPARE\_GT

Opcode: 221

Compare two values to see if one is greater than the other.

Given a stack:

    +----+-----+
    | n0 | TOS |
    +----+-----+
    | n1 |     |
    +----+-----+

This will compare n1 > n0, and return a flag

----

# BC\_COMPARE\_LTEQ

Opcode: 222

Compare two values to see if one is less than or equal to the other.

Given a stack:

    +----+-----+
    | n0 | TOS |
    +----+-----+
    | n1 |     |
    +----+-----+

This will compare n1 <= n0, and return a flag

----

# BC\_COMPARE\_GTEQ

Opcode: 223

Compare two values to see if one is less than or equal to the other.

Given a stack:

    +----+-----+
    | n0 | TOS |
    +----+-----+
    | n1 |     |
    +----+-----+

This will compare n1 >= n0, and return a flag

----

# BC\_COMPARE\_EQ

Opcode: 224

Compare two values for equality.

If the values are strings, it compares the actual strings, not their pointers.

----

# BC\_COMPARE\_NEQ

Opcode: 225

Compare two values for inequality.

If the values are strings, it compares the actual strings, not their pointers.

----

# BC\_FLOW\_IF

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

----

# BC\_FLOW\_WHILE

Opcode: 301

Takes a quote from the stack, and executes the quote. If the quote returns a
true FLAG, executes it again until the returned flag is false.

----

# BC\_FLOW\_UNTIL

Opcode: 302

Takes a quote from the stack, and executes the quote. If the quote returns a
false FLAG, executes it again until the returned flag is true.

----

# BC\_FLOW\_TIMES

Opcode: 303

----

# BC\_FLOW\_CALL

Opcode: 304

----

# BC\_FLOW\_CALL\_F

Opcode: 305

----

# BC\_FLOW\_DIP

Opcode: 306

----

# BC\_FLOW\_SIP

Opcode: 307

----

# BC\_FLOW\_BI

Opcode: 308

----

# BC\_FLOW\_TRI

Opcode: 309

----

# BC\_FLOW\_RETURN

Opcode: 399

----

# BC\_MEM\_COPY

Opcode: 400

----

# BC\_MEM\_FETCH

Opcode: 401

----

# BC\_MEM\_STORE

Opcode: 402

----

# BC\_MEM\_REQUEST

Opcode: 403

Request a memory slice. Pushes a pointer to the stack.

----

# BC\_MEM\_RELEASE

Opcode: 404

Remove a pointer from the stack and release the corresponding slice.

----

# BC\_MEM\_COLLECT

Opcode: 405

Scan memory and recover unused slices where possible.

The approach I used was to:

- scan the dictionary and stack for pointers to named slices
- keep any slices referenced by these, or their dependencies
- free everything else

----

# BC\_GET\_SLICE\_LENGTH

Opcode: 406

... TODO ...

----

# BC\_SET\_SLICE\_LENGTH

Opcode: 407

... TODO ...

----

# BC\_STACK\_DUP

Opcode: 500

Make a copy of the top item on the stack. (For STRING values, this creates
a copy of the original string).

----

# BC\_STACK\_DROP

Opcode: 501

Remove the top value from the stack.

----

# BC\_STACK\_SWAP

Opcode: 502

Exchange the positions of the top two items on the stack.

----

# BC\_STACK\_OVER

Opcode: 503

----

# BC\_STACK\_TUCK

Opcode: 504

----

# BC\_STACK\_NIP

Opcode: 505

Remove the second item on the stack.

----

# BC\_STACK\_DEPTH

Opcode: 506

Pushes the a NUMBER indicating the number of items on the stack.

----

# BC\_STACK\_CLEAR

Opcode: 507

Removes all values from the stack.

----

# BC\_QUOTE\_NAME

Opcode: 600

Attaches a name to a quotation. This is mapped to *define* by the core language,
and is considered a built-in part of the core language (along with the core
syntax).

Usage:  pointer name --

----

# BC\_STRING\_SEEK

Opcode: 700

----

# BC\_STRING\_SUBSTR

Opcode: 701

string, start, end

----

# BC\_STRING\_NUMERIC

Opcode: 702

Returns a TRUE flag if the string on TOS can be parsed as a NUMBER, or FALSE
otherwise. This consumes the string.

----

# BC\_TO\_LOWER

Opcode: 800

Convert the CHARACTER or STRING value on the stack to lower case. If the value
is a STRING, returns a new STRING.

----

# BC\_TO\_UPPER

Opcode: 801

Convert the CHARACTER or STRING value on the stack to upper case. If the value
is a STRING, returns a new STRING.

----

# BC\_LENGTH

Opcode: 802

Returns the length of a string on the stack. This consumes the string.

----

# BC\_REPORT\_ERROR

Opcode: 900


----

# BC\_SIN

Opcode: 1000

Calculate and return the sine of a radian value

----

# BC\_COS

Opcode: 1001

Calculate and return the cosine of a radian value

----

# BC\_TAN

Opcode: 1002

Calculate and return the tangent of a radian value

----

# BC\_ASIN

Opcode: 1003

Calculate and return the arc sine of a radian value

----

# BC\_ACOS

Opcode: 1004

Calculate and return the arc cosine of a radian value

----

# BC\_ATAN

Opcode: 1005

Calculate and return the arc tangent of a radian value

----

# BC\_ATAN2

Opcode: 1006

Calculate and return atan(y / x) in radians

----
