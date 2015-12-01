#!./pre

arg-count #0 <>
  [ #0 arg-count [ dup get-arg 'a' open-file close-file #1 + ] times drop ]
  [ './touch.p filename(s)' print show:cr ] if
