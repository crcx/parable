"Ngaro: a MISC inspired virtual machine for a dual-stack architecture"

collect-garbage

[ 'Image'  'I'  'O'  'Data'  'Address'  'Ports'  'Input'  'Output' ] ::

[ "-" \
  0 !I \
  0 !O \
  request-empty !Image \
  request-empty !Data \
  [ 1 0 0 0 0 0 0 0 0 0 0 0 0 ] !Ports \
  request-empty :s !Output \
  request-empty :s !Input \
] 'ngaro.initialize' :


[ "-" @I 1 + !I ] 'I+' :
[ "-n" @Image @I fetch ] 'Image@' :
[ "n-" @Image @I store ] 'Image!' :

[ "-n" @Data pop :n ] 'D>' :
[ "n-" :n @Data push ] '>D' :
[ "-n" @Address pop ] 'A>' :
[ "n-" @Address push ] '>A' :

"I/O Simulation"
[ "-" \
  @Input head :n >D @Input body !Input \
  0 @Ports 1 store ] 'io-console-input' :

[ "-" \
  @Output :p :s D> :c :s + !Output \
  0 @Ports 2 store ] 'io-console-output' :

[ "-" \
  0 @Ports 5 store ] 'io-capabilities' :

[ "-" \
  @Ports 0 fetch 1 -eq? \
  [ \
    [ [ [ @Ports 1 fetch 1  eq? ]  [ io-console-input  ] ] \
      [ [ @Ports 2 fetch 1  eq? ]  [ io-console-output ] ] \
      [ [ @Ports 5 fetch 0 -eq? ]  [ io-capabilities   ] ] \
    ] when \
  ] if-true \
] 'simulate-io' :

"Implement the instructions"
[ "-" ] 'I.nop' :
[ "-"  I+ Image@ >D ] 'I.lit' :
[ "-"  D> dup >D >D ] 'I.dup' :
[ "-"  D> drop ] 'I.drop' :
[ "-"  D> D> swap >D >D ] 'I.swap' :
[ "-"  D> >A ] 'I.push' :
[ "-"  A> >D ] 'I.pop' :
[ "-" \
  I+ \
  D> 1 - dup >D zero? not \
  [ "-"  Image@ 1 - !I ] [ I.drop ] if ] 'I.loop' :
[ "-"  I+ Image@ 1 - !I ] 'I.jump' :
[ "-"  A> !I ] 'I.return' :
[ "-"  D> D> lt? [ I.jump ] [ I+ ] if ] 'I.lt_jump' :
[ "-"  D> D> gt? [ I.jump ] [ I+ ] if ] 'I.gt_jump' :
[ "-"  D> D> -eq? [ I.jump ] [ I+ ] if ] 'I.ne_jump' :
[ "-"  D> D> eq? [ I.jump ] [ I+ ] if ] 'I.eq_jump' :
[ "-"  @Image D> fetch >D ] 'I.fetch' :
[ "-"  D> D> swap @Image swap store ] 'I.store' :
[ "-"  D> D> + >D ] 'I.+' :
[ "-"  D> D> - >D ] 'I.-' :
[ "-"  D> D> * >D ] 'I.*' :
[ "-"  D> D> dup-pair rem floor [ / floor ] dip >D >D ] 'I./rem' :
[ "-"  D> D> and >D ] 'I.and' :
[ "-"  D> D> or >D ] 'I.or' :
[ "-"  D> D> xor >D ] 'I.xor' :
[ "-"  D> D> -1 * shift >D ] 'I.shl' :
[ "-"  D> D> shift >D ] 'I.shr' :
[ "-"  I.dup D> zero? [ I.drop I.return ] if-true ] 'I.0;' :
[ "-"  0 @Ports D> dup-pair fetch >D store ] 'I.in' :
[ "-"  D> D> swap @Ports swap store ] 'I.out' :
[ "-"  simulate-io ] 'I.wait' :
[ "-"  D> 1 + >D ] 'I.1+' :
[ "-"  D> 1 - >D ] 'I.1-' :
[ "-"  @I >A Image@ 1 - !I ] 'I.call' :

