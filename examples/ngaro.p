"An implementation of Ngaro in Parable"
"-------------------------------------------------------------"
"Variable    Used For"
"=========   =================="
"ip          Instruction Pointer"
"ram         Ngaro memory"
"opcodes     Opcode Table"
"addresses   Address Stack"
"output      Simulated Output Device"
"-------------------------------------------------------------"
"This implementation uses the Parable data stack and functions"
"directly whenever possible."
"-------------------------------------------------------------"

'ip' value
[ 'ram'  'opcodes'  'addresses'  'output' ] variables

[ ip #1 + to ip ] 'ip+' define
[ &ram ip fetch ] '[ip]' define

[ &output @ :p :s ] 'display' define
[ display swap + &output ! ] '+display' define
'' &output !


'ports' variable
[ &ports swap fetch ] 'read-port' define
[ &ports swap store ] 'write-port' define

[ #2 read-port #1 = [ :c :s +display #0 #2 write-port ] if-true ] 'ngaro.devices' define

[ ] 'ngaro.nop' define
[ ip+ [ip] ] 'ngaro.lit' define
[ dup ] 'ngaro.dup' define
[ drop ] 'ngaro.drop' define
[ swap ] 'ngaro.swap' define
[ &addresses push ] 'ngaro.push' define
[ &addresses pop ] 'ngaro.pop' define
[ ] 'ngaro.loop' define
[ ip+ [ip] #1 - to ip ] 'ngaro.jump' define
[ ngaro.pop to ip ] 'ngaro.return' define
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
[ read-port ] 'ngaro.in' define
[ write-port ] 'ngaro.out' define
[ ngaro.devices ] 'ngaro.wait' define
[ ip ngaro.push #1 - to ip ] 'ngaro.implicit.call' define

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

[ dup #0 #30 between? [ &opcodes swap fetch invoke ] [ ngaro.implicit.call ] if ip+ ] 'process-opcode' define
[ #0 to ip [ [ip] process-opcode ip #1000 <> ] while-true display ] 'process-bytecode' define

&ram set-buffer
