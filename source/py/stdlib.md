# Parable's Standard Library

The heart of the Parable language is very minimal. You have some minimal
syntax (**[** and **]** for creating quotes, prefixes for the individual
tokens) and a single function (**:**) to attach a name to a slice.

But the underlying virtual machine provides a fairly wide array of basic
functionality via the byte codes. The standard library will take these,
assign names to each, and then use them to implement an actually useful
language.

Starting off, a simple list with the version information. Parable's version
numbering is done like this:

| Code       | Use                                     | Type      |
| ---------- | --------------------------------------- | --------- |
| YYYY       | Release year                            | Number    |
| MM         | Release month                           | Number    |
| PATCHLEVEL | Indicate bugfixes after initial release | Character |

For the initial release, patchlevel is set as $_. The first bugfix level
would be $A and so on.

````
[ "-nnc"   2016 05 $_ ] 'ParableVersion' :
````

With that taken care of we can proceed to attach names to the byte codes. This
will start a pattern for how functions are defined: a stack comment, followed
by the code, and ending with a short description of what the function does
(called the *docstring*).

We'll also introduce some terminology here: functions are called *words* and
*words* which operate on slices of memory (including other functions) are
called *combinators*. Oh, and *primitives* are words which correspond directly
to the Parable byte codes.

Ok, so here are the primitives:

````
[ "-"      `0  "Does nothing" ] 'nop' :
[ "vt-v"   `1  "Convert a value to the specified type" ] 'set-type' :
[ "v-vn"   `2  "Return the type constant for a value" ] 'type?' :
[ "nn-n"   `3  "Add two numbers or concatenate two strings, remarks, or slices" ] '+' :
[ "nn-n"   `4  "Subtract n2 from n1" ] '-' :
[ "nn-n"   `5  "Multiply two numbers" ] '*' :
[ "nn-n"   `6  "Divide n1 by n2" ] '/' :
[ "nn-n"   `7  "Divide n1 by n2, returning the remainder" ] 'rem' :
[ "nn-n"   `8  "Return n1 to the power n2" ] '^' :
[ "nn-n"   `9 "Return the logarithm of a number in the specified base" ] 'log<n>' :
[ "nn-n"   `10 "Perform a bitwise shift" ] 'shift' :
[ "nn-n"   `11 "Bitwise AND operation" ] 'and' :
[ "nn-n"   `12 "Bitwise OR operation" ] 'or' :
[ "nn-n"   `13 "Bitwise XOR operation" ] 'xor' :
[ "-n"     `14 "Return a random number" ] 'random' :
[ "n-n"    `15 "Obtain the square root of a number" ] 'sqrt' :
[ "nn-f"   `16 "True if n1 < n2 or false otherwise" ] 'lt?' :
[ "nn-f"   `17 "True if n1 > n2 or false otherwise" ] 'gt?' :
[ "nn-f"   `18 "True if n1 <= n2 or false otherwise" ] 'lteq?' :
[ "nn-f"   `19 "True if n1 >= n2 or false otherwise" ] 'gteq?' :
[ "vv-f"   `20 "True if n1 == n2 or false otherwise" ] 'eq?' :
[ "vv-f"   `21 "True if n1 != n2 or false otherwise" ] '-eq?' :
[ "fpp-"   `22 "If flag is true, invoke p1; otherwise invoke p2" ] 'if' :
[ "p-"     `23 "Invoke p (which should return a flag) until the returned flag is false" ] 'while' :
[ "p-"     `24 "Invoke p (which should return a flag) until the returned flag is true" ] 'until' :
[ "np-"    `25 "Invoke slice p the specified number of times" ] 'times' :
[ "p-"     `26 "Run the code in slice p" ] 'invoke' :
[ "vp-v"   `27 "Remove value and invoke the quote. Restore value when execution completes." ] 'dip' :
[ "vp-v"   `28 "Invoke the quote. After execution complets, restore a copy of the value to the stack" ] 'sip' :
[ "vpp-?"  `29 "Apply each quote to a copy of the value" ] 'bi' :
[ "vppp-?" `30 "Apply each quote to a copy of the value" ] 'tri' :
[ "-"      `31 "Abort the current execution cycle" ] 'abort' :
[ "pp-"    `32 "Copy the contents of the first slice to the second one" ] 'copy' :
[ "pn-v"   `33 "Fetch a value stored at the specified offset within the specified slice" ] 'fetch' :
[ "vpn-"   `34 "Store a value into the specified offset within the specified slice" ] 'store' :
[ "-p"     `35 "Request a new slice and return a pointer to it" ] 'request' :
[ "p-"     `36 "Release a previously allocated slice" ] 'release' :
[ "-"      `37 "Tell Parable that this is a good time to scan memory for unused slices and reclaim them" ] 'collect-garbage' :
[ "p-n"    `38 "Return the last offset in a slice" ] 'get<final-offset>' :
[ "np-"    `39 "Set the last index in a slice (can be used to shrink or grow a slice)" ] 'set<final-offset>' :
[ "tpn-"   `40 "Set the stored type for the value at offset with the slice to the specified type." ] 'store<type>' :
[ "pn-n"   `41 "Get the stored type for a value within a slice." ] 'fetch<type>' :
[ "v-vv"   `42 "Duplicate the top value on the stack" ] 'dup' :
[ "v-"     `43 "Discard the top value on the stack" ] 'drop' :
[ "vV-Vv"  `44 "Switch the positions of the top two items on the stack" ] 'swap' :
[ "-n"     `45 "Return the number of items on the stack" ] 'depth' :
[ "s-"     `47 "Remove the named item from the dictionary" ] 'hide-word' :
[ "ss-n"   `48 "Search for substring (s2) in a source string (s1). Returns #nan if not found." ] 'find' :
[ "pnn-p"  `49 "Return a new slice containing the contents of the original slice, starting from the specified offset and ending at (but not including) the ending offset." ] 'subslice' :
[ "s-f"    `50 "If string can be converted to a number, return true, otherwise return false" ] 'numeric?' :
[ "p-p"    `51 "Reverse the order of items in a slice. This modifies the original slice." ] 'reverse' :
[ "v-v"    `52 "Convert a string or character to lowercase" ] 'to-lowercase' :
[ "v-v"    `53 "Convert a string or character to uppercase" ] 'to-uppercase' :
[ "s-"     `54 "Add a string to the error log" ] 'report-error' :
[ "-p"     `55 "Return an array of strings corresponding to names in the dictionary" ] 'vm.dict<names>' :
[ "-p"     `56 "Return an array of slices corresponding to the named items in the dictionary" ] 'vm.dict<slices>' :
[ "n-n"    `57 "Return the sine of a number" ] 'sin' :
[ "n-n"    `58 "Return the cosine of a number" ] 'cos' :
[ "n-n"    `59 "Return the tangent of a number" ] 'tan' :
[ "n-n"    `60 "Return the arc sine of a number" ] 'asin' :
[ "n-n"    `61 "Return the arc cosine of a number" ] 'acos' :
[ "n-n"    `62 "Return the arc tangent of a number" ] 'atan' :
[ "n-n"    `63 "Return the arc tangent of a number" ] 'atan2' :
[ "-p"     `64 "Return an array indicating which slices are allocated and which are free. Each index corresponds to a slice. If the stored value is 0, the slice is free. If 1, the slice is allocated." ] 'vm.memory<map>' :
[ "-p"     `65 "Return an array indicating the size of each slice (in cells). Each index corresponds to a slice; the stored value is the length of the slice." ] 'vm.memory<sizes>' :
[ "-p"     `66 "Return an array of slice numbers which are currently marked as allocated." ] 'vm.memory<allocated>' :
````

