"Dice Rolls for Dungons & Dragons (and other games)"
"Simulates rolls of 4, 6, 8, 10, 12, and 20 sided dice"
"Has capacity to roll multiple dice and sum the results (including modifiers) quickly"

[ "n-n"  [ random #100 * ] dip rem floor #1 + ] 'roll-die' :

[ [ [ 4 roll-die ] times ] sip #1 - [ + ] times ] 'd4' :
[ [ [ 6 roll-die ] times ] sip #1 - [ + ] times ] 'd6' :
[ [ [ 8 roll-die ] times ] sip #1 - [ + ] times ] 'd8' :
[ [ [ 10 roll-die ] times ] sip #1 - [ + ] times ] 'd10' :
[ [ [ 12 roll-die ] times ] sip #1 - [ + ] times ] 'd12' :
[ [ [ 20 roll-die ] times ] sip #1 - [ + ] times ] 'd20' :

[ "q-n"  capture-results #0 [ + ] reduce ] 'roll-dice' :

[ #2 d6 #5 ] roll-dice
