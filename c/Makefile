CC = clang
FLAGS = -g -Wall -c

default: clean
	$(CC) $(FLAGS) parable.c -o parable.o
	$(CC) $(FLAGS) pre.c -o pre.o
	$(CC) pre.o parable.o -lm -o pre

clean:
	rm -f *.o pre

