#CUnit directories
TESTINC:=/usr/local/include/
TESTBIN:=/usr/local/lib/
CC=clang
LD=clang
CFLAGS=-c -g -Wall

all : RUN

RUN : test_gmshreader 
	./test_gmshreader

test_gmshreader : test_gmshreader.o
	$(LD) $(LDFLAGS)  -L$(TESTBIN) -L../ -lCUnit -ll -lgmshreader test_gmshreader.o -o test_gmshreader

test_gmshreader.o : test_gmshreader.c
	$(CC) $(CFLAGS) test_gmshreader.c -I$(TESTINC) -I../ -o test_gmshreader.o

.PHONY: clean all


clean:
	rm -rf ./*.o
	rm -rf ./test_gmshreader
