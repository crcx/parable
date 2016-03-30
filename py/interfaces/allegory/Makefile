include ../../../Makefile.config

default:
	cp ../../stdlib.p .
	cp ../../parable.py .
	cp ../../gen-snapshot.py .
	$(PY) gen-snapshot.py extensions.p
	$(PY) convert.py >allegory1
	cat allegory1 | sed s'/python3/$(PY)/' >allegory
	rm -f allegory1
	chmod +x allegory
	rm -f stdlib.p parable.py parable.snapshot gen-snapshot.py *.pyc
