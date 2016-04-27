include ../Makefile.config

default: clean all

all:
	$(PY) gensource.py
	$(PY) gen-snapshot.py

clean:
	rm -rf *.pyc __pycache__ *~
