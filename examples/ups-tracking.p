"This code parses a UPS Type 1Z tracking number and returns the subsections"
"in a readable format."

"See http://osiris.978.org/~alex/ups.html for a list of service codes."

[ [ #0 #2 substring '1Z' = ] sip swap ] 'valid?' define
[ [ #2 #8 substring 'Account: ' swap + ] sip ] 'account' define
[ [ #8 #10 substring 'Service code: ' swap + ] sip ] 'service-code' define
[ [ #10 #17 substring 'Package ID: ' swap + ] sip ] 'package-id' define
[ #17 fetch :c :s 'Checksum: ' swap + ] 'checksum' define
[ valid? [ account service-code package-id checksum ] [ drop 'invalid tracking number' ] if ] 'parse-ups' define

'1Z2203480342495730' parse-ups