And with that we're ready to start building a useful language.

This begins by naming the data types. By convention Parable uses UPPERCASE for
naming constants. Note that a constant is just a word that returns a single
value.

````
[ "-n"  100 "Type constant" ] 'NUMBER' :
[ "-n"  200 "Type constant" ] 'STRING' :
[ "-n"  300 "Type constant" ] 'CHARACTER' :
[ "-n"  400 "Type constant" ] 'POINTER' :
[ "-n"  500 "Type constant" ] 'FLAG' :
[ "-n"  600 "Type constant" ] 'BYTECODE' :
[ "-n"  700 "Type constant" ] 'REMARK' :
[ "-n"  800 "Type constant" ] 'FUNCALL' :
[ "-n"    0 "Type constant" ] 'UNKNOWN' :
````

Now that the types are named, we can combine them with **set-type** to allow
for conversions between them. We'll define a series of words for doing this.

````
[ "v-b" BYTECODE  set-type  "Convert value to a BYTECODE" ] ':b' :
[ "v-n" NUMBER    set-type  "Convert value to a NUMBER" ] ':n' :
[ "v-s" STRING    set-type  "Convert value to a STRING" ] ':s' :
[ "v-c" CHARACTER set-type  "Convert value to a CHARACTER" ] ':c' :
[ "v-p" POINTER   set-type  "Convert value to a POINTER" ] ':p' :
[ "v-f" FLAG      set-type  "Convert value to a FLAG" ] ':f' :
[ "v-f" FUNCALL   set-type  "Convert value to a FUNCALL" ] ':x' :
[ "v-c" REMARK    set-type  "Convert value to a REMARK" ] ':r' :
[ "v-v" UNKNOWN   set-type  "Convert value to a UNKNOWN" ] ':u' :
````

(I'll put in a brief note here: **UNKNOWN** is set to 0; Parable doesn't care
what this is: anything that's not an actual named type is assumed to be of
unknown type.)

And then we can also define words to compare a value to a type. These can be
helpful in filtering invalid inputs.

````
[ "v-vf" type? NUMBER    eq?  "Return true if value is a NUMBER or false otherwise" ] 'number?' :
[ "v-vf" type? STRING    eq?  "Return true if value is a STRING or false otherwise" ] 'string?' :
[ "v-vf" type? CHARACTER eq?  "Return true if value is a CHARACTER or false otherwise" ] 'character?' :
[ "v-vf" type? POINTER   eq?  "Return true if value is a POINTER or false otherwise" ] 'pointer?' :
[ "v-vf" type? FLAG      eq?  "Return true if value is a FLAG or false otherwise" ] 'flag?' :
[ "v-vf" type? BYTECODE  eq?  "Return true if value is a BYTECODE or false otherwise" ] 'bytecode?' :
[ "v-vf" type? REMARK    eq?  "Return true if value is a REMARK or false otherwise" ] 'remark?' :
[ "v-vf" type? FUNCALL   eq?  "Return true if value is a FUNCALL or false otherwise" ] 'funcall?' :
[ "v-vf" type? UNKNOWN   eq?  "Return true if value is UNKNOWN or false otherwise" ] 'unknown?' :
````

So now we have our *primitives* named, types named, and some additional words
to compare and convert types to expected forms. Now it's time to shift focus
into other areas that will help improve the usefulness significantly.

The lowest level stack operations (provided as primitives) are **swap**,
**dup**, **drop**, **depth**, **dip**, **sip**, **bi**, and **tri**. There
are several other stack shufflers from Forth that I've found useful.

````
[ "vV-vVv"
  [ dup ] dip swap
  "Put a copy of the second item on top of the stack"
] 'over' :

[ "vV-VvV"
  [ swap ] sip
  "Put a copy of the top item below the second item"
] 'tuck' :

[ "vV-V"
  swap drop
  "Remove the item below the top item on the stack"
] 'nip' :

[ "...-"
  depth [ drop ] times
  "Remove all items from the stack"
] 'reset' :

[ "vV-vVvV"
  over over
  "Duplicate the top two items on the stack"
] 'dup-pair' :

[ "vv-"
  drop drop
  "Discard the top two items on the stack"
] 'drop-pair' :

[ "?n-"
  [ drop ] times
  "Discard an arbitrary number of items from the stack"
] 'drop<n>' :
````

