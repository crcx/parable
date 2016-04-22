## Parable 2016.04

### Virtual Machine

* **reverse** now preserves the pointer type (pointer, stack, remark)
* **+** now supports new forms: cs-s, sc-s, and cc-s
* the stack is now implemented as a single array of tuples (value, type)
* remove BC_ROUND
* remove BC\_FLOW\_RETURN
* BC_MEM_COPY now works with any pointer types
* added parsed_stack()
* added stack_values()
* added stack_types()
* Re-enable automatic garbage collection on OOM
* Allocate a larger array of slices when OOM
* Add | prefix for function calls
* fixed bugs in BC_MEM_FETCH and B_MEM_STORE
* line condenser no longer requires a \ to join lines
* rewrote tokenizer
* refactored stack_change_type()
* fixed BC_LOGN

### Standard Library

* additions

  * byKey:
  * cycle
  * decons
  * subslice&lt;left&gt;
  * subslice&lt;right&gt;
  * vocab{
  * }vocab

* bug fixes

  * lookup-word

* other improvements

  * round now written in parable
  * removed \ from multi-line definitions

### Interfaces

* PaaS: revised API
* Allegory: load on_startup.md from the parable side, not the python
* Punga: more detailed stack display

### Documentation

* added *tools/gfm.py* (git flavored markdown to html)
* added *docs/Makefile* to generate HTML from Markdown using *tools/gfm.py*

### Build

* Use a single top-level Makefile.config
* Makefiles are no longer hard coded to update my personal environment

### Tooling

* Added *tools/ptags.py* to generate a ctags compatible *tags* file
