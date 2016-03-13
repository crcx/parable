"Return all primes below 1000"

[ 'I'  'Primes' ] ::

3 !I

[ "-"  @I 2 + !I ] '(next)' :

"Generate an array of possibilities"
[ 2 1000 expand-range ] capture-results

"Remove the even ones (except for 2)"
[ dup 2 eq? swap even? not xor ] filter

"Filter the rest"
[ collect-garbage \
  [ dup @I eq? swap @I rem 0 -eq? xor :f ] filter \
  (next) @I 1000 lteq? ] while

reverse !Primes

@Primes invoke
