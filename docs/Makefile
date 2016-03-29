all: $(patsubst %.md, %.html, $(wildcard *.md))

%.html: %.md Makefile
	../tools/gfm.py $< >$@

clean:
	rm -f *.html *~
