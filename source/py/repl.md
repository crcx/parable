# Read-Eval-Print-Loop for Parable

A Parable system consists of three fundamental parts:

* The Parable Compiler/Runtime (*parable.py*)
* The Standard Library (*stdlib.p*)
* An Interface Layer (in this case, *repl.py*)

This interface layer isn't the most minimal, but should serve as a decent
starting point and reference.

First up, some boilerplate: we use Python 3, and have a copyright notice, etc.

````
#!/usr/bin/env python3
# Copyright (c) 2013-2016, Charles Childers
# coding: utf-8
````

Now we load Parable:

````
import parable
````

GNU Readline (and some alternatives with better licensing) allows for input
history and editing. It makes for a much nicer user experience. The next few
lines will load this if available and setup tab completion. If readline isn't
provided, it'll just silently fall back to the standard input model.

````
def setup_readline():
    try:
        import readline
        readline.set_completer(tab_completion)
        readline.parse_and_bind("tab: complete")
    except:
        pass
````

Readline allows for tab completion. This is really useful, so we provide a
function (mapped to tab by the **setup_readline()** above). This searches
for the partial current word in the parable dictionary.

````
def tab_completion(text, state):
    options = [x for x in parable.dictionary_names() if x.startswith(text)]
    try:
        return options[state]
    except IndexError:
        return None
````

And that's it for supporting GNU Readline. The REPL doesn't *need* these two
routines, but they don't hurt anything to have and make for a much nicer user
experience.

Ok, now to something interesting. We have two options for loading the standard
library: we can load and compile **stdlib.p** on startup, or we can use a
*snapshot*. Snapshots are precompiled exports of a Parable's state. They
include the memory map, copies of all values in memory, the dictionary
headers, stack contents, and error logs. Loading a snapshot is considerably
faster though more complex.

A snapshot file contains a json formatted version of the data which is then
compressed using bzip2 and then base64 encoded.

The downside to snapshots is that they aren't guaranteed to be portable across
Parable releases. Since they represent the internal Parable state and some of
the implementation details, it's subject to change as the underlying code
evolves.

**TODO: adapt this to try snapshot first, then stdlib.p**

````
def init_from_snapshot(s):
    try:
        import base64, bz2, json
        raw = base64.b64decode(bytes(s, 'utf-8'))   # decode base64
        u = bz2.decompress(raw)                     # decompress json
        j = json.loads(u.decode())                  # parse json
        parable.dictionary = j['symbols']
        parable.errors = j['errors']
        parable.stack = j['stack']
        parable.memory_values = j['memory_contents']
        parable.memory_types = j['memory_types']
        parable.memory_map = j['memory_map']
        parable.memory_size = j['memory_sizes']
        parable.dictionary_hidden_slices = j['hidden_slices']
    except:
        pass
````


````
def get_input():
    done = False
    s = input("\ninput> ")
    while not done:
        if parable.is_balanced(parable.tokenize(s)):
            done = True
        else:
            s = s.strip() + ' '
            s = s + input("       ")
    return s
````

Parable allows interfaces to add new byte codes. This is a good way to deal
with byte codes for I/O and other functionality that may be specific to your
applications.

Here's a simple byte code extension which adds new byte codes:

| Instruction | Stack | Usage                               |
| ----------- | ----- | ----------------------------------- |
| `9000       | "-"   | display the stack                   |
| `9001       | "-"   | display all names in the dictionary |
| `9002       | "-"   | exit REPL                           |
| `9003       | "s-"  | load and evaluate code in a file    |

For easier maintanence, we define a separate function for each, then tie
them all together at the end.

The first is code to display the stack. Parable provides a **parsed_item()**
function which returns a readable (and compilable) representation of a stack
item. We display this, along with and index number.

````
def opcode_display_stack():
    i = 0
    while i < len(parable.stack):
        print("\t{0}\t{1}".format(i, parable.parsed_item(i)))
        i += 1
````

Next, a function to display a list of names from the dictionary. Parable has
**dictionary_names()** which returns a list of these, so we can just iterate
over them. Or, even better, just join the strings:

````
def opcode_display_words():
    print(' '.join(parable.dictionary_names()))
````

To exit the REPL, we have a simple function:

````
def opcode_exit_repl():
    opcode_display_stack()
    exit()
````

Note that we display the stack before quitting; this is a preference of mine,
since it reflects my typical usage model. Any shutdown related functionality
would go here.

And the last addition is for loading and parsing a file. This one is a little
longer, but pretty straightforward:

* See if the file exists
* If yes, read the lines into a list
* Then condense them (since Parable expects each function to correspond to
  a single line of input)
* Then evaluate the condensed lines

Or just use Parable's **parse_bootstrap()** method which handles the last
two bits for us:

````
def opcode_include_file():
    import os
    name = parable.slice_to_string(parable.stack_pop())
    if os.path.exists(name):
        source = open(name).readlines()
        parable.parse_bootstrap(source)
````

And now it's time to tie things together. This uses a very simple set of
if/elif comparisons; for larger sets of instructions it's probably better to
use a dispatch table. (See **parable.md** for an example of this)

````
def opcodes(slice, offset, opcode):
    import os, sys
    if opcode == 9000:
        opcode_display_stack()
    elif opcode == 9001:
        opcode_display_words()
    elif opcode == 9002:
        opcode_exit_repl()
    elif opcode == 9003:
        opcode_include_file()
    return offset
````

Now another helper function: **evaluate()**. To run code in Parable one must:

* obtain a slice
* compile the source into the slice
* interpret the compiled byte code in the slice

This one line function wraps up this functionality for us.

````
def evaluate(s):
    parable.interpret(parable.compile(s), opcodes)
````

And now to tie all of the above together and implement our interface. It
begins with some boilerplate:

````
if __name__ == '__main__':
    import os
````

And then we can setup Parable and try loading GNU Readline. We try to load a
snapshot first (if it exists), otherwise we fall back to manually initializing
and compiling the *stdlib.p*.

````
    if os.path.exists('parable.snapshot'):
        init_from_snapshot(open('parable.snapshot').read())
    else:
        parable.prepare_slices()
        parable.prepare_dictionary()
        parable.parse_bootstrap(open('stdlib.p').readlines())

    setup_readline()
````

Next we use our **evaluate** function to bind the custom byte codes to names:

````
    evaluate("[ \"-\"   `9000 ] '.s' :")
    evaluate("[ \"-\"   `9001 ] 'words' :")
    evaluate("[ \"-\"   `9002 ] 'bye' :")
    evaluate("[ \"s-\"  `9003 ] 'include' :")
````

Display a startup banner:

````
    print('Parable Listener, (c) 2013-2016 Charles Childers')
    print('------------------------------------------------')
    print('.s       Display Stack')
    print('bye      Exit Listener')
    print('words    Display a list of all named items')
    print('------------------------------------------------\n')
````

And (finally) the main loop. This has a couple of key bits.

````
    while True:
````

First, it gets input (and allows for a graceful exit in case of error).

````
        try:
            src = get_input()
        except:
            import sys
            sys.stdout.write("\n")
            exit()
````

Then it evaluates the input. It catches the **KeyboardInterrupt** error to
allow CTRL+C to stop a long execution.

````
        if len(src) >= 1:
            try:
                evaluate(src)
            except KeyboardInterrupt:
                import sys
                sys.stdout.write("\n")
                pass
````

The final bit is to display any error messages and then clear the error log
before the loop begins again.

````
        for e in parable.errors:
            import sys
            sys.stdout.write(e + "\n")
        parable.clear_errors()
````

And that's it: a not quite minimal example of a Parable interface layer.
