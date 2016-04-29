include ../Makefile.config

default: clean all permissions

all:
	$(PY) gensource.py
	$(PY) gen-snapshot.py

clean:
	rm -rf *.pyc __pycache__ *~

permissions:
	chmod +x parable.py
	chmod +x repl.py

