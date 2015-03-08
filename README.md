## Overview

Parable is a concatenative, stack-oriented programming language designed
to be clean, consistent, and easily adaptable for use within larger
applications.

## Getting Started

This repository contains implementations in Python, C, and CoffeeScript.

### C

For the C implementation you will need **make** and a C compiler. It has been
tested on Linux and OS X with GCC, TCC, and Clang compilers. Run *make* and
a binary named **pre** should be created.

### Python

The Python implementation of Parable is the most complete and best tested. It
has been used under Python 2, 3, Pythonista, PyPy, and Jython.

There are a couple of options for using it. For running scripts, you will use
**pre**. For interactive use, **legend.py** should be used. (Note: legend
requires a terminal supporting ANSI escape sequences).

## Using PRE

For most implementations, the primary way to use it is via *pre* (short for
*Parable Runtime Environment*). This is an executable that will read in the
source file(s) provided, run the code they contain, and then display the
resulting stack.

