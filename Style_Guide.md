# Parable Style Guide


## Formatting

* Source should be in ASCII or UTF-8 format
* Use 2 space indents, no tabs
* Avoid trailing whitespace
* Use Unix-style line endings
* All named functions should have a stack comment
* If a function is more than one line, start the code on the line following the stack comment
* Short, one line definitions are preferred, but you can split functions into multiple lines when necessary
* If a quotation would consist of a single named item, it is acceptable to use a pointer in place of a quotation. If working on a project, follow the existing conventions. E.g., either of these are acceptable:

    [ name ]
    &name

## Naming

* Function names may not start with these characters: ' " ` & $ # @ !
* Constants should be named with UPPERCASE
* Variables should use CamelCase names
* Single line definitions are preferred, but long definitions can be split into multiple lines if this significantly improves readability
* All named functions should start with a stack comment
* Use of a **-** as a prefix should be read as "*not <function>*" or "*no <function>*"
* Inquisitive functions should end with a **?** and be past or present tense
* Imperative functions should generally be named with a command phrase
* Declarative functions should normally use a past participle verb form (ending in **-ed**)
* Internal functions left visible in the global dictionary should be enclosed in parenthesis

Variables should be named like:

    Foo
    NumericBase

Or like:

    I

When its name consists of a single character.

Acceptable forms for multi-line definitions:

    [ "stack comment" \
        ... code ... \
        ... code ... ] 'name' :

Or:

    [ "stack comment" \
        ... code ... \
        ... code ... \
    ] 'name' :


## Comments

* Avoid superfluous comments
* All functions should have stack comments

Stack comments in Parable are a compact form, using short codes in place of actual words. These codes are listed in the next section.

A typical comment for a function that takes two arguments and leaves one will look like:

    "xy-z"

In a few cases, functions may consume or leave a variable number of arguments. In this case, we denote it like:

    "n-n || n-"

The codes are:

* **b** is used for *bytecode*
* **c** is used for *character*
* **f** is used for *boolean flag*
* **n** is used for *number*
* **p** is used for *pointer*
* **s** is used for *string*
* **v** is used for generic values
* **x** is used for *function calls*
* **?** is used for an unknown number of values


## Documentation

* All documentation is to be written using Markdown
* Use two blank lines before each section/subsection/etc. title
* Documentation should be released under CC0
