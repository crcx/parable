# Stack Implementation

Parable is built around the concept of a last-in, first-out (LIFO) stack.
This is used to pass data between functions, and generally holds all input
and output generated.

The stack implementation consists of two fundamental parts: something that
holds the values, and something that holds the corresponding data types.
In the implementations done so far, these have been arrays or lists.

Internally, the stack only holds numeric values. The actual types are handled
via conventions within the byte code interpreter. As an example:

        #100.50
        $a
        'hello'

Parable will push a value to the stack:

             Stack    Type
             -------+----------------
             100.50   TYPE_NUMBER
             97       TYPE_CHARACTER
        top: 8        TYPE_STRING

The byte codes will look at the type listing to decide how to interpret
the corresponding values. If the user does something like:

        'hello' to-uppercase

The compiler will generate byte codes:

        BC_PUSH_S     <pointer to 'hello'>
        BC_FLOW_CALL  <pointer to 'to-uppercase'>

The interpreter will push the pointer to 'hello' to the stack, with a type
of TYPE_STRING. When the bytecode for BC\_TO\_UPPER is reached during the
call operation, it will convert the Parable string into a native string,
make the case conversion, convert back to a Parable string, and store the
results in a new slice. All operations on non-numeric data will do any
necessary conversions automatically.

Parable only exposes the data stack. No addressing or alternate stacks are
provided.

The stack values can correspond to one of the following data types:

        Type             Value
        ---------------+------
        TYPE_NUMBER      100
        TYPE_STRING      200
        TYPE_CHARACTER   300
        TYPE_FUNCTION    400
        TYPE_FLAG        500

Any other type value should be considered an error.

## functions

The following functions and data structures are provided by the
reference implementation:

        stack = []
        types = []


**stack_clear()**

Removes all values from the stack.

**stack_push(value, type)**

Push a value (of the specified type) to the stack.

**stack_drop()**

Remove the top value from the stack.

**stack_pop()**

Remove and return the top value from the stack.

**stack_tos()**

Returns a copy of the top value on the stack.

**stack_type()**

Returns the type identifier for the top item on the stack.

**stack_swap()**

Switch the positions of the top two items on the stack.

**stack_dup()**

Duplicates the top value on the stack. If this value is a
string, it makes a copy and pushes the pointer to the copy
rather than duplicate the original pointer.

**stack_over()**

Put a copy of the second item on the stack over the top item.
If the second value is a string, makes a copy of it and pushes
the pointer to that rather than the original pointer.

**stack_tuck()**

Put a copy of the top item under the second item. If the top
value is a string, makes a copy and pushes the pointer to the
copy rather than the original pointer.

**stack\_change\_type(type)**

Convert the type of an item on the stack to a different type.
This is subject to a few rules, based on the requested type:

* TYPE_NUMBER

  * TYPE_STRING is converted to a number
  * If TYPE_STRING can not be converted to a number, a zero is pushed

* TYPE_STRING

  * TYPE_NUMBER is converted to a string
  * TYPE_CHARACTER is converted to a string
  * TYPE_FLAG becomes one of:

     * 'true'
     * 'false'
     * 'malformed flag'

  * TYPE_FUNCTION becomes a string

* TYPE_CHARACTER

  * TYPE_STRING gets the first character returned

* TYPE_FLAG

  * TYPE_STRING conversion based on the following rules:

     * 'true' -> true
     * 'false' -> false
     * anything else is a malformed flag

Unless otherwise noted, only the type portion of the stack record is
modified.

## other functionality

Additional functionality in the byte code is built over the functions
listed above. These are the remaining stack functions and some Python
snippits showing simple implementations of them.

**nip**

Remove the second item from the stack.

        stack_swap()
        stack_drop()

**depth**

Return the number of items on the stack.

        stack_push(len(stack), TYPE_NUMBER)

**dip**

Given a quote and a value, invoke the quote with the value
temporarily removed from the stack.

        quote = stack_pop()
        type = stack_type()
        value = stack_pop()
        interpret(quote)
        stack_push(value, type)

**sip**

Given a quote and a value, execute the quote with the value on the stack,
then place a copy of the value back on the stack after execution.

        quote = stack_pop()
        stack_dup()
        type = stack_type()
        value = stack_pop()
        interpret(quote)
        stack_push(value, type)

**bi**

Given two quotes and value, apply each quote to a copy of the value.

         # get the two quotes
         a = stack_pop()
         b = stack_pop()

         # make a copy of the stack value
         stack_dup()
         type = stack_type()
         value = stack_pop()

         # execute a quote against the original value
         interpret(b)

         # execute a quote against the copied value
         stack_push(value, type)
         interpret(a)

**tri**

Given three quotes and a value, apply each quote to a copy of the value.

         # get the three quotes
         a = stack_pop()
         b = stack_pop()
         c = stack_pop()

         # make a copy of the stack value
         stack_dup()
         type_a = stack_type()
         value_a = stack_pop()

         # make another copy of the stack value
         stack_dup()
         type_b = stack_type()
         value_b = stack_pop()

         # execute a quote against the original value
         interpret(c)

         # execute a quote against the first copy
         stack_push(value_a, type_a)
         interpret(b)

         # execute a quote against the second copy
         stack_push(value_b, type_b)
         interpret(a)

**check_depth(cells)**

Returns True if the stack contains at least *cells* number of items, or
False otherwise. If False, reports an underflow error.
