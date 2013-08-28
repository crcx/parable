"This puzzle involves the use of a simple encoding method for short messages. Called *tap code*, it has been used by prisoners to communicate with each other."

"The workings are pretty simple. Tapcodes get setup as a 5x5 array of characters:"

    ".   1 2 3 4 5"
    ". +----------"
    "1 | a b c d e"
    "2 | f g h i j"
    "3 | l m n o p"
    "4 | q r s t u"
    "5 | v w x y z"

"Letters are represented by a series of knocks, with the row, followed by the column. So 'hi' could be represented as:  2,3 2,4"

"We'll setup a string to hold these characters."

    'abcdefghijlmnopqrstuvwxyz' 'TAPCODES' define

"Next, we need to map the tap sequence to the corresponding character."

"First off, we need to subtract one from each tap count since addressing is zero-based, not one-based."

    "[ #1 - ] bi@"

"Then, multiply the row by 5 to calculate the offset into the string:"

    "[ #5 * ] dip"

"Add the row offset and column offset together:"

    "+"

"And finally, stick a pointer to the TAPCODES string under it:"

    "[ &TAPCODES ] dip"

"And we can fetch our character:"

    "fetch :c"

"Wrapping this up into a function gives:"

    [ [ #1 - ] bi@ [ #5 * ] dip + [ &TAPCODES ] dip fetch :c ] 'tap' define

"Ok, so we have our array of letters and a function to translate tapcodes into them. Now we can test against some known values:"

    #2 #3 tap
    #2 #4 tap

"Which should yield a $i and $h. We then clean the stack:"

    reset

"We will build a string to hold the answer."

    new-slice
    #4 #4 tap slice-store
    #2 #3 tap slice-store
    #1 #5 tap slice-store
    #1 #2 tap slice-store
    #2 #4 tap slice-store
    #4 #2 tap slice-store
    #1 #4 tap slice-store
    #3 #2 tap slice-store
    #1 #1 tap slice-store
    #3 #3 tap slice-store
    #0 slice-store

    &*slice-current* @ :p :s

"And now we have the final clue needed to solve the puzzle:"

    'thebirdman'