In addition to the basic shufflers, there are also some additional forms of
the **bi** and **tri** combinators that are very useful.

So some terminology as we go along. **bi** and **tri** are *cleave
combinators* which apply multiple quotations to a single value (or set of
values).

The second grouping here are *spread combinators* which apply multiple
quotations to multiple values.

````
[ "vvpp-?"
  [ dip ] dip invoke
  "Invoke p1 against v1 and p2 against v2"
] 'bi*' :

[ "vvvppp-?"
  [ [ swap [ dip ] dip ] dip dip ] dip invoke
  "Invoke p1 against v1, p2 against v2, and p3 against v3"
] 'tri*' :
````

And the final type here are *apply combinators* which apply a single quotation
to multiple values.

````
[ "vvp-?"
  dup bi*
  "Invoke p1 against v1 and again against v2"
] 'bi@' :

[ "vvvp-?"
  dup dup tri*
  "Invoke p1 against v1, then v2, then v3"
] 'tri@' :
````

The primary means of naming a word is to use **:**. In some cases it may be
more readable to have the name first, then the definition. We provide **.**
for this.

````
[ "sp-"
  swap :
  "Attach a name to a slice"
] '.' :
````

````
[ "n-n"  [ 1 / ] [ 1 rem ] bi - "Return the smallest integer less than or equal to the starting value" ] 'floor' :
[ "n-n"  dup floor dup-pair eq? [ drop ] [ nip 1 + ] if "Return the smallest integer greater than or equal to the starting value" ] 'ceil' :
[ "n-n"  0.5 + floor "Round a number to the nearest integer value" ] 'round' :
[ "nn-nn" dup-pair rem [ / floor ] dip "Divide and return floored result and remainder" ] '/rem' :
[ "nn-n"  over over lt? [ nip ] [ drop ] if "Return the greater of two values" ] 'max' :
[ "nn-n"  over over gt? [ nip ] [ drop ] if "Return the smaller of two values" ] 'min' :
[ "n-n"   dup -1 * max "Return the absolute value of a number" ] 'abs' :
[ "nn-..."
  dup-pair lt?
    [ [ [ dup 1 + ] dip dup-pair eq? ] until ]
    [ [ [ dup 1 - ] dip dup-pair eq? ] until ] if
  drop
  "Given two values, expand the range"
] 'range' :

````

````
[ "q-...n"   depth [ invoke ] dip depth swap -
  "Execute a quotation, returning a value indicating th stack depth change as a result"
] 'invoke<depth?>' :
````

Some operations on slices. Parable's memory model is based on slices, each of
which can grow independently of the others. The VM provides the fundamental
pieces to control length, make copies, and extract subsets of a slice. But
these can be awkward to use. These next few things provide a higher level set
of functions for dealing with these things.

First up is adjusment of a slice's length. The VM has instructions to access
and set the length (**get&lt;final-offset&gt;** and
**set&lt;final-offset&gt;**), but if you need to make a relative adjustment
(growing or shrinking by a specific amount), this adds **adjust-slice-length**.

````
[ "np-"   [ get<final-offset> + ] sip set<final-offset>
  "Given a number, adjust the length of the specified slice by the requested amount."
] 'adjust-slice-length' :
````

The VM provides **copy** which copies the contents of a slice to another
slice. To quickly make a copy of a slice into a new slice, we add the
following.

````
[ "p-p"
  request [ copy ] sip
  "Make a copy of a slice, returning a pointer to the copy"
] 'duplicate-slice' :
````

Next up is getting the length of a slice. The VM provides an instruction to
find the final offset, but this needs to be increased by 1 for the length
since addressing is zero based.

````
[ "p-n"   get<final-offset> 1 +  "Return the length of a slice" ] 'length?' :
````

And finally, two functions which extend **subslice**. The VM provides the
ability to extract a portion of the contents of a slice into a new slice. Here
this is extended with two additional functions that allow access to the
specified number of cells from either the left or right side of the slice.

    |E|  "Extract the 'Hello'"
    |E|  'Hello, World' 5 subslice<left>
    |E|
    |E|  "Extract the 'World'"
    |E|  'Hello, World' 5 subslice<right>

````
[ "pn-p"
  [ dup length? dup ] dip - swap subslice
  "Return a new slice containing the contents of the original slice, including the specified number of values. This copies the rightmost (trailing) elements."
] 'subslice<right>' :

[ "pn-p"
  0 swap subslice
  "Return a new slice containing the contents of the original slice, including the specified number of values. This copies the leftmost (leading) elements."
] 'subslice<left>' :
````

Code and data are functionally equivilent to Parable. With the extensive use
of quotations it's useful to be able construct new functions programatically.
The following functions help with this.

**cons** combines two values into a new quote. Some examples of equivilents:

    |E|  100 200 cons
    |E|  [ 100 200 ]
    |E|
    |E|  'Hello, World!' &to-uppercase :x cons
    |E|  [ 'Hello, World!' |to-uppercase ]

It's generally cleaner to require a quotation directly, but this provides an
alternative if this isn't feasible in a specific application.

````
[ "vv-p"
  swap request [ 0 store ] sip [ 1 store ] sip
  "Bind two values into a new slice"
] 'cons' :
````

The second example for **curry** showed combining a data element and a
function call. Parable provides **curry** as a more readable way to do this.
These are all equivilent:

    |E|  'Hello, World!' &to-uppercase :x cons
    |E|  'Hello, World!' &to-uppercase curry
    |E|  [ 'Hello, World!' |to-uppercase ]

````
[ "vp-p"
  :x cons
  "Bind a value and a quote, returning a new quote which executes the specified one against the provided value"
] 'curry' :
````

Parable also provides **enquote** to convert a pointer into a function call
and wrap the call inside a new quotation.

````
[ "p-p"
  :x request [ 0 store ] sip
  "Wrap a pointer into a new quote, converting the pointer into a FUNCALL"
] 'enquote' :
````

A variable is represented as a function with a stack comment and a single
return value. As an example (columns mark the offsets), a variable storing the
value #100 would look like this in memory:

