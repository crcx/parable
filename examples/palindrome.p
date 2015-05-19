'buf' variable
[ &buf set-buffer [ :c dup alphanumeric? [ buffer-store ] [ drop ] if ] for-each ] 'filter' define
[ dup to-lowercase filter &buf :s dup :p array-reverse :s = ] 'palindrome?' define

'4/12/14' palindrome?
'4/20/14' palindrome?
'A man, a plan, a canal: Panama' palindrome?
