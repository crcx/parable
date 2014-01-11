\ A test of Forth to Parable

: bar ;
: foo ( -- n ) 1 bar + ;
: test ( -- xt )  ['] foo ;
