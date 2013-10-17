"An implementation of Ngaro in Parable"
"-------------------------------------------------------------"
"Variable    Used For"
"=========   =================="
"ip          Instruction Pointer"
"ram         Ngaro memory"
"opcodes     Opcode Table"
"addresses   Address Stack"
"-------------------------------------------------------------"
"This implementation uses the Parable data stack and functions"
"directly whenever possible."
"-------------------------------------------------------------"

'ip' variable
'ram' variable
'opcodes' variable
'addresses' variable

[ &ip @ #1 + &ip ! ] 'ip+' define
[ &ram &ip @ fetch ] '[ip]' define

[ ] 'ngaro.nop' define
[ ip+ [ip] ] 'ngaro.lit' define
[ dup ] 'ngaro.dup' define
[ drop ] 'ngaro.drop' define
[ swap ] 'ngaro.swap' define
[ &addresses array-push ] 'ngaro.push' define
[ &addresses array-pop ] 'ngaro.pop' define
[ ] 'ngaro.loop' define
[ ip+ [ip] &ip ! ] 'ngaro.jump' define
[ ngaro.pop &ip ! ] 'ngaro.return' define
[ >  [ ngaro.jump ] [ ip+ ] if ] 'ngaro.jump.gt' define
[ <  [ ngaro.jump ] [ ip+ ] if ] 'ngaro.jump.lt' define
[ <> [ ngaro.jump ] [ ip+ ] if ] 'ngaro.jump.ne' define
[ =  [ ngaro.jump ] [ ip+ ] if ] 'ngaro.jump.eq' define
[ &ram swap fetch ] 'ngaro.fetch' define
[ &ram swap store ] 'ngaro.store' define
[ + ] 'ngaro.add' define
[ - ] 'ngaro.sub' define
[ * ] 'ngaro.mul' define
[ dup-pair rem floor [ / floor ] dip ] 'ngaro.divmod' define
[ and ] 'ngaro.and' define
[ or ] 'ngaro.or' define
[ xor ] 'ngaro.xor' define
[ #-1 * shift ] 'ngaro.shl' define
[ shift ] 'ngaro.shr' define
[ dup #0 = [ drop ngaro.return ] if-true ] 'ngaro.zeroexit' define
[ #1 + ] 'ngaro.inc' define
[ #1 - ] 'ngaro.dec' define
[ "stub" drop #0 ] 'ngaro.in' define
[ "stub" drop-pair ] 'ngaro.out' define
[ "stub" ] 'ngaro.wait' define
[ &ip @ ngaro.push &ip ! ] 'ngaro.implicit.call' define

"Build the dispatch table for the opcodes"
&opcodes        slice-set
&ngaro.nop      slice-store
&ngaro.lit      slice-store
&ngaro.dup      slice-store
&ngaro.drop     slice-store
&ngaro.swap     slice-store
&ngaro.push     slice-store
&ngaro.pop      slice-store
&ngaro.loop     slice-store
&ngaro.jump     slice-store
&ngaro.return   slice-store
&ngaro.jump.gt  slice-store
&ngaro.jump.lt  slice-store
&ngaro.jump.ne  slice-store
&ngaro.jump.eq  slice-store
&ngaro.fetch    slice-store
&ngaro.store    slice-store
&ngaro.add      slice-store
&ngaro.sub      slice-store
&ngaro.mul      slice-store
&ngaro.divmod   slice-store
&ngaro.and      slice-store
&ngaro.or       slice-store
&ngaro.xor      slice-store
&ngaro.shl      slice-store
&ngaro.shr      slice-store
&ngaro.zeroexit slice-store
&ngaro.inc      slice-store
&ngaro.dec      slice-store
&ngaro.in       slice-store
&ngaro.out      slice-store
&ngaro.wait     slice-store

[ dup #0 #30 between? [ &opcodes swap fetch invoke ] [ ngaro.implicit.call ] if ip+ ] 'process-opcode' define

&ram slice-set
#1 slice-store "LIT 2"
#2 slice-store
#1 slice-store "LIT 2"
#2 slice-store
#5 slice-store "PUSH"
#1 slice-store "LIT 3"
#3 slice-store
#6 slice-store "POP"

#1 slice-store "LIT 5"
#5 slice-store
#1 slice-store "LIT 2"
#2 slice-store
#19 slice-store "DIVMOD"

#0 &ip ! [ [ip] process-opcode &ip @ #1000 <> ] while-true
