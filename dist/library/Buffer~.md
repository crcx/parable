## Buffer~

### Overview

### Code

````
[ 'CurrentBuffer'  'BufferOffset'  'buffer-position'  'buffer-advance' \
  'buffer-retreat' 'buffer-store-current'  'buffer-fetch-current' \
  'buffer-store'   'buffer-fetch'  'buffer-store-retreat' \
  'buffer-fetch-retreat'  'set-buffer'  'buffer-store-items'  'new-buffer' \
  'preserve-buffer'  'named-buffer' \
] 'Buffer~' {
  [ 'CurrentBuffer'  'BufferOffset' ] ::
  [ "-pn"    @CurrentBuffer @BufferOffset ] 'buffer-position' :
  [ "-"      &BufferOffset increment ] 'buffer-advance' :
  [ "-"      &BufferOffset decrement ] 'buffer-retreat' :
  [ "n-"     buffer-position store ] 'buffer-store-current' :
  [ "-n"     buffer-position fetch ] 'buffer-fetch-current' :
  [ "v-"     buffer-position store buffer-advance ] 'buffer-store' :
  [ "-n"     buffer-position fetch buffer-advance ] 'buffer-fetch' :
  [ "v-"     buffer-retreat buffer-position store ] 'buffer-store-retreat' :
  [ "-n"     buffer-retreat buffer-position fetch ] 'buffer-fetch-retreat' :
  [ "p-"     !CurrentBuffer 0 !BufferOffset ] 'set-buffer' :
  [ "...n-"  [ buffer-store ] times ] 'buffer-store-items' :
  [ "-"      request set-buffer ] 'new-buffer' :
  [ "p-"     @CurrentBuffer [ @BufferOffset [ invoke ] dip !BufferOffset ] dip !CurrentBuffer ] 'preserve-buffer' :
  [ "s-"     request [ swap : ] sip set-buffer ] 'named-buffer' :
}}
````
