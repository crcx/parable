default:
	cp ../../stdlib.p .
	cp ../../parable.py .
	cp ../../gen-snapshot.py .
	python gen-snapshot.py
	python convert.py >allegory
	chmod +x allegory
	rm stdlib.p parable.py parable.snapshot gen-snapshot.py *.pyc
