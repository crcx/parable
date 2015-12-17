"An implementation of Ngaro in Parable"
"-------------------------------------------------------------"
"Variable    Used For"
"=========   =================="
"*IP         Instruction Pointer"
"ram         Ngaro memory"
"opcodes     Opcode Table"
"addresses   Address Stack"
"output      Simulated Output Device"
"-------------------------------------------------------------"
"This implementation uses the Parable data stack and functions"
"directly whenever possible."
"-------------------------------------------------------------"

'*IP' value
[ 'ram'  'opcodes'  'addresses'  'output' ] variables

[ *IP #1 + to *IP ] '*IP+' define
[ &ram *IP fetch ] '[ip]' define

[ &output @ :p :s ] 'display' define
[ display swap + &output ! ] '+display' define
'' &output !


'ports' variable
[ &ports swap fetch ] 'read-port' define
[ &ports swap store ] 'write-port' define

[ #2 read-port #1 eq? [ :c :s +display #0 #2 write-port ] if-true ] 'ngaro.devices' define

[ ] 'ngaro.nop' define
[ *IP+ [ip] ] 'ngaro.lit' define
[ dup ] 'ngaro.dup' define
[ drop ] 'ngaro.drop' define
[ swap ] 'ngaro.swap' define
[ &addresses push ] 'ngaro.push' define
[ &addresses pop ] 'ngaro.pop' define
[ ] 'ngaro.loop' define
[ *IP+ [ip] #1 - to *IP ] 'ngaro.jump' define
[ ngaro.pop to *IP ] 'ngaro.return' define
[ gt?  [ ngaro.jump ] [ *IP+ ] if ] 'ngaro.jump.gt' define
[ lt?  [ ngaro.jump ] [ *IP+ ] if ] 'ngaro.jump.lt' define
[ -eq? [ ngaro.jump ] [ *IP+ ] if ] 'ngaro.jump.ne' define
[ eq?  [ ngaro.jump ] [ *IP+ ] if ] 'ngaro.jump.eq' define
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
[ dup zero? [ drop ngaro.return ] if-true ] 'ngaro.zeroexit' define
[ #1 + ] 'ngaro.inc' define
[ #1 - ] 'ngaro.dec' define
[ read-port ] 'ngaro.in' define
[ write-port ] 'ngaro.out' define
[ ngaro.devices ] 'ngaro.wait' define
[ *IP ngaro.push #1 - to *IP ] 'ngaro.implicit.call' define

"Build the dispatch table for the opcodes"
&opcodes        set-buffer
&ngaro.nop      buffer-store
&ngaro.lit      buffer-store
&ngaro.dup      buffer-store
&ngaro.drop     buffer-store
&ngaro.swap     buffer-store
&ngaro.push     buffer-store
&ngaro.pop      buffer-store
&ngaro.loop     buffer-store
&ngaro.jump     buffer-store
&ngaro.return   buffer-store
&ngaro.jump.gt  buffer-store
&ngaro.jump.lt  buffer-store
&ngaro.jump.ne  buffer-store
&ngaro.jump.eq  buffer-store
&ngaro.fetch    buffer-store
&ngaro.store    buffer-store
&ngaro.add      buffer-store
&ngaro.sub      buffer-store
&ngaro.mul      buffer-store
&ngaro.divmod   buffer-store
&ngaro.and      buffer-store
&ngaro.or       buffer-store
&ngaro.xor      buffer-store
&ngaro.shl      buffer-store
&ngaro.shr      buffer-store
&ngaro.zeroexit buffer-store
&ngaro.inc      buffer-store
&ngaro.dec      buffer-store
&ngaro.in       buffer-store
&ngaro.out      buffer-store
&ngaro.wait     buffer-store

[ dup #0 #30 between? [ &opcodes swap fetch invoke ] [ ngaro.implicit.call ] if *IP+ ] 'process-opcode' define
[ #0 to *IP [ [ip] process-opcode *IP #1000 -eq? ] while-true display ] 'process-bytecode' define

&ram set-buffer
