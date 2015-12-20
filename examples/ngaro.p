"Ngaro"

[ '*Image'  '*I'  '*O'  '*Ports' ] values
[ '*Data'   '*Address' ] values
[ '*Input'  '*Output' ] values

[ 1 0 0 0 0 0 0 0 0 0 0 0 0 ] to *Ports


[ "-" *I 1 + to *I ] '*I+' define
[ "-n" *Image *I fetch ] '@Image' define
[ "n-" *Image *I store ] '!Image' define

[ "-n" *Data pop ] 'D>' define
[ "n-" *Data push ] '>D' define
[ "-n" *Address pop ] 'A>' define
[ "n-" *Address push ] '>A' define

[ "-" \
  *Input first :n >D *Input rest to *Input \
  0 *Ports 1 store \
] 'io-console-input' define

[ "-" \
  *Output D> :c :s + to *Output \
  0 *Ports 2 store \
] 'io-console-output' define

[ "-" \
  *Ports 0 fetch 1 -eq? \
  [ \
    [ [ [ *Ports 1 fetch 1 eq? ] \
        [ io-console-input ] ] \
      [ [ *Ports 2 fetch 1 eq? ] \
        [ io-console-output ] ] \
      [ [ *Ports 5 fetch 0 -eq? ] \
        [ "capabilities" ] ] \
    ] when \
  ] if-true \
] 'simulate-io' define

[ "-" ] 'I.nop' define
[ "-"  *I+ @Image >D ] 'I.lit' define
[ "-"  D> dup >D >D ] 'I.dup' define
[ "-"  D> drop ] 'I.drop' define
[ "-"  D> D> swap >D >D ] 'I.swap' define
[ "-"  D> >A ] 'I.push' define
[ "-"  A> >D ] 'I.pop' define
[ "-"  D> 1 - >D *I+ D> dup >D zero? not [ "-"  @Image 1 - to *I ] [ I.drop ] if ] 'I.loop' define
[ "-"  *I+ @Image 1 - to *I ] 'I.jump' define
[ "-"  A> to *I ] 'I.return' define
[ "-"  D> D> lt? [ I.jump ] [ *I+ ] if ] 'I.lt_jump' define
[ "-"  D> D> gt? [ I.jump ] [ *I+ ] if ] 'I.gt_jump' define
[ "-"  D> D> -eq? [ I.jump ] [ *I+ ] if ] 'I.ne_jump' define
[ "-"  D> D> eq? [ I.jump ] [ *I+ ] if ] 'I.eq_jump' define
[ "-"  *Image D> fetch >D ] 'I.fetch' define
[ "-"  D> D> swap *Image swap store ] 'I.store' define
[ "-"  D> D> + >D ] 'I.+' define
[ "-"  D> D> - >D ] 'I.-' define
[ "-"  D> D> * >D ] 'I.*' define
[ "-"  D> D> dup-pair rem floor [ / floor ] dip >D >D ] 'I./rem' define
[ "-"  D> D> and >D ] 'I.and' define
[ "-"  D> D> or >D ] 'I.or' define
[ "-"  D> D> xor >D ] 'I.xor' define
[ "-"  D> D> -1 * shift >D ] 'I.shl' define
[ "-"  D> D> shift >D ] 'I.shr' define
[ "-"  I.dup D> zero? [ I.drop I.return ] if-true ] 'I.0;' define
[ "-"  0 *Ports D> dup-pair fetch >D store ] 'I.in' define
[ "-"  D> D> swap *Ports swap store ] 'I.out' define
[ "-"  simulate-io ] 'I.wait' define
[ "-"  D> 1 + >D ] 'I.1+' define
[ "-"  D> 1 - >D ] 'I.1-' define
[ "-"  *I >A @Image 1 - to *I ] 'I.call' define

