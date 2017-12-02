UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
	GCC_EXTRA_PARAM := -lfl
else ifeq ($(UNAME), Darwin)
	GCC_EXTRA_PARAM := -ll
endif

all: parser

y.tab.c: parser.y
	yacc -d -v parser.y

lex.yy.c: scanner.l
	lex scanner.l

y.tab.h: parser.y
	yacc -d -v parser.y

parser: lex.yy.c y.tab.c y.tab.h
	gcc y.tab.c lex.yy.c -o parser.out -ly $(GCC_EXTRA_PARAM)