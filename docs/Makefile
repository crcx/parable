all: $(patsubst %.md, %.html, $(wildcard *.md))

%.html: %.md Makefile
	../tools/gfm.py $< >$@
	mv $@ html

clean:
	rm -f *.html *~
