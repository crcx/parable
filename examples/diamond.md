## Diamond Text

### Overview

This was inspired by a bit of code from CoSy.4th and 8th:

* https://groups.google.com/forum/#!topic/comp.lang.forth/tBaqNt7uTDI
* http://8th-dev.com/forum/index.php/topic,889.0.html

### Code

This exposes two functions:

**diamond**

> string - ... strings ...

Shifts a string by the last shift amount (defaults to 7) and constructs a diamond pattern.

**diamond\<shift\>**

> string number - ... strings ...

Shifts a string by the specified shift amount and constructs a diamond pattern.

A sample output:

>      9.0       'don't walk on the iceeci eht no klaw t'nod'
>      8.0       'on't walk on the iceddeci eht no klaw t'no'
>      7.0       'n't walk on the icedoodeci eht no klaw t'n'
>      6.0       ''t walk on the icedonnodeci eht no klaw t''
>      5.0       ''t walk on the icedonnodeci eht no klaw t''
>      4.0       ''t walk on the icedonnodeci eht no klaw t''
>      3.0       ''t walk on the icedonnodeci eht no klaw t''
>      2.0       'n't walk on the icedoodeci eht no klaw t'n'
>      1.0       'on't walk on the iceddeci eht no klaw t'no'
> TOS  0.0       'don't walk on the iceeci eht no klaw t'nod'


````
[ 'diamond'  'diamond<shift>' ] {
  [ 's' 'DiamondShift' ] ::

  7 !DiamondShift

  [ "s-"  !s \
    [ @s dup @DiamondShift [ cycle :s dup ] times ] capture-results \
  ] 'capture' :

  [ "p-..." \
    !s [ @s [ dup reverse + ] for-each ] capture-results \
  ] 'process' :

  [ "s-...s..." capture process &invoke sip reverse invoke ] 'diamond' :
  [ "sn-...s..." !DiamondShift capture process &invoke sip reverse invoke ] 'diamond<shift>' :
}
````

### Example

````
'Have some fun with Parable' diamond
'--------------------------'
'Have some fun with Parable' 30 diamond<shift>
````
