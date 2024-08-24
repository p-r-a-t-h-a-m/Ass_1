# Default target
all: P7

# Rule to generate Bison output files
P.tab.c P.tab.h: P.y
	bison -d P.y

# Rule to generate Flex output file
lex.yy.c: P7.l P.tab.h
	flex P7.l

# Rule to compile everything into the executable 'P7'
P7: lex.yy.c P.tab.c
	gcc -o P7 lex.yy.c P.tab.c -lfl

# Clean up build artifacts
clean:
	rm -f P.tab.* lex.yy.c P7 *.o