| 0    | 1    |
| ---- | ---- |
| "-v" | #100 |

You can directly execute variables in many cases, but it's preferred to use
the **@** and **!** prefixes for obtaining and setting the value.

The fundamental building block of variable definition is **var!** which takes
a value and a name. It creates a function with a stack comment of "-v" and
the provided value, then binds it to the specified name.

````
[ "vs-"
  [ '-v' :r swap cons ] dip :
  "Create a variable with an initial value"
] 'var!' :
````

A corresponding function is **var** which creates a variable with an undefined
initial value.

````
[ "s-"   0 :u swap var! "Create a variable" ] 'var' :
````

````
[ "p-"   0 :f swap 1 store "Set a variable to a value of false" ] 'off' :
[ "p-"  -1 :f swap 1 store "Set a variable to a value of true" ] 'on' :

[ "np-"  swap over 1 fetch + swap 1 store
  "Increment a variable by the specified amount"
] 'increment<by>' :

[ "p-"   1 swap increment<by>
  "Increment a variables value by 1"
] 'increment' :

[ "np-"  swap over 1 fetch swap - swap 1 store
  "Decrement a variable by the specified amount"
] 'decrement<by>' :

[ "p-"   1 swap decrement<by>
  "Increment a variables value by 1"
] 'decrement' :

[ "p-"   request swap copy "Erase all values in a slice" ] 'zero-out' :

[ "pp-"  swap request dup-pair copy swap [ [ invoke ] dip ] dip copy
  "Backup the contents of a slice and remove the pointer from the stack. Execute the quotation. Then restore the contents of the specified slice to their original state."
] 'preserve' :


"Expand the basic conditionals into a more useful set."
[ "s-"   report-error abort "Push a string to the error log and abort execution" ] 'abort<with-error>' :
[ "-f"   -1 :f "Return a true flag" ] 'true' :
[ "-f"   0  :f "Return a false flag" ] 'false' :
[ "f-f"  :f :n -1 xor :f "Invert a flag" ] 'not' :
[ "fp-"  [ ] if "Invoke quote if flag is true" ] 'if-true' :
[ "fp-"  [ ] swap if "Invoke quote if flag is false" ] 'if-false' :
[ "v-f"  :s 'nan' eq? "Return true if number is #nan or false otherwise" ] 'nan?' :
[ "v-f"  0 eq? "Return true if number is #0 or false otherwise" ] 'zero?' :
[ "v-f"  :f :n zero? not "Return true if flag is true or false otherwise" ] 'true?' :
[ "v-f"  :f :n zero? "Return true if flag is false or false otherwise" ] 'false?' :
[ "n-f"  2 rem zero? "Return true if number is even or false otherwise" ] 'even?' :
[ "n-f"  2 rem zero? not "Return true if number is odd or false otherwise" ] 'odd?' :
[ "n-f"  0 lt? "Return true if number is less than zero or false otherwise" ] 'negative?' :
[ "n-f"  0 gteq? "Return true if number is greater than or equal to zero or false otherwise" ] 'positive?' :
[ "nnn-f"  [ [ :n ] bi@ ] dip :n dup-pair gt? [ swap ] if-true [ over ] dip lteq? [ gteq? ] dip and :f
  "Return true if the number (n1) is betwen n2 and n3, inclusive or false otherwise"
] 'between?' :
[ "vv-vvf"  [ type? ] dip type? swap [ eq? ] dip swap
  "Return true if the type of both values is the same, or false otherwise"
] 'types-match?' :



"Misc"
[ "p-"   invoke<depth?> [ hide-word ] times "Given an array of names, hide each named item" ] 'hide-words' :
[ "ps-"  dup hide-word : "Remove the old name for a word and assign it to a new one" ] 'redefine' :
[ "p-"   invoke<depth?> [ var ] times "Given a list of names, create a variable for each one" ] '::' :


