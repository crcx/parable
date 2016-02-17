[ [ alphanumeric? ] filter :s to-lowercase dup reverse :s eq? ] 'palindrome?' :

'4/12/14' palindrome?
'4/20/14' palindrome?
'A man, a plan, a canal: Panama' palindrome?
