all: parser

y.tab.c: parser.y
	yacc -d -v parser.y

lex.yy.c: scanner.l
	lex scanner.l

y.tab.h: parser.y
	yacc -d -v parser.y

parser: lex.yy.c y.tab.c y.tab.h
	gcc y.tab.c lex.yy.c -o parser.out -ly -lfl