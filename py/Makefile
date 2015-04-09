pre: clean
	python convert.py > pre
	chmod +x pre

clean:
	rm -f *.pyc *.py3


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

