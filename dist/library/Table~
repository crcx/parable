"Tables~"
"-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
"This is a vocabulary that provides some functions for working on simple tables"
" of data."

"A table is setup like:"

"[ [  1  2  3  4  5 ] \ "
"  [ $a $b $c $d $e ] \ "
"  [ $f $g $h $i $j ] \ "
"  [ $k $l $m $n $o ] \ "
"] 'T' :                "

"Given a string containing tab separated or comma separated values, this can"
"construct a table from the string."

"Some limits:"

"* Each row needs to have the same number of columns"
"* This gets very slow with large tables"
"* The vocabulary is currently incomplete"

"Todo:"

"* Allow gathering values in a range: row, column, or subset"
"* Consider spreadsheet style (<letter><number>) addressing of cells"

"-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"

[ "s-p" \
  [ '\n' split [ ',' split ] for-each ] curry capture-results \
  "Given a comma separated value string ("CSV"), return a table." \
] 'table.from<csv>' :

[ "s-p" \
  [ '\n' split [ '\t' split ] for-each ] curry capture-results \
  "Given a tab separated value string ("TSV"), return a table." \
] 'table.from<tsv>' :

[ "pnn-"  [ fetch ] dip fetch "Fetch from a table." ] 'table.fetch<row,col>' :
[ "vpnn-" [ fetch ] dip store "Store into a table." ] 'table.store<row,col>' :

[ 'table.fetch<row,col>' 'table.store<row,col>' 'table.from<tsv>' \
  'table.from<csv>' ] 'Table~' vocab
