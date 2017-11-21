%{
#include <stdio.h>
#include <stdlib.h>

extern int linenum;             /* declared in lex.l */
extern FILE *yyin;              /* declared by lex */
extern char *yytext;            /* declared by lex */
extern char buf[256];           /* declared in lex.l */
%}

%token COMMA SEMICOLON COLON L_PAREN R_PAREN L_BRACKET R_BRACKET
%token ADD SUB MUL DIV MOD ASSIGN LESS LESS_EQU NOT_EQU GREAT_EQU GREAT EQU AND OR NOT
%token KW_ARRAY KW_BEGIN KW_BOOLEAN KW_DEF KW_DO KW_ELSE KW_END KW_FALSE KW_FOR KW_INTEGER KW_IF KW_OF KW_PRINT KW_READ KW_REAL KW_STRING KW_THEN KW_TO KW_TRUE KW_RETURN KW_VAR KW_WHILE
%token IDENT OCT_INTEGER INTEGER FLOAT SCIENTIFIC STRING

%%

program 
 : IDENT SEMICOLON programbody KW_END IDENT
 ;

programbody
 : var_constant_declarations function_declarations compound_statement
 ;



function
 : IDENT L_PAREN arguments R_PAREN COLON type SEMICOLON compound_statement KW_END IDENT
 ; 

arguments
 : empty
 | arg_list
 ;

argument_list
 : argument_list SEMICOLON argument
 | argument
 ;

argument
 : identifier_list COLON type
 ;



variable_declaration
 : KW_VAR identifier_list COLON type SEMICOLON
 ;

constant_declaration
 : KW_VAR identifier_list COLON literal_constant SEMICOLON
 ;

literal_constant
 : integer_constant
 | STRING
 | SCIENTIFIC
 | FLOAT
 | KW_TRUE | KW_FALSE
 ;



compound_statement
 : KW_BEGIN
     var_constant_declarations
     zero_more_statements
   KW_END
 ;

simple_statement
 : variable_reference ASSIGN expression SEMICOLON
 | KW_PRINT variable_reference
 | KW_PRINT expression
 | KW_READ variable_reference
 ;



type
 : scalar_type
 | KW_ARRAY integer_constant KW_TO integer_constant KW_OF type
 ;

integer_constant
 : INTEGER
 | OCT_INTEGER
 ;

scalar_type
 : KW_INTEGER
 | KW_REAL
 | KW_STRING
 | KW_BOOLEAN
 ;

identifier_list
 : identifier_list COMMA IDENT
 | IDENT

empty
 :
 ;

%%

int yyerror( char *msg )
{
    fprintf( stderr, "\n|--------------------------------------------------------------------------\n" );
    fprintf( stderr, "| Error found in Line #%d: %s\n", linenum, buf );
    fprintf( stderr, "|\n" );
    fprintf( stderr, "| Unmatched token: %s\n", yytext );
    fprintf( stderr, "|--------------------------------------------------------------------------\n" );
    exit(-1);
}

int  main( int argc, char **argv )
{
    if( argc != 2 ) {
        fprintf(  stdout,  "Usage:  ./parser  [filename]\n"  );
        exit(0);
    }

    FILE *fp = fopen( argv[1], "r" );
    
    if( fp == NULL )  {
        fprintf( stdout, "Open  file  error\n" );
        exit(-1);
    }
    
    yyin = fp;
    yyparse();

    fprintf( stdout, "\n" );
    fprintf( stdout, "|--------------------------------|\n" );
    fprintf( stdout, "|  There is no syntactic error!  |\n" );
    fprintf( stdout, "|--------------------------------|\n" );
    exit(0);
}