"String and Character"
"Note that this is only supporting the basic ASCII character set presently."
[ "vs-f" swap :s find not true? "Return true if the value is found in the specified string, or false otherwise" ] 'string-contains?' :
[ "v-f"  :c $0 $9 between? "Return true if value is a decimal digit, or false otherwise" ] 'digit?' :
[ "v-f"  '`~!@#$%^&*()<>,.:;[]{}\|-_=+"'' string-contains? "Return true if value is an ASCII symbol, or false otherwise" ] 'symbol?' :
[ "v-f"  to-lowercase 'abcdefghijklmnopqrstuvwxyz'           string-contains? "Return true if value is an ASCII letter, or false otherwise" ] 'letter?' :
[ "v-f"  to-lowercase 'abcdefghijklmnopqrstuvwxyz1234567890' string-contains? "Return true if value is a ASCII letter or digit, or false otherwise" ] 'alphanumeric?' :
[ "v-f"  to-lowercase 'bcdfghjklmnpqrstvwxyz'                string-contains? "Return true if value is a consonant, or false otherwise" ] 'consonant?' :
[ "v-f"  to-lowercase 'aeiou'                                string-contains? "Return true if value is a vowel, or false otherwise" ] 'vowel?' :
[ "v-f"  dup to-lowercase eq? "Return true if value is a lowercase string or ASCII character, or false otherwise" ] 'lowercase?' :
[ "v-f"  dup to-uppercase eq? "Return true if value is an uppercase string or ASCII character, or false otherwise" ] 'uppercase?' :
[ "p-s"  invoke<depth?> 1 - [ [ :s ] bi@ + ] times "Execute a quotation, constructing a string from the values it returns." ] 'build-string' :
````

We now begin delving into deeper operations on slices. A slice is represented
as a linear array of values. Consider the following sequence:

    1 2 + 3 *

In memory this looks like (the header denotes the offset of each value):

|  0  |  1  |  2  |  3  |  4  |
| --- | --- | --- | --- | --- |
| #1  | #2  | \|+ | #3  | \|* |

We call the first cell (offset 0) the *head* and the remaining cells the
*body*. The last cell in the *body* is the *tail*.

````
[ "q-v"  0 fetch "Return the first item in a slice" ] 'head' :
[ "q-q"  1 over length? subslice "Return the second through last items in a slice" ] 'body' :
[ "p-v"  dup length? 1 - fetch "Return the last item in a slice" ] 'tail' :
````

As described earlier, **cons** can be used to merge two values into a quote.
Using **head** and **tail** we can implement **decons** which unpacks the
values.

````
[ "p-vv"  [ head ] [ tail ] bi
  "Return the head and tail of a slice"
] 'decons' :
````

Slices can be viewed as lists or arrays of values. The standard library
provides functions to deal with these in a clean, high level manner.

First up: some variables, and a function to allow for saving/restoring them
(which helps make things reentrable when chaining things together):

````
[ 'Found'  'Value'  'XT'  'Source'  'Target'  'Offset' ] ::
[ "q-"
  @Found [ @Value [ @XT [ @Source [ @Target [ @Offset [ invoke ] dip !Offset ] dip !Target ] dip !Source ] dip !XT ] dip !Value ] dip !Found
] 'localize' :
````

**push** and **pop** append and remove values from a slice.

````
[ "vp-"
  :p dup length? store
  "Append a value to the specified slice. This modifies the original slice."
] 'push' :

[ "p-v"
  :p [ dup get<final-offset> fetch ] sip dup length? 2 - swap set<final-offset>
  "Remove the last value from the specified slice. This modifies the original slice."
] 'pop' :
````

**cycle** moves the head of a slice to the tail. It makes a new copy of the
slice; it does not alter the original.

````
[ "p-p"
  [ head ] [ body ] bi [ push ] sip
  "Move the head of the slice to the tail"
] 'cycle' :
````

A standard slice has a single initial cell. It's often necessary to have a
completely empty slice though, so we define **request-empty** to handle this
case.

````
[ "-p"
  request [ pop drop ] sip
  "Request a slice with no stored values"
] 'request-empty' :
````

````
[ "pnp-n"
  [ !XT
    [ duplicate-slice ] dip over length? [ over pop @XT invoke ] times nip
  ] localize
  "Takes a slice, a starting value, and a quote. It executes the quote once for each item in the slice, passing the item and the value to the quote. The quote should consume both and return a new value."
] 'reduce' :
````

````
[ "pp-?"
  [ !XT
    duplicate-slice !Source 0 !Offset
    @Source length? [ @Source @Offset fetch @XT invoke &Offset increment ] times
  ] localize
  "Takes a slice and a quotation. It then executes the quote once for each item in the slice, passing the individual items to the quote."
] 'for-each' :
````

````
[ "pv-f"
  false !Found !Value dup length? 0 swap [ dup-pair fetch @Value types-match? [ eq? @Found or :f !Found ] [ drop-pair ] if 1 + ] times drop-pair @Found
  "Given a slice and a value, return true if the value is found in the slice, or false otherwise."
 ] 'contains?' :
````

````
[ "pq-p"
  [ !XT !Source
    request-empty !Target 0 !Offset
    @Source length? [ @Source @Offset fetch @XT invoke
                      [ @Source @Offset fetch @Target push ] if-true
                      &Offset increment
                    ] times
    @Target
  ] localize
  "Given a slice and a quotation, this will pass each value to the quotation (executing it once per item in the slice). The quotation should return a Boolean flag. If the flag is true, copy the value to a new slice. Otherwise discard it."
] 'filter' :
````

**map** takes a list and a quotation and applies the quote to each item in the
list. The resulting value (the quote should consume and return a single value)
will be stored in a new list which is returned at the end.

    |E|  [ 1 2 3 4 5 ]  [ 10 * ] map

````
[ "pq-"
  [ !XT
    duplicate-slice !Source 0 !Offset
    @Source length? [ @Source @Offset fetch @XT invoke
                      @Source @Offset store &Offset increment
                    ] times
    @Source
  ] localize
  "Given a pointer to an array and a quotation, execute the quotation once for each item in the array. Construct a new array from the value returned by the quotation and return a pointer to it."
] 'map' :
````

A function can return multiple values. Parable provides two combinators for
capturing the results into a list: **capture-results&lt;in-stack-order&gt;**
and **capture-results**.

The difference is pretty simple:

    |E|  [ 1 2 3 ] capture-results
    |E|  "Resulting list: [ 1 2 3 ]"
    |E|
    |E|  [ 1 2 3 ] capture-results<in-stack-order>
    |E|  "Resulting list: [ 3 2 1 ]

````
[ "p-p"
  [ request !Target
    invoke<depth?> 0 max [ @Target push ] times
    @Target 1 over length? subslice :p
  ] localize
  "Invoke a quote and capture the results into a new array"
] 'capture-results<in-stack-order>' :

[ "p-p"
  capture-results<in-stack-order> reverse
  "Invoke a quote and capture the results into a new array"
] 'capture-results' :
````

Cleanup the above: hide the variables used and that **localize** function.

````
[ 'Found'  'Value'  'XT'  'Source'  'Target'  'Offset'  'localize' ] hide-words
````

This next function takes a list and a value and returns a new list with the
offsets from the first list that contain the specified value. E.g., to find
all $A's in a string:

    |E|  'THIS IS A TEST OF A SHORT PHRASE' $A indexes

If no values are found, this returns #nan instead of a pointer.

This function uses four variables:

| Variable Name | Contains    |
| ------------- | ----------- |
| V             | Value       |
| S             | Source List |
| O             | Offset      |
| L             | Result List |

````
[ 'V' 'S' 'O' 'L' ] ::

[ "pv-p|n"
  !V !S 0 !O
  request-empty !L
  @S @V contains?
  [ @S length?
    [ @S @O fetch @V types-match?
      [ eq? [ @O @L push ] if-true ]
      [ drop-pair ] if
      &O increment
    ] times @L
  ]
  [ #nan ] if
  "Given a slice and a value, return the offsets the value is located at, or #nan if none are found"
] 'indexes' :

[ 'V' 'S' 'O' 'L' ] hide-words
````

**index-of** is provided for quickly accessing the offset of the first
occurance of a value in a slice.

````
[ "pv-n"
  indexes dup nan? [ head ] if-false
  "Given a slice and a value, return the offset the value is located at, or #nan if not found"
] 'index-of' :
````

````
"Functions for trimming leading and trailing whitespace off of a string. The left side trim is iterative; the right side trim is recursive."
[ "s-s" :s #0 [ dup-pair fetch :n 32 eq? [ 1 + ] dip ] while 1 - [ dup get<final-offset> 1 + ] dip swap subslice :s "Remove leading whitespace from a string" ] 'trim-left' :
[ "s-s" reverse trim-left reverse :s "Remove trailing whitespace from a string" ] 'trim-right' :
[ "s-s" trim-right trim-left "Remove leading and trailing whitespace from a string" ] 'trim' :
````

## Dictionary and Scope

Up to this point the code has used **hide-word** to remove headers we don't
want to leave visible. But we now have a language that is complete enough to
build on. This section expands the dictionary functions to provide for better
control of name visibility via lexical scope and vocabularies.

This begins with a trio of words: **word-exists?** for checking to see if a
name is in the dictionary, **lookup-word** to find a pointer corresponding to
a name, and **rename-word** for renaming words.

````
[ "s-f"
  vm.dict<names> swap contains?
  "Return true if the named word exists or false otherwise"
] 'word-exists?' :

[ "s-p"
  dup word-exists?
  [ vm.dict<names> swap index-of vm.dict<slices> swap fetch ]
  [ drop #nan ] if
  "Return a pointer to the named word if it exists, or #nan otherwise"
] 'lookup-word' :

[ "p-s"
  :p vm.dict<slices> over contains?
  [ vm.dict<slices> swap index-of vm.dict<names> swap fetch ]
  [ drop '' ] if
  "If the pointer corresponds to a named item, return the name. Otherwise return an empty string."
] 'lookup-name' :

[ "ss-"
  swap dup word-exists? [ dup lookup-word swap hide-word swap : ] [ drop ] if
  "Change a name from s1 to s2"
] 'rename-word' :
````

You can access the names in the dictionary using **vm.dict&lt;names&gt;**. If
you need a subset of them you can use **vm.dict&lt;names-like&gt;** which
takes a string and returns a list of names that contain the string.

    |E|  "Find probable vocabularies"
    |E|  '~' vm.dict<names-like>

````
'Pattern' var

[ "s-f" @Pattern swap string-contains? ] 'matches' :

[ "s-p"
  !Pattern vm.dict<names> &matches filter
  "Return an array of names in the dictionary that match a given substring."
] 'vm.dict<names-like>' :

[ 'Pattern' 'matches' ] hide-words
````

Parable has a single, global dictionary. But it's often useful to factor out
and hide some definitions. This can be done manually (using **hide-word**),
but providing a lexical scoping system makes things much more readable.

The approach used here is to take a list of names to keep and provides some
minimal syntax: the scoped area is enclosed in curly brackets ({ and }). The
list of names to keep can be put on the stack at any point prior to the }.

````
"Scope"
[ 'Public'  'Private' ] ::
[ "-" vm.dict<names> !Private "Begin a lexically scoped area" ] '{' :
[ "p-"
  [ string? nip ] filter !Public
  "Extract names in scope"
  vm.dict<names> @Private length? over length? subslice !Private

  "Filter out the functions to keep"
  @Private [ @Public swap contains? not ] filter

  "Hide the remaining names"
  [ hide-word ] for-each
  "End a lexically scoped region, removing any headers not specified in the provided array."
] '}' :
[ 'Public'  'Private' ] hide-words
````

Lexical scope is nice, but sometimes there's a need for even more control. The
addition of *vocabularies* allows for grouping related functions and exposing
them selectively.

Parable provides a couple of ways to create a vocabulary:

The first is a variant on the lexical scoping functionality. By adding a
string with the vocabulary name after the list of exposed names and ending
with a **}}**, Parable will create a vocabulary with the exposed names amd
hide the rest.

    |E|  [ 'a' 'b' 'c' ]  'Letters~' {
    |E|    [ $A ] 'a' :
    |E|    [ $B ] 'b' :
    |E|    [ $C ] 'c' :
    |E|  }}

