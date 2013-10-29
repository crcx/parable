'and: should see #-1'
#-1 #-1 and

'and: should see #0'
#-1 #0 and

'and: should see #0'
#0 #-1 and

'-------------------'

'or: should see #-1'
#-1 #-1 or

'or: should see #-1'
#-1 #0 or

'or: should see #0'
#0 #0 or

'-------------------'

'xor: should see #0'
#-1 #-1 xor

'xor: should see #-1'
#-1 #0 xor

'xor: should see #0'
#0 #0 xor

'-------------------'

'shift: you should see #256'
#1024 #2 shift

'shift: you should see #1024'
#256 #-2 shift
