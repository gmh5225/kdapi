CSTD=iso9899:1999
CC=gcc
DEBUG=-ggdb
CFLAGS=-Wall -Werror -pedantic $(DEBUG)

build: test

test: test.o
	$(CC) $(CFLAGS) -std=$(CSTD) test.o -o test

test.o: test.c
	$(CC) $(CFLAGS) -std=$(CSTD) -c test.c -o test.o

.PHONY: build
