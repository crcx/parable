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

