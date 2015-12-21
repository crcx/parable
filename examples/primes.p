[ '~I'  '*Primes' ] values

2 to ~I

[ "-"  ~I 1 + to ~I ] '(next)' define

"Generate an array of possibilities"
[ 2 500 expand-range ] capture-results

"Remove the even ones (except for 2)"
[ dup 2 eq? swap even? not xor ] filter


"Filter the rest"
[ collect-garbage \
  [ dup ~I eq? swap ~I rem 0 -eq? xor :f ] filter \
  (next) ~I 500 lteq? ] while-true to *Primes

[ '~I'  '(next)' ] hide-functions

*Primes invoke