[ "-" \
  *Image *I fetch to *O \
  [ [ [ *O  0 eq? ] [ I.nop        ] ] \
    [ [ *O  1 eq? ] [ I.lit        ] ] \
    [ [ *O  2 eq? ] [ I.dup        ] ] \
    [ [ *O  3 eq? ] [ I.drop       ] ] \
    [ [ *O  4 eq? ] [ I.swap       ] ] \
    [ [ *O  5 eq? ] [ I.push       ] ] \
    [ [ *O  6 eq? ] [ I.pop        ] ] \
    [ [ *O  7 eq? ] [ I.loop       ] ] \
    [ [ *O  8 eq? ] [ I.jump       ] ] \
    [ [ *O  9 eq? ] [ I.return     ] ] \
    [ [ *O 10 eq? ] [ I.lt_jump    ] ] \
    [ [ *O 11 eq? ] [ I.gt_jump    ] ] \
    [ [ *O 12 eq? ] [ I.ne_jump    ] ] \
    [ [ *O 13 eq? ] [ I.eq_jump    ] ] \
    [ [ *O 14 eq? ] [ I.fetch      ] ] \
    [ [ *O 15 eq? ] [ I.store      ] ] \
    [ [ *O 16 eq? ] [ I.+          ] ] \
    [ [ *O 17 eq? ] [ I.-          ] ] \
    [ [ *O 18 eq? ] [ I.*          ] ] \
    [ [ *O 19 eq? ] [ I./rem       ] ] \
    [ [ *O 20 eq? ] [ I.and        ] ] \
    [ [ *O 21 eq? ] [ I.or         ] ] \
    [ [ *O 22 eq? ] [ I.xor        ] ] \
    [ [ *O 23 eq? ] [ I.shl        ] ] \
    [ [ *O 24 eq? ] [ I.shr        ] ] \
    [ [ *O 25 eq? ] [ I.0;         ] ] \
    [ [ *O 26 eq? ] [ I.1+         ] ] \
    [ [ *O 27 eq? ] [ I.1-         ] ] \
    [ [ *O 28 eq? ] [ I.in         ] ] \
    [ [ *O 29 eq? ] [ I.out        ] ] \
    [ [ *O 30 eq? ] [ I.wait       ] ] \
    [ [ true      ] [ I.call       ] ] \
  ] when \
] 'process-bytecode' define


[ "p-" to *Image [ process-bytecode *I+ *I *Image length? lt? ] while-true ] 'ngaro' define

0 to *I
0 to *O
request-empty to *Image
request-empty to *Data


"Ngaro Assembler"

'*Target' value
request-empty to *Target
[ "n-"  :n *Target push ] 'v,' define
[ "ns-" [ [ v, ] curry ] dip define ] 'vmi' define

[ "s-"  *Target length? swap define ] 'label' define

0 '.nop' vmi
1 '.lit' vmi
2 '.dup' vmi
3 '.drop' vmi
4 '.swap' vmi
5 '.push' vmi
6 '.pop' vmi
7 '.loop' vmi
8 '.jump' vmi
9 '.ret' vmi
10 '.ltjump' vmi
11 '.gtjump' vmi
12 '.nejump' vmi
13 '.eqjump' vmi
14 '.fetch' vmi
15 '.store' vmi
16 '.+' vmi
17 '.-' vmi
18 '.*' vmi
19 './mod' vmi
20 '.and' vmi
21 '.or' vmi
22 '.xor' vmi
23 '.shl' vmi
24 '.shr' vmi
25 '.0;' vmi
26 '.1+' vmi
27 '.1-' vmi
28 '.in' vmi
29 '.out' vmi
30 '.wait' vmi

[ "-"  request-empty to *Target ] 'begin-assembly' define
[ "s-" [ *Target ] dip define ] 'save-assembly' define

"Some test images"
begin-assembly

  .lit 10 v,

':loop' label

  .dup
  .loop &:loop v,

'Ngaro:countdown' save-assembly


begin-assembly

  .lit 1 v,
  .lit 2 v,
  .+
  .lit 3 v,
  .*
'Ngaro:nine' save-assembly


begin-assembly

  .jump 0 v,

32 [ .nop ] times

':putc' label
  .lit 1 v,
  .lit 2 v,
  .out
  .lit 0 v,
  .lit 0 v,
  .out
  .wait
  .ret

[ "-"  *Target length? *Target 1 store ] ':main' define

:main

  .lit 98 v,
  &:putc v,
  .lit 99 v,
  &:putc v,
  .lit 100 v,
  &:putc v,

'Ngaro:display' save-assembly

request-empty :s to *Output
'aeiou' to *Input

&Ngaro:display Ngaro
*Data invoke
*Output

