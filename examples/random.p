'ATCG' '*DNA' variable!
[ [ @DNA random #10 * #4 rem fetch :s ] times ] 'build-dna-sequence' define
#10 build-dna-sequence depth #1 - [ + ] times
