default:
	cp ../bootstrap.p .
	cp ../parable.coffee .
	coffee -bc parable.coffee
	coffee -bc ui.coffee
	mv ui.js scratch
	grep -v var\ sp  scratch | grep -v var\ log  >ui.js
	rm scratch

clean:
	rm parable.coffee bootstrap.p *.js
