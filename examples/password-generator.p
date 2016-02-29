'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_=!@#$%^&*()-=+[]{},./?`~'
'Password-Characters' var!

[ "-n"   random #1000 * @Password-Characters dup length? nip rem ] 'random-index' :
[ "-c"   @Password-Characters random-index fetch ] 'get-random-character' :
[ "n-s"  [ &get-random-character times ] capture-results [ push ] sip :s ] 'generate-password' :

#15 generate-password
