%{
#include <stdio.h>
#include <stdlib.h>

extern int linenum;             /* declared in lex.l */
extern FILE *yyin;              /* declared by lex */
extern char *yytext;            /* declared by lex */
extern char buf[256];           /* declared in lex.l */

int yylex();
int yyerror( char *msg );
%}

%token COMMA SEMICOLON COLON L_PAREN R_PAREN L_BRACKET R_BRACKET
%token ADD SUB MUL DIV MOD ASSIGN LESS LESS_EQU NOT_EQU GREAT_EQU GREAT EQU AND OR NOT
%token KW_ARRAY KW_BEGIN KW_BOOLEAN KW_DEF KW_DO KW_ELSE KW_END KW_FALSE KW_FOR KW_INTEGER KW_IF KW_OF KW_PRINT KW_READ KW_REAL KW_STRING KW_THEN KW_TO KW_TRUE KW_RETURN KW_VAR KW_WHILE
%token IDENT OCT_INTEGER INTEGER FLOAT SCIENTIFIC STRING


%left OR
%left AND
%left NOT
%left GREAT GREAT_EQU EQU LESS_EQU LESS NOT_EQU
%left ADD SUB
%left MUL DIV MOD
%%

/* program */
program 
 : IDENT SEMICOLON programbody KW_END IDENT
 ;

programbody
 : var_constant_declarations function_declarations compound_statement
 ;

var_constant_declarations
 : empty
 | var_constant_declarations variable_declaration
 | var_constant_declarations constant_declaration
 ;

function_declarations
 : empty
 | function_declarations function_declaration
 ;



/* function */
function_declaration
 : IDENT L_PAREN arguments R_PAREN COLON type SEMICOLON compound_statement KW_END IDENT
 | IDENT L_PAREN arguments R_PAREN SEMICOLON compound_statement KW_END IDENT
 ; 

arguments
 : empty
 | argument_list
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
 : STRING
 | integer_constant
 | SCIENTIFIC
 | FLOAT
 | SUB integer_constant
 | SUB SCIENTIFIC
 | SUB FLOAT
 | KW_TRUE | KW_FALSE
 ;

/* statements */
statements
 : empty
 | statement_list
 ;

statement_list
 : statement_list statement
 | statement
 ;

statement
 : compound_statement
 | simple_statement
 | conditional_statement
 | while_statement
 | for_statement
 | return_statement
 | function_invocation_statement
 ;

compound_statement
 : KW_BEGIN
     var_constant_declarations
     statements
   KW_END
 ;

simple_statement
 : variable_reference ASSIGN expression SEMICOLON
 | KW_PRINT variable_reference SEMICOLON
 | KW_PRINT expression SEMICOLON
 | KW_READ variable_reference SEMICOLON
 ;

conditional_statement 
 : KW_IF boolean_expr KW_THEN statements KW_ELSE statements KW_END KW_IF
 | KW_IF boolean_expr KW_THEN statements KW_END KW_IF
 ;

while_statement 
 : KW_WHILE boolean_expr KW_DO statements KW_END KW_DO
 ;

for_statement 
 : KW_FOR IDENT ASSIGN integer_constant KW_TO integer_constant KW_DO statements KW_END KW_DO
 ;

return_statement 
 : KW_RETURN expression SEMICOLON
 ;

function_invocation_statement
 : function_invocation SEMICOLON
 ;


/* common grammar */
expressions
 : empty
 | expression_list
 ;

expression_list
 : expression_list COMMA expression
 | expression
 ;

expression
 : operand
 | expression operator_arithmetic expression
 | expression operator_compare expression
 | expression operator_logical expression
 | NOT expression
 | L_PAREN expression R_PAREN
 ;

boolean_expr
 : expression
 ;

integer_expr
 : expression
 ;

operand 
 : variable_reference
 | literal_constant
 | function_invocation
 ;

operator_logical
 : OR | AND
 ;

operator_compare
 : GREAT | GREAT_EQU | EQU | LESS_EQU | LESS | NOT_EQU
 ;

operator_arithmetic
 : ADD | SUB | MUL | DIV | MOD
 ;

function_invocation
 : IDENT L_PAREN expressions R_PAREN
 ;

variable_reference
 : IDENT reference_list
 ;

reference_list
 : reference_list L_BRACKET integer_expr R_BRACKET
 | empty
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

