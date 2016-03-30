## Shorthand~

### Overview

Useful shortcuts from kiy's on_startup.md

### Code

````
'Shorthand~' vocab{
  ';'         &invoke .
  'push-'     [ "vp-p" dup push ] .
  ','         [ "pv-p" swap &push sip ] .
  '.-'        [ "sp-s" over : ] .
  ';p'        [ "?-?" pointer? &; &nop if "invoke if pointer" ] .
  ';.'        [ "?-?" &;p map . ] .
  ';-'        &invoke<preserving> .
  'stop'      &abort<with-error> .
  '--'        &reset .
  'drop-all'  &reset .
  'drops'     &drop<n> .
  '2drops'    &drop-pair .
  'dim?'      &get<final-offset> .
  'dim!'      &set<final-offset> .
  '1.1+'      &increment .
  '1.1-'      &decrement .
  'index'     &index-of  .
  'unk'       [ "-u"    #nan :u        ] .
  'unk?'      [ "n-nf"  dup   unknown? ] .
  'nan?-'     [ "n-nf"  dup       nan? ] .
    '0?'      [ "n-nf"  dup      zero? ] .
   '-1?'      [ "n-nf"  dup #-1    eq? ] .
    '1?'      [ "n-nf"  dup #1     eq? ] .
   '0+?'      [ "n-nf"  dup #0   gteq? ] .
   '0-?'      [ "n-nf"  dup #0   lteq? ] .
    '-?'      [ "n-nf"  dup #0     lt? ] .
    '+?'      [ "n-nf"  dup #0     gt? ] .
   '-0?'      [ "n-nf"  dup #0    -eq? ] .
    '=?'      [ "nN-nf" over       eq? ] .
   '-=?'      [ "nN-nf" over      -eq? ] .
    '>?'      [ "nN-nf" over       lt? ] .
    '<?'      [ "nN-nf" over       gt? ] .
   '=<?'      [ "nN-nf" over     gteq? ] .
   '>=?'      [ "nN-nf" over     lteq? ] .
  'len?'      [ "p-pn"  dup    length? ] .
}vocab
````

### Legal

Extracted from: https://github.com/kiy/actionrate/blob/master/parable/on_startup.md, commit 49ea9bb61f9e8b470fcb757e11124804c565fb16
