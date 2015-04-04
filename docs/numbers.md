# Numbers

Numbers (prefixed by **#**) are the most common data type in Parable. Parable can recognize signed, floating point values in the decimal base. Other bases can be handled using the parsing functions in the standard library.

Examples:


    #1
    #-40
    #3.14159
    
    'DEADBEEF' convert-from-hexadecimal
    '01101' convert-from-binary
    '73' convert-from-octal
    '33319' convert-from-decimal


# Special Constants

The number parser used in Apologue's implementation of Parable also recognizes the following constants:

* #inf
* #-inf
* #nan
