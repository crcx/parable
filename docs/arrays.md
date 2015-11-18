# Arrays

In Parable, arrays are stored in slices. The length is stored by the VM as the size of the slice, with the values stored sequentially in the slice. This is simplistic, but easy to understand and makes working with them at low level easy. Due to this design, all quotations can be directly treated as arrays.

Arrays can be created directly as quotations or from the results of executing a quote (**capture-results**). Attaching a permanent name can be done with **define**. Additionally, strings are just character arrays. To use them with the array functions, just use **:p**:


    [ 1 2 3 ] capture-results
    'hello world'
    [ 4 5 6 ]

*All of the above are valid arrays*

New values can be added with **array-push** and removed with **array-pop**.

    #100 &name array-push
    &name array-pop

The length can be obtained with **length?**.

You can use the standard **fetch** and **store** functions to access array elements.

All of this is good, but the array combinators are what make arrays truely useful. There are currently four of interest: **for-each**, **filter**, **map**, and **reduce**.

**Filter** takes an array and a quote which filters values, and returns a new array that contains values that match the filter. So to find all vowels in a string, we could do:

    'this is a string of sorts'
    [ vowel? ] filter :s

Or, to return values greather than 20:

    [ 10 20 30 4 40 5 50 60 8 98 ]
    [ 20 < ] filter

**Filter** executes the quotation passed once for each item in the array. It passes each item on the stack to the quotation, and then checks the value returned. If **true**, it appends the stored value into a new quote, otherwise it ignores it. The quotation you pass to **filter** should consume the value passed to it and return a valid flag.

**Map** applies a quote to each value in an array. We could square all values in an array like:

    [ 1 2 3 4 5 6 7 8 9 ]
    [ dup * ] map

**Reduce** takes an array, a value, and a quote. It's useful for doing something with each value in an array. Some examples:

    "add all values in an array"
    [ 1 2 3 4 5 6 7 8 ] 
    0 [ + ] reduce
    
    "find the max value in an array"
    [ 1 2 3 4 5 6 7 8 ] 
    0 [ max ] reduce
    
    "count vowels in a string"
    'this is a string of text' :p
    0 [ vowel? [ 1 + ] if-true ] reduce

#### TODO

**for-each**

**contains?**

**index-of**

...

Returning to more mundane functions, Parable also provides a function for checking an array for specific values. This is **array-contains?**.

    #4 [ #1 #2 #3 #4 #5 ] array-contains?
    'pear' [ 'apple'  'banana'  'orange' ] array-contains?

Parable also provide **array-compare** for comparing two arrays and **reverse** which flips the order of values in the array.
