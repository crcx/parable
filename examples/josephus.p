"In order to decide who would die in which order, the soldiers stood in"
"a circle and, starting with the top of the circle and continuing clockwise,"
"counted to three. The third man got the ax and the counting resumed at one."
"The process continued until there was no one left. Josephus, who didn't"
"quite agree with the whole 'we should all kill ourselves' idea, figured out"
"the perfect way to avoid death: be the last man standing."

[ "-n" 40 ] 'Soldiers' :
[ "-n"  3 ] 'Victim' :

[ ] '(josephus)' :
[ "r i"   swap @Victim + over rem swap #1 + dup @Soldiers gt? [ (josephus) ] if-false ] '(josephus)' :
[ "nn-n"  #0 #1 (josephus) drop #1 + ] 'josephus' :

[ @Soldiers @Victim josephus ] capture-results reverse
'The number of the last man standing out of {v}, killing each {v} is {v}' interpolate
:s
