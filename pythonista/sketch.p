[ `2000 ] 'current-touch' define
[ `2001 ] 'draw:fill' define
[ `2002 ] 'draw:ellipse' define
[ `2003 ] 'draw:background' define

[ #1 #0 #0 draw:fill ] 'red' define
[ #1 #1 #1 draw:background ] 'bg' define
[ current-touch [ #50 - ] bi@ #100 #100 draw:ellipse ] 'circle' define
[ bg current-touch + #0 <> [ red circle ] if-true ] 'draw' define

