# Comments

A comment is a string which is ignored by the language. They start and end with a quotation mark.

Examples:

    [ "this is a comment" #33 ] '33' define

Comments get compiled into the functions, but are ignored at runtime. (This is wasteful of space,
but makes it possible to decompile back to a form much closer to the original source).
