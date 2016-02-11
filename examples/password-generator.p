'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_=!@#$%^&*()-=+[]{},./?`~'
'Password-Characters' variable!

[ "-n"   random #1000 * @Password-Characters slice-length? nip rem ] 'random-index' define
[ "-c"   @Password-Characters random-index fetch ] 'get-random-character' define
[ "n-s"  [ &get-random-character times ] capture-results [ push ] sip :s ] 'generate-password' define

#15 generate-password
