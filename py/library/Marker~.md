## Marker~

### Overview

Marker~ provides a vocabulary for creation and use of Forth-style *markers*.

A *marker* is a function which returns the dictionary to a known state. In Parable these will do the following:

* Remove all names from the dictionary
* Restore all names that existed prior to the creation of the marker
* Point the names to the original slices at the time the marker was created

A marker does not:

* Restore the original definitions

This has an important limitation: if you redefine a word using **:** or **.**, the newest implemenat will be used: there is no way to get back the original definition.

### Implementation

Parable provides two functions for accessing the entire dictionary: **vm.dict&lt;names&gt;** and **vm.dict&lt;slices&gt;**. What we'll do here is create a list pointing to the data these return, then a function which replaces the current dictionary with the stored one.

````
[ 'marker' 'anew' ] 'Marker~' {
  [ 'Dict' ] ::

  [ "p-" \
    !Dict \
    vm.dict<names> hide-words \
    [ 0 @Dict head length? 1 - range ] [ dup @Dict head swap fetch [ @Dict tail swap fetch ] dip : ] times<with-index> \
  ] 'restore-marker' :

  [ "s-" \
    vm.dict<names> vm.dict<slices> cons &restore-marker curry . \
    "A marker is a function that resets the dictionary to the state it was \
     in prior to the creation of the marker." \
  ] 'marker' :

  [ "s-" \
    dup word-exists? [ dup lookup-word invoke ] if-true marker \
    "If the specified name exists, remove it and all subsequent names. Then \
     create a new marker with the specified name." \
  ] 'anew' :
}}
````
