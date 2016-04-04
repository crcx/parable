## Stack~

### Overview

### Code

````
"Additional words for shuffling and accessing values on the stack"
[ "...-..."  stack-values [ reset ] dip &head &body bi [ push ] sip &nop for-each "Roll the last item on the stack to the top" ] 'roll' :
[ "...n-..." &roll times "Roll the stack a specific number of times" ] 'roll<n>' :

[ "...n-v"   stack-values swap 1 - fetch "Return a copy of a specific item on the stack" ] 'pick' :

[ 'roll'  'roll<n>'  'pick' ] 'Stack~' vocab

````

