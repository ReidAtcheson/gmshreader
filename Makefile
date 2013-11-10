CC = clang
CFLAGS = -c -Wall -O3
LDFLAGS = -ll

PARSER = bison -d
LEXER = flex

GEN_FILES = gmsh.tab.c gmsh.tab.h lex.yy.c gmshlex.o gmsh.tab.o

libgmeshreader.a : gmsh.tab.c gmsh.tab.h lex.yy.c
	$(CC) $(CFLAGS) gmsh.tab.c -o gmsh.tab.o
	$(CC) $(CFLAGS) lex.yy.c -o gmshlex.o 
	ar rcs libgmshreader.a gmsh.tab.o gmshlex.o

gmsh.tab.c gmsh.tab.h: gmsh.y
	$(PARSER) gmsh.y

lex.yy.c: gmsh.l
	$(LEXER) gmsh.l	


.PHONY: clean

clean:
	rm -rf $(GEN_FILES)
