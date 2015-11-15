"Dice Rolls for Dungons & Dragons (and other games)"
"Simulates rolls of 4, 6, 8, 10, 12, and 20 sided dice"
"Has capacity to roll multiple dice and sum the results (including modifiers) quickly"


[ [ random #100 * ] dip rem floor #1 + ] 'roll-n-sided-die' define

[ #4 roll-n-sided-die ] 'roll<d4>' define
[ #6 roll-n-sided-die ] 'roll<d6>' define
[ #8 roll-n-sided-die ] 'roll<d8>' define
[ #10 roll-n-sided-die ] 'roll<d10>' define
[ #12 roll-n-sided-die ] 'roll<d12>' define
[ #20 roll-n-sided-die ] 'roll<d20>' define

[ [ [ roll<d4> ] repeat ] sip #1 - [ + ] repeat ] 'd4' define
[ [ [ roll<d6> ] repeat ] sip #1 - [ + ] repeat ] 'd6' define
[ [ [ roll<d8> ] repeat ] sip #1 - [ + ] repeat ] 'd8' define
[ [ [ roll<d10> ] repeat ] sip #1 - [ + ] repeat ] 'd10' define
[ [ [ roll<d12> ] repeat ] sip #1 - [ + ] repeat ] 'd12' define
[ [ [ roll<d20> ] repeat ] sip #1 - [ + ] repeat ] 'd20' define

[ capture-results #0 [ + ] reduce ] 'roll-dice' define

[ #2 d6 #5 ] roll-dice
