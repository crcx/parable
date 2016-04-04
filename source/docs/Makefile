include ../Makefile.config

all: $(patsubst %.md, %.html, $(wildcard *.md))

%.html: %.md Makefile
	$(PYALT) ../tools/gfm.py $< >$@
	mv $@ ../../docs

clean:
	rm -f *.html *~
