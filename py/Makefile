default: clean interfaces

interfaces:
	cd scripting && make

clean:
	rm -f *.pyc *.py3 *~


python3:
	cp parable.py parable.py3
	2to3 parable.py3 >a.diff
	patch <a.diff
	rm a.diff
	cp legend.py legend.py3
	2to3 legend.py3 >a.diff
	patch <a.diff
	rm a.diff
	cp listener.py listener.py3
	2to3 listener.py3 >a.diff
	patch <a.diff
	rm a.diff


update:
	cp punga.py ~/www/api.forthworks.com/apologue
	cp parable.py ~/www/api.forthworks.com/apologue/1.8
	cp server/apologue-1.8 ~/www/api.forthworks.com/apologue/1.8/0
	cp stdlib.p ~/www/api.forthworks.com/apologue/1.8
	cp ika `which ika`
	cp pre `which pre`
	cp parable.py stdlib.p ~/active/cyanide
	cd ~/www/api.forthworks.com/apologue/parable && git pull
