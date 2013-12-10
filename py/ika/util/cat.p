#!./pre

arg-count #0 <>
  [ #0 arg-count [ dup get-arg slurp-file . show:cr #1 + ] repeat drop ]
  [ './cat.p filename(s)' . show:cr ] if
