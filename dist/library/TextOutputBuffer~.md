## TextOutputBuffer~

### Overview

### Code

````
"Text Output Buffer"
[ 'TOB' 'to-tob' 'clear-tob' ] 'TextOutputBuffer~' {
  'TOB' var
  [ "v-"   &TOB push "Append a value to the TOB" ] 'to-tob' :
  [ "-"    0 &TOB set<final-offset> "Remove all items in the TOB" ] 'clear-tob' :
}}
````
