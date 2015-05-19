"http://rosettacode.org/wiki/Letter_frequency"

[ ] 'character-counts' define
[ [ #255 [ #0 ] repeat ] array-from-quote 'character-counts' define ] 'reset-counts' define
[ reset-counts [ &character-counts swap dup-pair fetch #1 + swap [ swap ] dip store ] for-each ] 'count-frequency' define

[ to-lowercase :p [ :c letter? ] array-filter :s count-frequency ] 'count-letters' define


'apples! 12 are good' count-letters

[ $a $z [ :n ] bi@ expand-range ] array-from-quote 'letters' define

&letters #0 [ dup :c :s [ &character-counts swap fetch :s ] dip ' : ' + swap + . ] array-reduce drop
show-tob

