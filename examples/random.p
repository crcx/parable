"a really crappy pseudo-random number generator"
'seed' value
#12345 to seed
[ #36969 seed #65535 and * seed #16 shift + to seed #18000 seed #65535 and * seed #16 shift + to seed seed #-16 shift seed + ] 'random' define

'ATCG' 'dna' define
[ [ &dna random #4 rem fetch :c :s ] repeat ] 'build-dna-sequence' define
#10 build-dna-sequence depth #1 - [ + ] repeat
