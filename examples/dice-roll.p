"Dice Rolls for Dungons & Dragons (and other games)"
"Simulates rolls of 4, 6, 8, 10, 12, and 20 sided dice"
"Has capacity to roll multiple dice and sum the results (including modifiers) quickly"

[ "n-n"  [ random #100 * ] dip rem floor #1 + ] 'roll-die' define

[ [ [ 4 roll-die ] times ] sip #1 - [ + ] times ] 'd4' define
[ [ [ 6 roll-die ] times ] sip #1 - [ + ] times ] 'd6' define
[ [ [ 8 roll-die ] times ] sip #1 - [ + ] times ] 'd8' define
[ [ [ 10 roll-die ] times ] sip #1 - [ + ] times ] 'd10' define
[ [ [ 12 roll-die ] times ] sip #1 - [ + ] times ] 'd12' define
[ [ [ 20 roll-die ] times ] sip #1 - [ + ] times ] 'd20' define

[ "q-n"  capture-results #0 [ + ] reduce ] 'roll-dice' define

[ #2 d6 #5 ] roll-dice
