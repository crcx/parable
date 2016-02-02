#!/usr/bin/env allegory

arg-count #0 -eq?
  [ #0 arg-count [ dup get-arg 'a' open-file close-file #1 + ] times drop ]
  [ './touch.p filename(s)' display tty.cr ] if
