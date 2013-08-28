'values on stack'
'You should see: $a, $b, $c, #1, #-2, #45.6, true, false, malformed flag, &151, &123456'
$a  $b   $c
#1  #-2  #45.6
true  false  #3 :f
&151  &123456

'Case conversions: these should all be uppercase'
$c to-uppercase
'heLLo' to-uppercase

'Case conversions: these should all be lowercase'
$A to-lowercase
'HEllO' to-lowercase

'Merging strings: You should see: hello world'
'hello '
'world' +

'Basic math operations: these should be all #3's'
#1 #2 +
#4 #1 -
#3 #1 *
#9 #3 /
#13 #10 rem
