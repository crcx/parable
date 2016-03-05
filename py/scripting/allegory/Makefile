default:
	cp ../../stdlib.p .
	cp ../../parable.py .
	cp ../../gen-snapshot.py .
	python3 gen-snapshot.py extensions.p
	python3 convert.py >allegory
	chmod +x allegory
	rm -f stdlib.p parable.py parable.snapshot gen-snapshot.py *.pyc
