default: clean interfaces

interfaces:
	cd scripting && make

clean:
	rm -rf *.pyc __pycache__ *~

update:
	cp server/punga.py ~/www/api.forthworks.com/apologue
	cp parable.py stdlib.p ~/www/api.forthworks.com/apologue/2
#	cp parable.py ~/www/api.forthworks.com/apologue/1.8
#	cp server/apologue-1.8 ~/www/api.forthworks.com/apologue/1.8/0
#	cp stdlib.p ~/www/api.forthworks.com/apologue/1.8
	cp allegory `which allegory`
	cp parable.py stdlib.p ~/active/cyanide
	cd ~/www/api.forthworks.com/apologue/parable && git pull
