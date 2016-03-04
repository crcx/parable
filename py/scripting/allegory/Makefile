default:
	cp ../../stdlib.p .
	cp ../../parable.py .
	cp ../../gen-snapshot.py .
	python2 gen-snapshot.py
	python2 convert.py >allegory
	chmod +x allegory
	rm -f stdlib.p parable.py parable.snapshot gen-snapshot.py *.pyc
