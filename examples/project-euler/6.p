"The sum of the squares of the first ten natural numbers is,"

"1^2 + 2^2 + ... + 10^2 = 385"

"The square of the sum of the first ten natural numbers is,"

"(1 + 2 + ... + 10)^2 = 552 = 3025"

"Hence the difference between the sum of the squares of the first ten natural numbers and the square of the sum is 3025 − 385 = 2640."

"Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum."


[ #1 #100 [ [ dup * ] [ #1 + ] bi ] repeat drop ] array-from-quote
#0 [ + ] array-reduce

[ #1 #100 expand-range ] array-from-quote #0 [ + ] array-reduce
dup * swap -
