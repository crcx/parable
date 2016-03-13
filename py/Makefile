PY = pypy3
DISTDIR = parable-201603

default: clean all

all:
	$(PY) gen-snapshot.py
	cd interfaces && make

clean:
	rm -rf *.pyc __pycache__ *~ parable-dist.tar.gz

update:
#	cp server/punga.py ~/www/api.forthworks.com/apologue
	cp parable.py stdlib.p ~/www/api.forthworks.com/apologue/2
#	cp parable.py ~/www/api.forthworks.com/apologue/1.8
#	cp server/apologue-1.8 ~/www/api.forthworks.com/apologue/1.8/0
#	cp stdlib.p ~/www/api.forthworks.com/apologue/1.8
	cp allegory `which allegory`
	cp parable.py stdlib.p ~/active/cyanide
	cd ~/www/api.forthworks.com/apologue/parable && git pull

dist: clean all
	mkdir $(DISTDIR)
	cp parable.py $(DISTDIR)
	cp stdlib.p $(DISTDIR)
	cp listener.py $(DISTDIR)
	cp allegory $(DISTDIR)
	cp ../*.md $(DISTDIR)
	tar cf parable-dist.tar $(DISTDIR)
	gzip -9 parable-dist.tar
	rm -rf $(DISTDIR)
