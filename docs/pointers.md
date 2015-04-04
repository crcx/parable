# Pointers

In Parable, a pointer is a numeric value that points to a slice. They do not point to any specific offset (offsets are numbers). Pointers are created using the **&** prefix or via the **:p** function. The **&** prefix can be used with a symbol name, in which case it will lookup the corresponding slice in the dictionary.

Some examples:

    &100
    &50
    &array-from-quote