The second form uses **vocab**. This takes a list of names and a string for
the vocabulary name to create. It moves the headers for the specified names
to the vocabulary.

    |E|  [ 'a' 'b' 'c' ] 'Letters~' vocab

The third and final form is using **vocab{** and **}vocab** to construct a
lexical area whose definitions will be placed into a vocabulary:

    |E|  'Letters~' vocab{
    |E|    [ $A ] 'a' :
    |E|    [ $B ] 'b' :
    |E|    [ $C ] 'c' :
    |E|  }vocab

````
[ 'with' 'without' 'vocab' '}vocab' '}}' 'vocab.add-word' ] {
  [ 'Vocabulary' ] ::

  [ "p-"  [ invoke redefine ] for-each "Add words in a vocabulary to the dictionary" ] 'with' :
  [ "p-"  [ tail hide-word ] for-each "Remove words in a vocabulary from the dictionary" ] 'without' :

  [ "ps-"
    request-empty !Vocabulary
    @Vocabulary swap :
    [ dup word-exists? [ dup lookup-word swap cons @Vocabulary push ] [ drop ] if ] for-each
    @Vocabulary without
    "Create a new vocabulary"
  ] 'vocab' :

  [ "ps-"
    over } vocab
    "Close a lexical scope and create a vocabulary with the exposed words"
  ] '}}' :

  [ "sp-"
    over word-exists? [ [ dup lookup-word over hide-word swap cons ] dip push ] [ drop-pair ] if
    "Add a word to an existing vocabulary"
  ] 'vocab.add-word' :
}

