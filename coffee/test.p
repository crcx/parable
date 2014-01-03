    'abcdefghijlmnopqrstuvwxyz' 'TAPCODES' define
    [ [ #1 - ] bi@ [ #5 * ] dip + [ &TAPCODES ] dip fetch :c ] 'tap' define
    #2 #3 tap
    #2 #4 tap
    reset
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
    'thebirdman'
$a $b
#1
#-3
&100
