PY = pypy3
default: parable turnkeys documents clean

clean:
	rm -f generate-reference.py
	rm -f *~

parable:
	cd py && make

turnkeys: parable
	$(PY) py/allegory tools/gen_wordlist_turnkey.p

documents: turnkeys
	$(PY) generate-reference.py >docs/Standard_Library.md