[ 'vocab{'  '}vocab' ] {
  [ 'o' ] ::

  [ "-"  vm.dict<names> length? !o "Start a vocabulary block" ] 'vocab{' :
  [ "s-" vm.dict<names> @o over length? subslice swap vocab "End a vocabulary block" ] '}vocab' :
}
````

````
[ 'invoke<preserving>' ] {
  [ 'Prior'  'List' ] ::
  [ "qq-"
    @Prior [
      @List [
        swap duplicate-slice !List
        [ @List [ head ] for-each ] capture-results reverse !Prior
        invoke
        @Prior length? [ @Prior pop @List pop 1 store ] times
      ] dip !List
    ] dip !Prior
    "Executes the code quotation, preserving and restoring the contents of the variables specified."
  ] 'invoke<preserving>' :
}
````

````
[ 'zip' ] {
  [ 'A'  'B'  'X'  'C' ] ::

  [ "ppp-p"
    [ A B X C ]
    [ !X !B !A request-empty !C
      @A length? [ @A head @B head @X invoke @C push @A body !A @B body !B ] times
      @C duplicate-slice
    ] invoke<preserving>
    "For each item in source1, push the item and the corresponding item from source2 to the stack. Execute the specified code. Push results into a new array, repeating until all items are exhausted. Returns the new array. This expects the code to return a single value as a result. It also assumes that both sources are the same size (or at least that the second does not contain less than the first"
  ] 'zip' :
}
````

When is a combinator for handling multiple conditions. An example:

    |E|  [
    |E|    [ [ dup even? ] [ 'number is even!' ] ]
    |E|    [ [ dup odd?  ] [ 'number is odd!'  ] ]
    |E|    [ [ true      ] [ 'hmm, this is a strange number!' ] ]
    |E|  ] when

So the basic skeleton is:

    |E|  [
    |E|    [ [ test ]  [ action if true ] ]
    |E|  ] when

At a minimum there should be a test returning *true*; this is the default
case which will be executed if all others fail. Before this there can be
any number of tests/action pairs. Execution will end after the first
successful test case.

````
[ 'when' ] {
  [ 'Offset'  'Tests'  'Done' ] ::

  [ "q-"
    [ Offset Tests Done ]
    [ !Tests false !Done 0 !Offset
      [ @Tests @Offset fetch head invoke
        [ true !Done @Tests @Offset fetch 1 fetch invoke ] if-true
        &Offset increment @Done
      ] until
    ] invoke<preserving>
    "Takes a pointer to a set of quotations. Each quote in the set should consist of two other quotes: one that returns a flag, and one to be executed if the condition returns true. Executes each until one returns true, then exits."
  ] 'when' :
}
````


````
[ 'split'  'join' ] {
  [ 'Source'  'Value'  'Target' ] ::
  [ "n-"  [ @Source 0 ] dip subslice :s ] 'extract' :
  [ "n-"  @Source swap @Value length? + over length? subslice :s !Source ] 'next-piece' :

  [ "ss-p"
    dup length? 0 eq?
    [ drop [ :s ] map ]
    [ :s !Value
      !Source
      request-empty !Target
      [ @Source @Value find dup
        -1 -eq? [ [ extract @Target push ] sip next-piece true ]
                [ drop @Source @Target push false ] if
      ] while
      @Target
    ] if
    "Given a string and a delimiter, split the string into an array"
  ] 'split' :

  [ "pv-s"
    :s !Value
    reverse '' [ :s + @Value + ] reduce
    "This leaves the join value appended to the string. Remove it."
    0 over length? @Value length? - subslice :s
    "Given an array of values and a string, convert each value to a string and merge, using the provided string between them"
  ] 'join' :
}
````

Sometimes stings will contain non-printable characters outside of the ASCII
range. Parable provides **clean-string** to filter these out.

````
[ "s-s"
  [ :n [ 32 128 between? ] [ 9 13 between? ] bi or ] filter :s
  "Remove any non-printable characters from a string"
] 'clean-string' :
````

To replace all instances of a substring with another string, Parable provides
**replace**. This is used like:

    |E|  'Hello World. How is the weather?'
    |E|  'e'
    |E|  '7'
    |E|  replace
    |E|  "Resulting string is:"
    |E|  "H7llo World. How is th7 w7ath7r?'

````
[ "sss-s"
  [ split ] dip join clean-string
  "Replace all instances of s2 in s1 with s3"
] 'replace' :
````

It's possible to construct a string by converting the pieces to strings and
using **+** to concatenate them or using **build-string**, but these can be
messy and difficult to follow. Consider a simple case:

    |E|  "We want the following string:"
    |E|  '1.0 + 2.0 = 3.0'
    |E|
    |E|  1 :s ' + ' + 2 :s + ' = ' + 3 :s +
    |E|  [ 1 ' + ' 2 ' = ' 3 ] build-string

The first is just too clumsy for anything that needs to be maintained later.
The second works and is easier to deal with, but still suffers a little, plus
it requires that all values be provided within the quote, so if we wanted to
replace the values with variables, we'd need to do something ugly like:

    |A|  1 !A  2 !B  3 !C
    |E|  [ @A ' + ' @B ' = ' @C ] build-string

To resolve this, Parable provides **interpolate** which allows values to be
merged into a string template, resulting in a new string. Our example can thus
be rewritten into something like:

    |E|  [ 1 2 3 ] '{v} + {v} = {v}' interpolate

Interpolation will place the values in the source list into the provided
string at the location of each *{v}*. The values are inserted in order from
first to last.

````
[ 'interpolate' ] {
  [ 'Data'  'Source'  'String' ] ::

  [ "-"  @String @Source head @Data head pointer? [ invoke ] if-true :s + + !String ] '(accumulate)' :
  [ "-"  @Source body !Source  @Data body !Data ] '(next)' :

  [ "ps-s"
    [ Data Source String ]
    [ '{v}' split !Source
      !Data
      request-empty :s !String
      @Data length? [ (accumulate) (next) ] times
      "Merge any remaining items"
      @String @Source '' join + clean-string
    ] invoke<preserving>
    "Given an array of values and a string with insertion points, construct a new string, copying the values into the insertion points."
  ] 'interpolate' :
}
````

