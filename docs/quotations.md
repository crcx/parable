# Quotations

Parable is built around the use of a stack for passing data, and anonymous functions called *quotations*. Quotations can be nested, named, and passed around on the stack.

To create a quotation, simply wrap the code sequence in an open and closing square bracket (separated by a whitespace). E.g. to create a quotation returning the string *'hello world'* just do:

    [ 'hello world' ]

Quotations can be nested. This can be seen here:

    [ [ 'this quote returns a string' ] ]

And to name a quotation (or other <a href="pointers.html">pointer</a>), just use **define**:

    [ 'hello world' ]  'hello' define

# Combinators

Functions that operate on quotations are called *combinators*. Parable groups these loosely into three broad categories: *compositional*, *execution flow*, and *data flow*.

## Compositional

A compositional combinator takes elements from the stack and returns a new quotation.

### Curry

**Curry** takes a value and a quote and returns a new quote applying the specified quote to the specified value.

## Execution Flow

Combinators of this type execute other functions.


### Fundamental

#### Invoke

**Invoke** takes a quote and executes it immediately.

    #4 [ #100 * ] invoke
    #33 &+ invoke

### Conditionals

Retro provides four combinators for use with conditional execution of quotes. These are **if**,**ifTrue**,**ifFalse**, and**when**.

#### if

**if** takes a flag and two quotes from the stack. If the flag is true, the first quote is executed. If false, the second quote is executed.

    true  [ 'true' ] [ 'false' ] if
    false [ 'true' ] [ 'false' ] if

#### if-true

**if-true** takes a flag and one quote from the stack. If the flag is true, the quote is executed. If false, the quote is discarded.

    true  [ 'true' ] if-true
    false [ 'true' ] if-true

#### if-false

**if-false** takes a flag and one quote from the stack. If the flag is false, the quote is executed. If true, the quote is discarded.

    true  [ 'false' ] if-false
    false [ 'false' ] if-false

### Looping

Several combinators are available for handling various looping constructs.

#### while-true

**while-true** takes a quote from the stack and executes it repeatedly as long as the quote returns a **true** flag on the stack. This flag must be well formed.

    #10 [ dup #1 - dup #0 <> ] while-true

#### while-false

**while-false** is the inverse of **while-true**. It will execute the quotation repeatedly until the quote returns a **true** flag.

#### repeat

**repeat** takes a count and quote from the stack. The quote will be executed the number of times specified. No indexes are pushed to the stack.

    #1 #10 [ dup #1 + ] repeat

## Data Flow

These combinators exist to simplify stack usage in various circumstances.

### Preserving

Preserving combinators execute code while preserving portions of the data stack.

#### dip

**dip** takes a value and a quote, moves the value off the main stack temporarily, executes the quote, and then restores the value.

    #10 #20 [ #1 + ] dip

Would yield the following on the stack:

    #11 #20

#### sip

**sip** is similar to **dip**, but leaves a copy of the original value on the stack during execution of the quote. So:

    #10 [ #1 + ] sip

Leaves us with:
    
    #11 #10

### Cleave

Cleave combinators apply multiple quotations to a single value or set of values.
    
#### bi

**bi** takes a value and two quotes, it then applies each quote to a copy of the value.

    #100 [ #1 + ] [ #1 - ] bi

#### tri

**tri** takes a value and three quotes. It then applies each quote to a copy of the value.

    #100 [ #1 + ] [ #1 - ] [ dup * ] tri
    
### Spread

Spread combinators apply multiple quotations to multiple values. The asterisk suffixed to these function names signifies that they are spread combinators.

#### bi*

**bi*** takes two values and two quotes. It applies the first quote to the first value and the second quote to the second value.

    #1 #2 [ #1 + ] [ #2 * ] bi*

#### tri*

**tri*** takes three values and three quotes, applying the first quote to the first value, the second quote to the second value, and the third quote to the third value.

    #1 #2 #3 [ #1 + ] [ #2 * ] [ #1 - ] tri*
    
### Apply

Apply combinators apply a single quotation to multiple values. The at (@) sign suffixed to these function names signifies that they are apply combinators.
    
#### bi@

**bi@** takes two values and a quote. It then applies the quote to each value.

    #1 #2 [ #1 + ] bi@

#### tri@

**tri@** takes three values and a quote. It then applies the quote to each value.

    #1 #2 #3 [ #1 + ] tri@
