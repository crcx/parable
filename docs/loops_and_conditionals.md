# Loops

Parable provides three looping combinators.

## repeat

repeat is used for simple counted loops. it takes a count and a quote, and
runs the quote the specified number of times.

    #10 [ $a ] repeat
    #0 #10 [ dup #1 + ] repeat

## while-true

Executes a quote repeatedly until the quote returns a non-true flag.


    #10 [ dup #1 - dup #0 <> ] while-true


## while-false

Executes a quote repeatedly until the quote returns a non-false flag.


    #10 [ dup #1 - dup #0 = ] while-false

# Conditionals

## if

Takes a boolean flag and two pointers. If the flag is **true**, it will execute the
first one. If **false**, executes the second.

    #1 #2 = [ 'this is returned if true' ]  [ 'and this is returned if false' ] if

## if-true

    #1 #2 = [ 'this is returned if the flag is true' ] if-true

## if-false

    #1 #2 = [ 'this is returned if the flag is false' ] if-true

## if-number

## if-string

## if-character

## if-pointer

## if-flag


