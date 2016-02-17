[ dup-pair lt? [ swap ] if-true ] 'sort-pair' :
[ ] 'perform-sort' :
[ sort-pair depth #2 gt? [ [ perform-sort ] dip ] if-true ] 'perform-sort' :
[ depth [ perform-sort ] times ] 'sort' :

#3 #33 #22 #333 #5 sort
