\ A test of Forth to Parable

: bar ;
: foo ( -- n ) 1 bar + ;
: test ( -- xt )  ['] foo ;

variable a
variable b

"hello, world!"
'a
'b

$FF

$FOOD

: test @a 10 + !b ;