Sometimes you will need to construct a string with a repeating set of values.
Parable provides **interpolate&lt;cycling&gt;** for this. An example:

    |E|  [ 'bottles' ] '99 {v} of beer on the wall, 99 {v} of beer'
    |E|  interpolate<cycling>

````
[ 'interpolate<cycling>' ] {
  [ 'D'  'S'  'L' ] ::

  [ "qs-s"
    [ S D L ]
    [ !S  !D
      @S '{v}' split length? !L
      [ @D length? @L lt? dup [ @D duplicate-slice @D + !D ] if-true ] while
      [ @D length? @L lt? dup [ @D pop drop ] if-false ] until
      @D @S interpolate
    ] invoke<preserving>
    "Given an array of values and a string with insertion points, construct a new string, copying the values into the insertion points. If the array of values is less than the number of insertion points, cycle through them again."
  ] 'interpolate<cycling>' :
}
````

It's sometimes useful to have direct access to values on the stack. Parable
provides a building block for this in **stack-values**. Invoking this will
return an array with all values currently on the stack.

You could temporarily save and restore the stack using this, **dip**,
**reset**, and **for-each**:

    |E|  stack-values [ reset ... ] dip &nop for-each

Note here the use of *&nop for-each* to push the values back to the stack. If
you know that there are no FUNCALL or REMARK items it's ok to just **invoke**
the stack data, but this won't work as expected if FUNCALL or REMARK items are
present.

**NOTE TO SELF: look into adding a invoke&lt;preserving-stack&gt; combinator**

Parable also provides a **rso** (*reverse stack order*) word to invert the
order of items on the stack.

````
[ 'stack-values' 'rso' ] {
  'S' var

  [ "-p"
    request-empty !S
    depth [ @S push ] times
    @S reverse dup !S &nop for-each
    @S
    "Return an array with the items currently on the stack"
  ] 'stack-values' :

  [ "...-..."
    stack-values reverse [ reset ] dip &nop for-each
    "Reverse the order of all items on the stack"
  ] 'rso' :
}
````


````
[ "-n"   2.71828182846 "Mathmatical constant for Euler's Number" ] 'E' :
[ "-n"   3.14159265359 "Mathmatical constant for PI" ] 'PI' :
[ "n-n"  E log<n> "Return the base E logarithm of a number" ] 'log' :
[ "n-n"  10 log<n> "Return the base 10 logarithm of a number" ] 'log10' :
````

````
[ "p-p"
  [ remark? not nip ] filter
  "Return a copy of the slice with embedded comments removed"
] 'strip-remarks' :
````

````
[ 'times<with-index>' ] {
  '_' var
  [ "qq-"
    [ &_ ]
    [ [ !_ [ @_ invoke range ] capture-results reverse ] dip for-each ] invoke<preserving>
    "Construct a range from the values in q1, then execute q2 as a for-each against them"
  ] 'times<with-index>' :
}
````

Parable has some support for arrays of key:value pairs. These are structured
like:

    |E|  [ [ 'a' 100 ]
    |E|    [ 'b' 200 ]
    |E|    [ 'c' 300 ] ]

Access to specific elements is done using **byKey:** which takes a pointer
and key name and returns a pointer and offset to the specific value in the
list. E.g. if the above list was named *Data*, doing this would return the
value #200:

    |E|  &Data 'b' byKey: fetch

There is a lot of overhead in the key:value lookups; other data structures
are a better choice for larger data sets.

````
[ 'byKey:' ] {
  [ 'S' 'O' 'K' 'M' ] ::

  [ "-f"  @S length? @O eq? ] 'done?' :
  [ "-f"  @S @O fetch 0 fetch @K eq? ] 'match?' :

  [ "ps-pn"
    !K !S 0 !O #nan !M
    [ match? [ @O !M ] if-true &O increment done? ] until
    @M nan? [ #nan :p #nan ] [ @S @M fetch 1 ] if
    "Return an offset for a key in a slice of key:value pairs"
  ] 'byKey:' :
}
````

**?** is a simple tool that tries to help you recall how to use a word. Given
a name it returns the stack comment and docstring (if they exist).

````
"?"
[ '?' ] {
  [ "p-?" &head &tail bi [ remark? [ drop ] if-false ] bi@ ] 'desc' :

  [ "s-s | s-ss"
    dup word-exists?
    [ lookup-word desc ]
    [ 'word "' swap + '" not found' + report-error ] if
    "Lookup the stack comment and description (if existing) for a named item"
  ] '?' :
}
````

----

Being able to hash a string has many uses. Parable provides a top level
**hash** function for this, with some capacity for quickly changing the
underlying algorithm.

This provides:

* XOR hash
* DJB2 hash
* SDBM hash

````
"Hashing functions"
389 'Hash-Prime' var!
[ "s-n" 0 swap [ :n xor ] for-each "Hash a string using the XOR algorithim" ] 'hash:xor' :
[ "s-n" 5381 swap [ :n over -5 shift + + ] for-each "Hash a string using the DJB2 algorithim" ] 'hash:djb2' :
[ :n over -6 shift + over -16 shift + swap - ] 'hash:sdbm<n>' :
[ "s-n" 0 swap [ :c swap hash:sdbm<n> ] for-each "Hash a string using the SDBM algorithim" ] 'hash:sdbm' :
[ "s-b" hash:djb2 "The preferred hash algorithim (defaults to DJB2)" ] 'chosen-hash' :
[ "s-n" chosen-hash @Hash-Prime rem "Hash a string using chosen-hash and Hash-Prime" ] 'hash' :
'hash:sdbm<n>' hide-word
````


----

## Future Additions

**WIP**: invoke&;lt;preserving-stack&gt;

````
[ "...p-..."
  [ stack-values [ reset ] dip ] dip swap [ invoke ] dip &nop for-each
  "Invoke a quote, making a copy of the stack contents which will be removed
   prior to invocation and restored after the quote returns."
] 'invoke<preserving-stack>' :
````
