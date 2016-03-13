#!/usr/bin/env allegory

sys.args length? 1 -eq?
  [ sys.args reverse dup pop drop [ slurp-file display tty.cr ] for-each ]
  [ './cat.p filename(s)' display tty.cr ] if
