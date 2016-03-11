PY = pypy3
default:
	cp ../../stdlib.p .
	cp ../../parable.py .
	cp ../../gen-snapshot.py .
	$(PY) gen-snapshot.py extensions.p
	$(PY) convert.py >allegory
	chmod +x allegory
	rm -f stdlib.p parable.py parable.snapshot gen-snapshot.py *.pyc
