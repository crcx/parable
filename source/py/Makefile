include ../Makefile.config

default: clean all

all:
	$(PY) gen-snapshot.py
	cd interfaces && make

clean:
	rm -rf *.pyc __pycache__ *~
