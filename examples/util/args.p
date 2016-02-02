#!/usr/bin/env allegory

arg-count display tty.cr
#0 arg-count [ dup get-arg 'argument: ' display over display ' ' display display tty.cr #1 + ] times drop

