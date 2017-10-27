%{
#define LIST               strcat(buf, yytext)
#define token(t)           {LIST; if (Opt_T) printf("<%s>\n", #t);}
#define tokenChar(t)       {LIST; if (Opt_T) printf("<%c>\n", (t));}
#define tokenInteger(t, i) {LIST; if (Opt_T) printf("<%s: %d>\n", #t, (i));}
#define tokenString(t, s)  {LIST; if (Opt_T) printf("<%s: %s>\n", #t, (s));}
#define MAX_LINE_LENG      556

int Opt_S = 1;
int Opt_T = 1;
int linenum = 1;
char buf[MAX_LINE_LENG];
char strBuf[MAX_LINE_LENG];
%}

digit [0-9]
letter [a-zA-Z]

%x STR COMMENT COMMENT_MULTILINE

%%

","     { tokenChar(yytext[0]); }
";"     { tokenChar(yytext[0]); }
":"     { tokenChar(yytext[0]); }
"("     { tokenChar(yytext[0]); }
")"     { tokenChar(yytext[0]); }
"["     { tokenChar(yytext[0]); }
"]"     { tokenChar(yytext[0]); }

"+"     { tokenChar('+'); }
"-"     { tokenChar('-'); }
"*"     { tokenChar('*'); }
"/"     { tokenChar('/'); }
"mod"   { token(mod); }
":="    { token(:=); }
"<"     { tokenChar('<'); }
"<="    { token(<=); }
"<>"    { token(<>); }
">="    { token(>=); }
">"     { tokenChar('>'); }
"="     { tokenChar('='); }
"and"   { token(and); }
"or"    { token(or); }
"not"   { token(not); }

"array"   { token(KWarray); }
"begin"   { token(KWbegin); }
"boolean" { token(KWboolean); }
"def"     { token(KWdef); }
"do"      { token(KWdo); }
"else"    { token(KWelse); }
"end"     { token(KWend); }
"false"   { token(KWfalse); }
"for"     { token(KWfor); }
"integer" { token(KWinteger); }
"if"      { token(KWif); }
"of"      { token(KWof); }
"print"   { token(KWprint); }
"read"    { token(KWread); }
"real"    { token(KWreal); }
"string"  { token(KWstring); }
"then"    { token(KWthen); }
"to"      { token(KWto); }
"true"    { token(KWtrue); }
"return"  { token(KWreturn); }
"var"     { token(KWvar); }
"while"   { token(KWwhile); }

{letter}({digit}|{letter})*  { tokenString("id", yytext); }

0[0-7]+ { tokenString("oct_integer", yytext); }
((0)|([1-9]{digit}*)) { tokenString("integer", yytext); }

{digit}+\.{digit}+ { tokenString("float", yytext); }

({digit}+(\.{digit}+)?)[Ee][+-]?({digit}+) { tokenString("scientific", yytext); }

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
            memset(strBuf, 0, MAX_LINE_LENG); 
            BEGIN INITIAL;
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


int main( int argc, char **argv )
{
  if( argc != 2 ) {
    fprintf( stderr, "Usage: ./scanner [filename]\n" );
    exit(0);
  }
	
  FILE *fp = fopen( argv[1], "r" );
  if( fp == NULL ) {
    fprintf( stderr, "Open file error\n" );
    exit(-1);
  }
	
  yyin = fp;

  yylex();

  exit(0);
}
