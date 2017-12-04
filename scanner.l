%{
#include "main.h"
#include "y.tab.h"

#define LIST               strcat(buf, yytext)
#define token(t)           {LIST; if (Opt_T) printf("<%s>\n", #t);}
#define tokenChar(t)       {LIST; if (Opt_T) printf("<%c>\n", (t));}
#define tokenInteger(t, i) {LIST; if (Opt_T) printf("<%s: %d>\n", t, (i));}
#define tokenString(t, s)  {LIST; if (Opt_T) printf("<%s: %s>\n", t, (s));}
#define MAX_LINE_LENG      556

int Opt_S = 1;
int Opt_T = 1;
int Opt_D = 1;
int linenum = 1;
char buf[MAX_LINE_LENG];
char strBuf[MAX_LINE_LENG];
%}
%option noyywrap

digit [0-9]
letter [a-zA-Z]

%x STR COMMENT COMMENT_MULTILINE

%%

","     { tokenChar(yytext[0]); return COMMA;}
";"     { tokenChar(yytext[0]); return SEMICOLON;}
":"     { tokenChar(yytext[0]); return COLON;}
"("     { tokenChar(yytext[0]); return L_PAREN;}
")"     { tokenChar(yytext[0]); return R_PAREN;}
"["     { tokenChar(yytext[0]); return L_BRACKET;}
"]"     { tokenChar(yytext[0]); return R_BRACKET;}

"+"     { tokenChar('+'); return ADD;}
"-"     { tokenChar('-'); return SUB;}
"*"     { tokenChar('*'); return MUL;}
"/"     { tokenChar('/'); return DIV;}
"mod"   { token(mod); return MOD;}
":="    { token(:=); return ASSIGN;}
"<"     { tokenChar('<'); return LESS;}
"<="    { token(<=); return LESS_EQU;}
"<>"    { token(<>); return NOT_EQU;}
">="    { token(>=); return GREAT_EQU;}
">"     { tokenChar('>'); return GREAT;}
"="     { tokenChar('='); return EQU;}
"and"   { token(and); return AND;}
"or"    { token(or); return OR;}
"not"   { token(not); return NOT;}

"array"   { token(KWarray); return KW_ARRAY; }
"begin"   { token(KWbegin); return KW_BEGIN; }
"boolean" { token(KWboolean); return KW_BOOLEAN; }
"def"     { token(KWdef); return KW_DEF; }
"do"      { token(KWdo); return KW_DO; }
"else"    { token(KWelse); return KW_ELSE; }
"end"     { token(KWend); return KW_END; }
"false"   { token(KWfalse); yylval.boolValue=false; return KW_FALSE; }
"for"     { token(KWfor); return KW_FOR; }
"integer" { token(KWinteger); return KW_INTEGER; }
"if"      { token(KWif); return KW_IF; }
"of"      { token(KWof); return KW_OF; }
"print"   { token(KWprint); return KW_PRINT; }
"read"    { token(KWread); return KW_READ; }
"real"    { token(KWreal); return KW_REAL; }
"string"  { token(KWstring); return KW_STRING; }
"then"    { token(KWthen); return KW_THEN; }
"to"      { token(KWto); return KW_TO; }
"true"    { token(KWtrue); yylval.boolValue=true; return KW_TRUE; }
"return"  { token(KWreturn); return KW_RETURN; }
"var"     { token(KWvar); return KW_VAR; }
"while"   { token(KWwhile); return KW_WHILE; }

{letter}({digit}|{letter})*  { tokenString("id", yytext); yylval.stringValue=strndup(yytext,32); return IDENT; }

0[0-7]+ { tokenString("oct_integer", yytext); sscanf(yytext, "%o", &yylval.intValue); return OCT_INTEGER; }
((0)|([1-9]{digit}*)) { tokenString("integer", yytext); yylval.intValue=atoi(yytext); return INTEGER; }

{digit}+\.{digit}+ { tokenString("float", yytext); yylval.doubleValue=atof(yytext); return FLOAT; }

({digit}+(\.{digit}+)?)[Ee][+-]?({digit}+) { tokenString("scientific", yytext); yylval.doubleValue=atof(yytext); return SCIENTIFIC;}

"\"" { LIST; BEGIN STR; }

"//&"[A-Z][+-]  {
                  LIST;
                  switch (yytext[3]) {
                  case 'S':
                    Opt_S = (yytext[4] == '+');
                    break;
                  case 'T':
                    Opt_T = (yytext[4] == '+');
                    break;
                  case 'D':
                    Opt_D = (yytext[4] == '+');
                    break;
                  }
                  BEGIN COMMENT;
                }
"//"  { LIST; BEGIN COMMENT;}
"/*"  { LIST; BEGIN COMMENT_MULTILINE;}

\n    {
        if (Opt_S)
          printf("%d: %s\n", linenum, buf);
        linenum++;
        buf[0] = '\0';
      }

[ \t]   { LIST; }

.     {
        LIST;
        printf("error at line %d: bad character \"%s\"\n",linenum,yytext);
        exit(-1);
      }

<STR>"\"" { 
            tokenString("string", strBuf);
            yylval.stringValue=strdup(strBuf);
            memset(strBuf, 0, MAX_LINE_LENG); 
            BEGIN INITIAL;
            return STRING;
          }
<STR>"\"\""  { LIST; strcat(strBuf, "\""); }
<STR>.  { LIST; strcat(strBuf, yytext); }
<STR>\n   { 
            if (Opt_S)
                printf("%d: %s\n", linenum, buf);
            printf("error at line %d: bad NEW_LINE character\n",linenum); 
            exit(-1);
          }


<COMMENT>.  { LIST; }
<COMMENT>\n {
              if (Opt_S)
                  printf("%d: %s\n", linenum, buf);
              linenum++;
              buf[0] = '\0';
              BEGIN INITIAL;
            }


<COMMENT_MULTILINE>.    { LIST; }
<COMMENT_MULTILINE>\n   {
                          if (Opt_S)
                              printf("%d: %s\n", linenum, buf);
                          linenum++;
                          buf[0] = '\0';
                        }
<COMMENT_MULTILINE>"*/" { LIST; BEGIN INITIAL; }
<COMMENT_MULTILINE><<EOF>>  {
                              printf("error at line %d: no ending for multi-line comment.\n",linenum); 
                              exit(-1);
                            }


%%


