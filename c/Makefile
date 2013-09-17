CC = clang
FLAGS = -O3 -g -Wall -c

default: clean
	$(CC) $(FLAGS) parable.c -o parable.o
	$(CC) $(FLAGS) pre.c -o pre.o
	$(CC) pre.o parable.o -lm -o pre
	strip pre

clean:
	rm -f *.o pre

