include ../Makefile.config

all: $(patsubst %.md, %.html, $(wildcard *.md))

%.html: %.md Makefile
	$(PYALT) ../tools/gfm.py $< >$@
	mv $@ html

clean:
	rm -f *.html *~
