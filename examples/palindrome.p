'buf' variable
[ &buf slice-set [ dup alphanumeric? [ slice-store ] [ drop ] if ] for-each-character ] 'filter' define
[ to-lowercase filter &buf :s dup reverse dup-pair = ] 'palindrome?' define

'4/12/14' palindrome?
'4/20/14' palindrome?
'A man, a plan, a canal: Panama' palindrome?
