all: lex.yy.c 
	gcc -o scanner lex.yy.c -lfl

lex.yy.c: lextemplate.l
	lex lextemplate.l