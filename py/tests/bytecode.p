request 't' define
request 'f' define
[ &t #0 fetch #1 + &t #0 store ] '+t' define
[ &f #0 fetch #1 + &f #0 store ] '+f' define
[ [ '  + pass' +t ] [ '  - fail' +f ] if ] 'check' define
[ &t #0 fetch :s ' passed, ' + &f #0 fetch :s ' failed' + + ] 'summary' define

':n'

    #10 :n #10 = check
    '20' :n #20 = check
    $a :n #97 = check
    $z :n #122 = check
    #1 #1 = :n #-1 = check
    #2 #1 = :n #0 = check
    &define :n #0 = check

':s'

    #100 :s '100.0' = check
    #100.6 :s '100.6' = check
    #-0.56 :s '-0.56' = check
    $a :s 'a' = check
    #-1 :f :s 'true' = check

':c'

    #97 :c $a = check
    'a' :c $a = check

':p'

    #0 :p &0 = check
    #100 :p &1012 <> check

':f'

    #-1 :f check
    #0 :f #-1 :f <> check

'type?'

    #1      type? #100 = check drop
    'hello' type? #200 = check drop
    $a      type? #300 = check drop
    &define type? #400 = check drop
    #-1 :f  type? #500 = check drop

'+'

    #33 #3 + #36 = check
    #33 #-1 + #32 = check
    'a' 'b' + 'ab' = check

'-'

    #33 #1 - #32 = check
    #33 #-1 - #34 = check

'*'

    #9 #9 * #81 = check
    #1 #0.5 * #0.5 = check

'/'

'rem'

'floor'

'^'

'log'

'log10'

'log<n>'

'shift'

'and'

'or'

'xor'

'random'

'sqrt'

    #144 sqrt #12 = check

'<'

    #1 #2 < check
    #2 #1 < :n #0 = check

'>'

    #1 #2 > :n #0 = check
    #2 #1 > check

'<='

'>='

'='

'<>'

'if'

'while-true'

'while-false'

'repeat'

'invoke'

    [ #1 #3 + ] '"4"' define
    &"4" invoke #4 = check

'dip'

'sip'

'bi'

'tri'

'copy'

'fetch'

'store'

'request'

'release'

'collect-garbage'

'get-last-index'

'set-last-index'

'dup'

    #2 dup #2 = swap #2 = and check
    #1 #2 dup #2 = swap #2 = and swap #1 = and check
    'apple' dup 'apple' = swap 'apple' = and check
    $a dup $a = swap $a = and check

'drop'

    #1 #2 drop #1 = check
    #1 #2 #3 drop drop #1 = check
    $a $1 #2 drop $1 = swap $a = and check

'swap'

    #1 #2 swap #1 = swap #2 = and check
    $a #2 swap $a = swap #2 = and check

'over'

    #1 #2 over #1 = swap #2 = and swap #1 = and check
    $e #2 over $e = swap #2 = and swap $e = and check
    '1' #2 over '1' = swap #2 = and swap '1' = and check

'tuck'

    #1 #2 tuck #2 = swap #1 = and swap #2 = and check
    $e #2 tuck #2 = swap $e = and swap #2 = and check
    '1' #2 tuck #2 = swap '1' = and swap #2 = and check

'nip'

    #1 #2 #3 nip #3 = swap #1 = and check

'depth'

'reset'

'function-exists?'

    'define' function-exists? :n #-1 = check
    'foobar' function-exists? :n #0  = check

'lookup-function'

    'define' lookup-function &0 = check
    'foobar' lookup-function &-1 = check

'hide-function'

'find'

'subslice'

'numeric?'

'to-lowercase'

'to-uppercase'

'report-error'

'sin'

'cos'

'tan'

'asin'

'acos'

'atan'

'atan2'

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
summary
