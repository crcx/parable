include Makefile.config
default: parable turnkeys documents clean

clean:
	rm -f generate-reference.py
	rm -f *~

parable:
	cd py && make

turnkeys: parable
	$(PY) ../dist/allegory tools/gen_wordlist_turnkey.p

documents: turnkeys
	$(PY) generate-reference.py >docs/Standard_Library.md
	cd docs && make

