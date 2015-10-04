# Variables & Values

Parable provides support for simple variables through two approaches (variables, and values).

## Variables

A variable in Parable is simply a pointer to a slice. The value stored in the first location of the slice can be accessed via **@** and updated using **!**.

For a simple example, consider:

    'temp' variable
    
    "store 100 into the temp variable"
    #100 &temp !
    
    "read the value stored in the variable named temp:"
    &temp @
    
    "Multiply the value in temp by 1000 and update it with the new value:"
    &temp @ #1000 * &temp !

Variables are quick and easy, but when you need to use them a lot, it can make the code messy and harder to follow. It's best to avoid them whenever possible.

## Values

A value is similar to a variable in that it holds a single value. But they're a bit more flexible in that they are actually functions, not raw pointers. They are created using **value** and updated using **to**.

Consider the following, which is functionally equivilent to the example for *variable*:

    'temp' value

    "store 100 into the temp variable"
    #100 to temp

    "read the value stored in the variable named temp:"
    temp

    "Multiply the value in temp by 1000 and update it with the new value:"
    temp #1000 * to temp

Values are cleaner to read than values, but have additional overhead since they need to decide whether they are being read or updated.

Unlike variables, values store and restore the data type automatically. E.g., to store and work on a string you could do:

    'temp' variable
    'hello' &temp !
    &temp @ :p :s 'world!' +

Or:

    'temp' value
    'hello' to temp
    temp 'world!' +
