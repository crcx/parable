'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_=!@#$%^&*()-=+[]{},./?`~'  'password-characters' define

[ random #1000 * &password-characters :s length nip rem ] 'random-index' define
[ &password-characters random-index fetch :c ] 'get-random-character' define
[ [ &get-random-character repeat ] array-from-quote [ array-push ] sip :s ] 'generate-password' define

#15 generate-password

