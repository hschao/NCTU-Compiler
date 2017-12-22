%{
#include "main.h"
using namespace std;

extern int linenum;             /* declared in lex.l */
extern FILE *yyin;              /* declared by lex */
extern char *yytext;            /* declared by lex */
extern char buf[256];           /* declared in lex.l */
extern int Opt_D;           /* declared in lex.l */

string fileName;
bool ignoreNextCompound = false;
bool isParsingProgram = false;

int yylex();
int yyerror( const char *msg );
void semanticError( string msg );
%}

%token COMMA SEMICOLON COLON L_PAREN R_PAREN L_BRACKET R_BRACKET
%token ADD SUB MUL DIV MOD ASSIGN LESS LESS_EQU NOT_EQU GREAT_EQU GREAT EQU AND OR NOT
%token KW_ARRAY KW_BEGIN KW_BOOLEAN KW_DEF KW_DO KW_ELSE KW_END KW_FOR KW_INTEGER KW_IF KW_OF KW_PRINT KW_READ KW_REAL KW_STRING KW_THEN KW_TO KW_RETURN KW_VAR KW_WHILE
%token <stringValue> IDENT STRING
%token <intValue> OCT_INTEGER INTEGER
%token <doubleValue> FLOAT SCIENTIFIC 
%token <boolValue>  KW_TRUE KW_FALSE

%type <variant> literal_constant
%type <intValue> integer_constant reference_list
%type <ids> identifier_list
%type <typeID> scalar_type
%type <type> type function_return_type expression operand
%type <type> function_invocation
%type <args> arguments argument_list argument 
%type <entry> variable_reference
%type <params> expressions expression_list

%left OR
%left AND
%left NOT
%left GREAT GREAT_EQU EQU LESS_EQU LESS NOT_EQU
%left ADD SUB
%left MUL DIV MOD
%%

/* program */
program 
 : IDENT SEMICOLON { 
    if (fileName != $1)
        semanticError("program beginning ID inconsist with file name");

    push_SymbolTable(true);
    symTable.back().addProgram($1);
   } programbody KW_END IDENT { 
    pop_SymbolTable(Opt_D);

    if (strcmp($1, $6) != 0)
        semanticError("program end ID inconsist with the beginning ID");
    if (fileName != $6)
        semanticError("program end ID inconsist with file name");
   }
 ;

programbody
 : var_constant_declarations function_declarations { isParsingProgram=true; } compound_statement
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
 : IDENT L_PAREN arguments R_PAREN function_return_type SEMICOLON 
    { 
        // Create new symbol table.
        push_SymbolTable(true); 
        ignoreNextCompound=true; 
        symTable.back().addParameters($3);
        symTable[symTable.size()-2].addFunction($1, $3, $5);
        
        if ($5.dimensions.size() != 0)
            semanticError("a function cannot return an array type");
    }    
    compound_statement 
   KW_END IDENT {
    if (strcmp($1, $10) != 0)
        semanticError("the end of the functionName mismatch");

    if ($5.dimensions.size() != 0)
        for(int i=0; i<symTable[0].entries.size(); i++)
            if (strcmp(symTable[0].entries[i].name, $1) == 0) {
                symTable[0].entries.erase(symTable[0].entries.begin()+i);
                break;
            }
   }
 ; 

function_return_type
 : COLON type { $$ = $2; }
 | empty { $$.typeID = T_NONE; }
 ;

arguments
 : empty { $$.clear(); }
 | argument_list { 
    $$ = $1;
   }
 ;

argument_list
 : argument_list SEMICOLON argument { $$=$1; $$.insert( $$.end(), $3.begin(), $3.end() ); }
 | argument { $$=$1; }
 ;

argument
 : identifier_list COLON type { 
    for(int i=0; i<$1.size(); i++) {
      Arg arg;
      arg.name = $1[i];
      arg.t = $3;
      $$.push_back(arg); 
    }
   }
 ;



variable_declaration
 : KW_VAR identifier_list COLON type SEMICOLON {
       symTable.back().addVariables($2, $4);
   }
 ;

constant_declaration
 : KW_VAR identifier_list COLON literal_constant SEMICOLON {
        symTable.back().addConstants($2, $4);
   }
 ;

literal_constant
 : STRING { $$.typeID = T_STRING; $$.str=$1; }
 | integer_constant { $$.typeID = T_INTEGER; $$.integer=$1; }
 | SCIENTIFIC { $$.typeID = T_REAL; $$.real=$1; }
 | FLOAT { $$.typeID = T_REAL; $$.real=$1; }
 | SUB integer_constant { $$.typeID = T_INTEGER; $$.integer=-$2; }
 | SUB SCIENTIFIC { $$.typeID = T_REAL; $$.real=-$2; }
 | SUB FLOAT { $$.typeID = T_REAL; $$.real=-$2; }
 | KW_TRUE { $$.typeID = T_BOOLEAN; $$.bl=$1; }
 | KW_FALSE { $$.typeID = T_BOOLEAN; $$.bl=$1; }
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
     { if(!ignoreNextCompound) { push_SymbolTable(true); } ignoreNextCompound=false; }    
     var_constant_declarations
     statements
     { pop_SymbolTable(Opt_D); }
   KW_END
 ;

