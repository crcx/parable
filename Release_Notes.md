## Parable 2016.02

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
