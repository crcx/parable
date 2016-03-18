## Parable 2016.03

**Work in Progress - This is subject to change**

### Virtual Machine

* now using a dispatch table for the byte codes
* added type checking to the byte codes
* fetch now allows for negative offsets (fetch with index starting at tail end of slice)
* removed some redundant byte codes

  * BC\_FLOOR
  * BC\_LOG
  * BC\_LOG10
  * BC\_FLOW\_CALL
  * BC\_FUNCTION\_EXISTS
  * BC\_FUNCTION\_LOOKUP
  * BC\_FUNCTION\_NAME

* error report and abort on type or depth errors
* internal cleanups and refactorings
* disabled automatic garbage collection
* removed ceiling on number of slices (goodbye MAX\_SLICES)
* bug fixes

  * garbage collector now actually releases memory on release
  * random was crashing; fixed
  * fixed a bug in division handling

* prefix change:

  * @ and ! now fetch/store from offset 1, not offset 0

### Standard Library

* Bugfixes

  * index-of now returns #nan when no matching item is in the slice
  * index-of no longer crashes on slices with mixed types
  * stack-values now restores comments properly

* Improvements

  * find-function now written in Parable
  * lookup-function now written in Parable
  * lookup-name now written in Parable
  * floor now written in Parable
  * log now written in Parable
  * log10 now written in Parable
  * all functions now have documentation strings embedded
  * variables now have a mandatory stack comment

* Additions

  * ceil
  * enquote
  * strip-remarks
  * with
  * without
  * vocab
  * }}

* Removals

  * last-index?
  * slice-length?
  * all of the functions in the buffer- family
  * TOB, to-tob, show-tob, clear-tob

* Renamed

  * lookup-function renamed to lookup-word
  * function-exists? renamed to word-exists?
  * hide-function renamed to hide-word
  * hide-functions renamed to hide-words
  * rename-function renamed to rename-word
  * get-last-index renamed to get<final-offset>
  * set-last-index renamed to set<final-offset>
  * drop-multiple is now drop<n>

### Library

* Added a "library" directory to hold useful extensions
* Files named to match vocabulary names:
* New vocabularies:

  * ASCII~
  * Buffer~
  * Compiler~
  * Infix~
  * Marker~
  * Stack~
  * Table~
  * TextOutputBuffer~

### Interfaces

* Allegory

  * now uses a precompiled snapshot of stdlib+extensions
  * all functions now have docstrings
  * added vocabularies for grouping functionality
  * added *need* for loading from library/
  * removed *reload-snapshot*
  * changed *save-snapshot* to generate a turnkey script

* Punga

  * now uses a precompiled snapshot
  * new, 2-pane fullscreen interface: editor, results/errors/dictionary
  * results/memory persist across runs (until manually reset or tab closed)

### Documentation

* Function Reference is now extracted from the docstrings

----


## Parable 2016.02

*Released February 24, 2016*

### Renamed

    COMMENT          ->  REMARK
    :comment         ->  :r
    :call            ->  :x
    FUNCTION-CALL    ->  FUNCALL
    *Current-Buffer  ->  CurrentBuffer
    *Buffer-Offset   ->  BufferOffset
    *TOB             ->  TOB
    .                ->  to-tob
    *Hash-Prime      ->  HashPrime
    define           ->  :
    variable         ->  var
    variable!        ->  var!
    variables        ->  ::
    apropos          ->  ?
    first            ->  head
    last             ->  tail
    rest             ->  body

### Removed

* @
* !
* if-character
* if-flag
* if-number
* if-pointer
* if-string
* to
* value
* value!
* value-handler
* values

### New Functions

* .
* abort
* abort<with-error>
* bytecode?
* character?
* flag?
* funcall?
* invoke<preserving>
* lookup-name
* nop
* number?
* pointer?
* round
* redefine
* remark?
* stack-values
* string?
* UNKNOWN
* unknown?
* :u
* vm.dict<slices>
* vm.dict<names>
* vm.dict<names-like>
* vm.memory<allocated>
* vm.memory<map>
* vm.memory<sizes>
* zip

### New Prefixes

* @
* !

### Bug Fixes

* Substantial improvements to garbage collection
* String interpolation no longer injects extra spaces when the source list is smaller than the number of insertion points
* Joining a string now works properly
* Character parsing ($ prefix) now works properly
* Lots of typos in the documentation
* Empty strings now have a length of zero as expected
* Redefining a variable with an initial value now works properly

### Improvements

* Strings can now contain \n for new line
* Strings can now contain \t for tabs
* **{** and **}** now take a list of functions to expose, rather than a list of functions to hide
* Works on Python 2 and Python 3
* Parable is now case sensitive
* Improved reentrancy for functions using variables in the standard library
* Rewrote nip, tuck, over, reset in Parable and removed the old byte codes
* **?** now returns a string with the stack comment as well as the closing comment (if it exists)

### Interfaces

* Removed *ika*, *pre*
* Added *allegory* (self-contained, interactive listener & scripting)
* GNU readline support
* Initial *PaaS* (Parable-as-a-Service) backend & example front end.
* Removed the out-of-date *Apologue* backends.
* CTRL+C for aborting long runs of execution and exiting the interactive interpreters
* Various UI adjustments in the interactive interfaces