simple_statement
 : variable_reference ASSIGN expression SEMICOLON {
    char buf[300];
    if ($1.kind == K_PROG) {
        sprintf(buf, "'%s' is program", $1.name);
        semanticError(buf);
    } else if ($1.kind == K_FUNC) {
        sprintf(buf, "'%s' is function", $1.name);
        semanticError(buf);
    } else if ($1.kind == K_PARAM || $1.kind == K_VAR) {
        if ($1.type.typeID != T_ERROR) {
            if ($3.typeID == T_ERROR)
                semanticError("error type in RHS of assignment");
            if ($3.typeID != T_ERROR || $1.type.dimensions.size() > 0) {
                if ($1.type.acceptable($3) != E_OK) {
                    sprintf(buf, "type mismatch, LHS= %s, RHS= %s", $1.type.toString().c_str(), $3.toString().c_str());
                    semanticError(buf);
                } else if ( $1.type.dimensions.size() > 0 ) 
                    semanticError("array assignment is not allowed");
            }
        }    
    } else if ($1.kind == K_CONST) {
        sprintf(buf, "constant '%s' cannot be assigned", $1.name);
        semanticError(buf);
    } else if ($1.kind == K_LOOP_VAR) {
        sprintf(buf, "loop variable '%s' cannot be assigned", $1.name);
        semanticError(buf);
    } 
   }
 | KW_PRINT variable_reference SEMICOLON {
    if ($2.kind == K_PROG) {
        sprintf(buf, "'%s' is program", $2.name);
        semanticError(buf);
    } else if ($2.kind == K_FUNC) {
        sprintf(buf, "'%s' is function", $2.name);
        semanticError(buf);
    }  else if ($2.kind == K_PARAM || $2.kind == K_VAR) {
        if ($2.type.dimensions.size() > 0)
            semanticError("operand of print statement is array type");
    } 
   }
 | KW_PRINT expression SEMICOLON
 | KW_READ variable_reference SEMICOLON {
    if ($2.kind == K_PROG) {
        sprintf(buf, "'%s' is program", $2.name);
        semanticError(buf);
    } else if ($2.kind == K_FUNC) {
        sprintf(buf, "'%s' is function", $2.name);
        semanticError(buf);
    }  else if ($2.kind == K_PARAM || $2.kind == K_VAR) {
        if ($2.type.dimensions.size() > 0)
            semanticError("operand of print statement is array type");
    } 
   }
 ;

conditional_statement 
 : KW_IF boolean_expr KW_THEN statements KW_ELSE statements KW_END KW_IF
 | KW_IF boolean_expr KW_THEN statements KW_END KW_IF
 ;

while_statement 
 : KW_WHILE boolean_expr KW_DO statements KW_END KW_DO
 ;

for_statement 
 : KW_FOR IDENT ASSIGN integer_constant KW_TO integer_constant KW_DO 
    { 
        // Create invisible symbol table.
        push_SymbolTable(false); 

        // Check loop variable redeclare.
        if(checkLoopVarRedeclare($2)) {
            SymbolTableEntry ste;
            strcpy(ste.name, $2);
            ste.kind = K_LOOP_VAR;
            ste.type.typeID = T_INTEGER;
            ste.type.dimensions.clear();
            symTable.back().entries.push_back(ste);
        }
    }
    statements 
    { pop_SymbolTable(false); }
   KW_END KW_DO
 ;

return_statement 
 : KW_RETURN expression SEMICOLON {
    if (isParsingProgram)
        semanticError("program cannot be returned");
    else {
        SymbolTableEntry p = getLastFunc();
        if (p.type.acceptable($2) == E_TYPE_MISMATCH)
            semanticError("return type mismatch");
        else if (p.type.acceptable($2) == E_DIM_MISMATCH)
            semanticError("return dimension number mismatch");
    }
   }
 ;

function_invocation_statement
 : function_invocation SEMICOLON
 ;


/* common grammar */
expressions
 : empty { $$.clear(); }
 | expression_list { 
    $$ = $1;
   }
 ;

expression_list
 : expression_list COMMA expression { $$=$1; $$.push_back( $3 ); }
 | expression { 
    $$.clear();
    $$.push_back($1); 
   }
 ;

