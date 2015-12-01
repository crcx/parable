#!./pre

arg-count #0 <>
  [ #0 arg-count [ dup get-arg slurp-file print show:cr #1 + ] times drop ]
  [ './cat.p filename(s)' print show:cr ] if
