[ dup-pair < [ swap ] if-true ] 'sort-pair' define
[ ] 'perform-sort' define
[ sort-pair depth #2 > [ [ perform-sort ] dip ] if-true ] 'perform-sort' define
[ depth [ perform-sort ] times ] 'sort' define

#3 #33 #22 #333 #5 sort
