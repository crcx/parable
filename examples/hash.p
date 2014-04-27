"loselose: from K&R (1st ed)"
"This is provided as a reference only: don't use it for any real purposes"
[ #0 swap [ :n [ swap ] dip + swap ] for-each-character ] 'loselose' define

"djb2: this is the one provided by Retro's hash' vocabulary"
[ #5381 swap [ :n [ swap ] dip over #-5 shift + + swap ] for-each-character ] 'djb2' define

"sdbm"
[ :n over #-6 shift + over #-16 shift + swap - ] 'sdbm<n>' define
[ #0 swap [ [ swap ] dip sdbm<n> swap ] for-each-character ] 'sdbm' define

"LRC: longitudinal redundancy check"
[ #0 swap [ :n [ swap ] dip + #255 and swap ] for-each-character #255 xor #1 + #255 and ] 'lrc' define

"xor"
[ #0 swap [ :n [ swap ] dip xor swap ] for-each-character ] 'xor-hash' define

"Fowler/Noll/Vo"
[ #2166136261 swap [ :n [ swap ] dip swap #16777619 * swap xor swap ] for-each-character ] 'fnv' define

"top level functions"
[ djb2 ] 'chosen-hash' define
[ #389 ] 'hash-prime' define
[ chosen-hash hash-prime rem ] 'hash' define

