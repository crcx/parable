# Dice Rolls for Dungons & Dragons (and other games)

This simulates rolls of 4, 6, 8, 10, 12, and 20 sided dice. It has
capacity to roll multiple dice and sum the results (including
modifiers) quickly.

We'll expose a few function:

    [ 'roll-dice' 'd4' 'd6' 'd8' 'd10' 'd12' 'd20' ] {

First up: a routine to roll a single die. Provide it with the number
of sides; it'll return the result. This one isn't left visible at the
end.

      [ "n-n"  [ random #100 * ] dip rem floor #1 + ] 'roll-die' :

Now provide handlers for each n-sided die. Each of these takes a
number representing the number of rolls and returns the sum of the
rolls.

      [ [ [  4 roll-die ] times ] sip 1 - [ + ] times ] 'd4' :
      [ [ [  6 roll-die ] times ] sip 1 - [ + ] times ] 'd6' :
      [ [ [  8 roll-die ] times ] sip 1 - [ + ] times ] 'd8' :
      [ [ [ 10 roll-die ] times ] sip 1 - [ + ] times ] 'd10' :
      [ [ [ 12 roll-die ] times ] sip 1 - [ + ] times ] 'd12' :
      [ [ [ 20 roll-die ] times ] sip 1 - [ + ] times ] 'd20' :

This is *strongly* calling for refactoring.

The final routine is a combinator that sums the results of the rolls.

      [ "q-n"  capture-results #0 [ + ] reduce ] 'roll-dice' :
    }

Example:

Assuming 2d6+5:

    [ 2 d6 5 ] roll-dice
