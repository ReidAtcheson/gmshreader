CC = clang
CFLAGS = -c -Wall -g -DDEBUG
LDFLAGS = -ll

PARSER = bison -d
LEXER = flex

GEN_FILES = gmsh.tab.c gmsh.tab.h lex.yy.c gmshlex.o gmsh.tab.o gmshreader.o libgmshreader.a

libgmeshreader.a : gmshreader.o gmsh.tab.o gmshlex.o 
	ar rcs libgmshreader.a gmsh.tab.o gmshlex.o gmshreader.o

gmshreader.o: gmshreader.c
	$(CC) $(CFLAGS) gmshreader.c -o gmshreader.o

gmsh.tab.o: gmsh.tab.c gmsh.tab.h
	$(CC) $(CFLAGS) gmsh.tab.c -o gmsh.tab.o

gmshlex.o: lex.yy.c
	$(CC) $(CFLAGS) lex.yy.c -o gmshlex.o



gmsh.tab.c gmsh.tab.h: gmsh.y
	$(PARSER) gmsh.y

lex.yy.c: gmsh.l
	$(LEXER) gmsh.l	


.PHONY: clean

clean:
	rm -rf $(GEN_FILES)
