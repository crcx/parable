# Ika

## Overview

Ika is an interface layer for Parable designed for command line scripting. It adds several new functions and byte codes for dealing with files, command line arguments, and libraries.

## Setup

Copy *ika* into your path.

If you want to use the library functionality, you will need to create a couple of directories under your home directory.

    mkdir ~/.parable
    mkdir ~/.parable/library

Any files you copy into the library directory can be loaded using the **import** function.


## Functions

In addition to the standard Parable functions, *Ika* adds the following:

### print

    value -

Display a value

### cr

    -

Display a newline (\n or ASCII 10) character

### open-file

    string<name> string<mode> - file

Open a file and return a file identifier. Valid modes are:

__todo__

### close-file

    file -

Close an open file.

### read-file

    file - character

Read a character from a file.

### write-file

    character file -

Write a character to a file.

### file-position

    file - number<size>

Return the current location within a file.

### file-seek

    number<offset> file -

Move the internal pointer to a new location within a file.

### file-size

    string<name> - number

Return the size of a file.

### delete-file

    string<name> -

Delete a file.

### slurp-file

    string<name> - string<contents>

Open a file, read its contents into a string, and close the file.

### file-exists?

    string<name> - flag

Given a filename, return **true** if the file exists or **false** if it does not.

### arg-count

    - number

Return the number of arguments passed to the script.

### get-arg

    number - string

Return the requested argument.

### import

    string -

Load a file from ~/.parable/library
