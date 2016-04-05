[ [ 'abc' 1 ] \
  [ 'def' 2 ] \
  [ 'ghi' 3 ] \
  [ 'jkl' 4 ] \
  [ 'mno' 5 ] \
  [ 'pqr' 6 ] \
  [ 'stu' 7 ] \
  [ 'vwx' 8 ] \
  [ 'yz'  9 ] ] 'Data' :

&Data 'jkl' byKey: fetch
10 *
&Data 'jkl' byKey: store

&Data 'jkl' byKey: fetch