expression
 : operand { $$ = $1; }
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
 : variable_reference { 

    $$ = $1.type;
    if ($1.kind == K_PROG) {
        $$.typeID = T_ERROR;
        sprintf(buf, "'%s' is program", $1.name);
        semanticError(buf);
    } else if ($1.kind == K_FUNC) {
        $$.typeID = T_ERROR;
        sprintf(buf, "'%s' is function", $1.name);
        semanticError(buf);
    } 
   }
 | literal_constant { $$.typeID = $1.typeID; }
 | function_invocation { $$ = $1; }
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
 : IDENT L_PAREN expressions R_PAREN { 
    $$.typeID = T_ERROR;
    SymbolTableEntry p = findFunction($1);
    if (p.type.typeID != T_ERROR){
        char buf[300];
        if ($3.size() < p.attr.paramLst.size()) {
            sprintf(buf, "too few arguments to function '%s'", $1);
            semanticError(buf);
        } else if ($3.size() > p.attr.paramLst.size()) {
            sprintf(buf, "too many arguments to function '%s'", $1);
            semanticError(buf);
        } else {
            bool allMatch = true;
            for (int i=0; i<$3.size(); i++)
                if ($3[i].typeID != p.attr.paramLst[i].typeID || $3[i].dimensions != p.attr.paramLst[i].dimensions) {
                    allMatch = false;
                    semanticError("parameter type mismatch");
                    break;
                }

            if (allMatch)
                $$ = p.type;
        }
    }
   }
 ;

variable_reference
 : IDENT reference_list {
    $$.kind = K_VAR;
    $$.type.typeID = T_ERROR;
    SymbolTableEntry p = findSymbol($1);
    if (p.type.typeID!=T_ERROR) {
        char buf[300];

        $$ = p;
        if (p.kind == K_PARAM || p.kind == K_VAR || p.kind == K_CONST || p.kind == K_LOOP_VAR) {
            int dim = p.type.dimensions.size();
            if ($2 > dim) {
                sprintf(buf, "'%s' is %d dimension(s), but reference in %d dimension(s)", $1, dim, $2);
                semanticError(buf);
                $$.type.typeID = T_ERROR;
            } else {
                if ($2 > 0)
                    $$.type.dimensions.erase($$.type.dimensions.begin(), $$.type.dimensions.begin() + $2);
            }
        }
    }
   }
 ;

reference_list
 : reference_list L_BRACKET integer_expr R_BRACKET { $$ = $1 + 1;}
 | empty { $$ = 0; }
 ;

type
 : scalar_type {
     $$.typeID = $1;
   }
 | KW_ARRAY integer_constant KW_TO integer_constant KW_OF type {
     $$.typeID = $6.typeID;
     $$.dimensions = $6.dimensions;
     $$.dimensions.insert($$.dimensions.begin(),$4-$2+1);
   }
 ;

integer_constant
 : INTEGER { $$=$1; }
 | OCT_INTEGER { $$=$1; }
 ;

scalar_type
 : KW_INTEGER { $$=T_INTEGER; }
 | KW_REAL { $$=T_REAL; }
 | KW_STRING { $$=T_STRING; }
 | KW_BOOLEAN { $$=T_BOOLEAN; }
 ;

identifier_list
 : identifier_list COMMA IDENT { $$=$1; $$.push_back($3); }
 | IDENT { $$.push_back($1); }

empty
 :
 ;

%%

int yyerror( const char *msg )
{
    fprintf( stderr, "\n|--------------------------------------------------------------------------\n" );
    fprintf( stderr, "| Error found in Line #%d: %s\n", linenum, buf );
    fprintf( stderr, "|\n" );
    fprintf( stderr, "| Unmatched token: %s\n", yytext );
    fprintf( stderr, "|--------------------------------------------------------------------------\n" );
    exit(-1);
}

bool noError = true;
void semanticError( string msg )
{
    printf("<Error> found in Line %d: %s\n", linenum, msg.c_str() );
    noError = false;
}

string getFileName(string s) {

    char sep = '/';
#ifdef _WIN32
    sep = '\\';
#endif

    size_t i = s.rfind(sep, s.length());
    if (i != string::npos)
        s = s.substr(i+1);
    i = s.rfind('.', s.length());
    if (i != string::npos)
        s = s.substr(0,i);
    return s;
}

int  main( int argc, char **argv )
{
    if( argc != 2 ) {
        fprintf(  stdout,  "Usage:  ./parser  [filename]\n"  );
        exit(0);
    }

    FILE *fp = fopen( argv[1], "r" );
    fileName = getFileName(argv[1]);
    if( fp == NULL )  {
        fprintf( stdout, "Open  file  error\n" );
        exit(-1);
    }
    
    symTable.clear();

    yyin = fp;
    yyparse();
    if (noError) {
        printf("|-------------------------------------------|\n");
        printf("| There is no syntactic and semantic error! |\n");
        printf("|-------------------------------------------|\n");
    }
    exit(0);
}

