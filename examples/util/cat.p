#!/usr/bin/env allegory

arg-count #0 -eq?
  [ #0 arg-count [ dup get-arg slurp-file display tty.cr #1 + ] times drop ]
  [ './cat.p filename(s)' display tty.cr ] if
