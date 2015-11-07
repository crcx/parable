'ATCG' 'dna' define
[ [ &dna random #10 * #4 rem fetch :s ] repeat ] 'build-dna-sequence' define
#10 build-dna-sequence depth #1 - [ + ] repeat
