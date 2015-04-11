∑# Arrays

I find the array functions in Parable to be incredibly useful. While I had previously implemented a vocabulary for arrays in Retro, I didn't actually use it for much.

In Parable, arrays are stored in slices. The length is stored by the VM as the size of the slice, with the values stored sequentially in the slice. (I haven't implemented associative arrays yet). This is simplistic, but easy to understand and makes working with them at low level easy. The underlying VM is *not* aware of arrays as a data type, so conversions (via **:s**, **:c**, etc) are needed when working with the contents.

Arrays can be created with **array-from-quote**. Attaching a permanent name can be done with **define**.

    [ #1 #2 #3 ] array-from-quote

Additionally, strings are just character arrays. To use them with the array functions, just use **:p**:

    'hello, world!' :p

New values can be added with **array-push** and removed with **array-pop**.

    #100 &name array-push
    &name array-pop

The length can be obtained with **array-length**.

You an use the standard **fetch** and **store** functions to access array elements.

All of this is good, but the array combinators are what make arrays useful to me. There are currently three of interest: **array-filter**, **array-map**, and **array-reduce**.

**array-filter** takes an array and a quote which filters values, and returns a new array that contains values that match the filter. So to find all vowels in a string, we could do:

    'this is a string of sorts' :p
    [ :c vowel? ] array-filter

Or, to return values greather than 20:

    [ #10 #20 #30 #4 #40 #5 #50 #60 #8 #98 ] array-from-quote
    [ #20 < ] array-filter

**array-map** applies a quote to each value in an array. We could square all values in an array like:

    [ #1 #2 #3 #4 #5 #6 #7 #8 #9 ] array-from-quote
    [ dup * ] array-map

**array-reduce** takes an array, a value, and a quote. It's useful for doing something with each value in an array. Some examples:

    "add all values in an array"
    [ #1 #2 #3 #4 #5 #6 #7 #8 ] array-from-quote
    #0 [ + ] array-reduce
    
    "find the max value in an array"
    [ #1 #2 #3 #4 #5 #6 #7 #8 ] array-from-quote
    #0 [ max ] array-reduce
    
    "count vowels in a string"
    'this is a string of text' :p
    #0 [ :c vowel? [ #1 + ] if-true ] array-reduce

Returning to more mundane functions, Parable also provides a function for checking an array for specific values. This is **array-contains?**.

    #4 [ #1 #2 #3 #4 #5 ] array-contains?
    'pear' [ 'apple'  'banana'  'orange' ] array-contains?

Parable also provide **array-compare** for comparing two arrays and **array-reverse** which flips the order of values in the array.

The last function provided is **array-to-string**. This takes an array and a type constant and generates a string representation of the contents. So we could do:

    [ $h $e $l $l $o ] array-from-quote
    CHARACTER array-to-string
    
    [ #1 #3 #6 ] array-from-quote
    NUMBER array-to-string
