 yacc -d -v yacctemplate.y
 lex lextemplate.l
 gcc y.tab.c lex.yy.c -ly -ll -o parser
 rm y.tab.*
 rm y.output
 rm lex.yy.c
 ./parser TestCase/Project2/test.p > ans.log
 diff ans.log TestCase/Project2/ExAns/rtest.p
 rm ans.log
