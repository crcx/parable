## Parable 2016.04

### Virtual Machine

* **reverse** now preserves the pointer type (pointer, stack, remark)
* **+** now supports new forms: cs-s, sc-s, and cc-s
* the stack is now implemented as a single array of tuples (value, type)
* remove BC_ROUND
* remove BC\_FLOW\_RETURN
* added parsed_stack()
* added stack_values()
* added stack_types()

### Standard Library

* add cycle
* add vocab{
* add }vocab
* round now written in parable
* fix lookup-word

### Interfaces

* PaaS: revised API
* Allegory: load on_startup.md from the parable side, not the python

### Documentation

* added *tools/gfm.py* (git flavored markdown to html)
* added *docs/Makefile* to generate HTML from Markdown using *tools/gfm.py*

### Build

* Use a single top-level Makefile.config
* Makefiles are no longer hard coded to update my personal environment

### Tooling

* Added *tools/gen-tags.py* to generate a ctags compatible *tags* file
