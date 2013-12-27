"In order to decide who would die in which order, the soldiers stood in"
"a circle and, starting with the top of the circle and continuing clockwise,"
"counted to three. The third man got the ax and the counting resumed at one."
"The process continued until there was no one left. Josephus, who didn't"
"quite agree with the whole 'we should all kill ourselves' idea, figured out"
"the perfect way to avoid death: be the last man standing."

[ #40 ] 'SOLDIERS' define
[ #3 ] 'VICTIM' define

[ ] '(josephus)' define
[ "r i" swap VICTIM + over rem swap #1 + dup SOLDIERS > [ (josephus) ] if-false ] '(josephus)' define
[ #0 #1 (josephus) drop #1 + ] 'josephus' define

[ 'The number of the last man standing out of ' SOLDIERS ', killing each ' VICTIM ' is ' josephus ] build-string
