"In order to decide who would die in which order, the soldiers stood in"
"a circle and, starting with the top of the circle and continuing clockwise,"
"counted to three. The third man got the ax and the counting resumed at one."
"The process continued until there was no one left. Josephus, who didn't"
"quite agree with the whole 'we should all kill ourselves' idea, figured out"
"the perfect way to avoid death: be the last man standing."

[ 'josephus' ] {
  #40  'SOLDIERS' var!
  #3   'VICTIM' var!

  [ "r i"   swap @VICTIM + over rem swap #1 + dup @SOLDIERS gt? [ (josephus) ] if-false ] '(josephus)' :
  [ "nn-n"  #0 #1 (josephus) drop #1 + ] 'josephus' :
}	

[ @SOLDIERS @VICTIM josephus ] capture-results reverse
'The number of the last man standing out of {v}, killing each {v} is {v}' interpolate