"Instruction dispatch"
"We could also use a lookup table for this, which would probably be faster"
[ "-" \
  @Image @I fetch !O \
  [ [ [ @O  0 eq? ] [ I.nop        ] ] \
    [ [ @O  1 eq? ] [ I.lit        ] ] \
    [ [ @O  2 eq? ] [ I.dup        ] ] \
    [ [ @O  3 eq? ] [ I.drop       ] ] \
    [ [ @O  4 eq? ] [ I.swap       ] ] \
    [ [ @O  5 eq? ] [ I.push       ] ] \
    [ [ @O  6 eq? ] [ I.pop        ] ] \
    [ [ @O  7 eq? ] [ I.loop       ] ] \
    [ [ @O  8 eq? ] [ I.jump       ] ] \
    [ [ @O  9 eq? ] [ I.return     ] ] \
    [ [ @O 10 eq? ] [ I.lt_jump    ] ] \
    [ [ @O 11 eq? ] [ I.gt_jump    ] ] \
    [ [ @O 12 eq? ] [ I.ne_jump    ] ] \
    [ [ @O 13 eq? ] [ I.eq_jump    ] ] \
    [ [ @O 14 eq? ] [ I.fetch      ] ] \
    [ [ @O 15 eq? ] [ I.store      ] ] \
    [ [ @O 16 eq? ] [ I.+          ] ] \
    [ [ @O 17 eq? ] [ I.-          ] ] \
    [ [ @O 18 eq? ] [ I.*          ] ] \
    [ [ @O 19 eq? ] [ I./rem       ] ] \
    [ [ @O 20 eq? ] [ I.and        ] ] \
    [ [ @O 21 eq? ] [ I.or         ] ] \
    [ [ @O 22 eq? ] [ I.xor        ] ] \
    [ [ @O 23 eq? ] [ I.shl        ] ] \
    [ [ @O 24 eq? ] [ I.shr        ] ] \
    [ [ @O 25 eq? ] [ I.0;         ] ] \
    [ [ @O 26 eq? ] [ I.1+         ] ] \
    [ [ @O 27 eq? ] [ I.1-         ] ] \
    [ [ @O 28 eq? ] [ I.in         ] ] \
    [ [ @O 29 eq? ] [ I.out        ] ] \
    [ [ @O 30 eq? ] [ I.wait       ] ] \
    [ [ true      ] [ I.call       ] ] \
  ] when \
] 'process-bytecode' :

"Top level implementation: loop over each instruction until at the end of"
"the slice."
[ "p-" \
  !Image \
  [ process-bytecode I+ @I @Image length? lt? ] while ] 'ngaro' :

"------------------------------------------------------------------------------"

"An assembler for Ngaro"
"Like the assembler part of the Retro metacompiler, this is kept very minimal,"
"though a few helper functions exist."

'Target' var

[ "n-"  :n @Target push ] 'v,' :
[ "ns-" [ [ v, ] curry ] dip : ] 'vmi' :
[ "s-"  @Target length? :p . ] 'label' :

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

[ "-" \
  request-empty !Target .jump 32 [ 31 v, ] times ] 'begin-assembly' :
[ "s-" @Target . ] 'save-assembly' :
[ "-"  @Target length? @Target 1 store ] ':main' :


"Some test images"

begin-assembly
':loop' label
  .dup
  .loop &:loop v,
  .ret
:main
  .lit 10 v,
  &:loop v,
'Ngaro:countdown' save-assembly


begin-assembly
:main
  .lit 1 v,
  .lit 2 v,
  .+
  .lit 3 v,
  .*
  .lit 3 v,
  .1+
'Ngaro:nine' save-assembly


begin-assembly
':putc' label
  .lit 1 v,
  .lit 2 v,
  .out
  .lit 0 v,
  .lit 0 v,
  .out
  .wait
  .ret

':(puts)' label
  .dup
  .fetch
  .0;
  &:putc v,
  .1+
  .jump &:(puts) v,

':puts' label
  &:(puts) v,
  .drop
  .ret

':hello' label
  $h v,
  $e v,
  $l v,
  $l v,
  $o v,
  0 v,

:main
  .lit &:hello v,
  &:puts v,

'Ngaro:display' save-assembly

ngaro.initialize

"0 &Ngaro:display [ over [ cons '{v}: {v}' interpolate display tty.cr ] dip 1 + ] for-each"

&Ngaro:nine ngaro
@Data invoke
@Output
