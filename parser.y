%{
#include "main.h"
#include "genCode.h"
#include "semCheck.h"
using namespace std;

extern int linenum;             /* declared in lex.l */
extern FILE *yyin;              /* declared by lex */
extern char *yytext;            /* declared by lex */
extern char buf[256];           /* declared in lex.l */
extern int Opt_D;           /* declared in lex.l */

string fileName;
bool ignoreNextCompound = false;
bool isParsingProgram = false;
SymbolTableEntry func_invoke;
int func_param_counter = 0;

int yylex();
int yyerror( const char *msg );
void semanticError( string msg );

%}

%token COMMA SEMICOLON COLON L_PAREN R_PAREN L_BRACKET R_BRACKET
%token ASSIGN
%token KW_ARRAY KW_BEGIN KW_BOOLEAN KW_DEF KW_DO KW_ELSE KW_END KW_FOR KW_INTEGER KW_IF KW_OF KW_PRINT KW_READ KW_REAL KW_STRING KW_THEN KW_TO KW_RETURN KW_VAR KW_WHILE
%token <stringValue> IDENT STRING
%token <stringValue> ADD SUB MUL DIV MOD LESS LESS_EQU NOT_EQU GREAT_EQU GREAT EQU AND OR NOT
%token <intValue> OCT_INTEGER INTEGER
%token <doubleValue> FLOAT SCIENTIFIC 
%token <boolValue>  KW_TRUE KW_FALSE

%type <variant> literal_constant
%type <intValue> integer_constant reference_list
%type <ids> identifier_list
%type <typeID> scalar_type
%type <type> type function_return_type condition
%type <type> function_invocation
%type <type> expression boolean_expr boolean_term boolean_factor relop_expr term factor
%type <args> arguments argument_list argument 
%type <entry> variable_reference
%type <params> expressions expression_list
%type <stringValue> rel_op add_op mul_op

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

    // Generate initialization java bytecode
    genProgBegin();

   } programbody KW_END IDENT { 
    pop_SymbolTable(Opt_D);

    if (strcmp($1, $6) != 0)
        semanticError("program end ID inconsist with the beginning ID");
    if (fileName != $6)
        semanticError("program end ID inconsist with file name");
   }
 ;

programbody
 : var_constant_declarations function_declarations 
    { 
        isParsingProgram=true; 
        symTable.back().resetVarNumber(1);

        // Generate initialization java bytecode
        genMainBegin();
    } 
   compound_statement 
    {
        genMainEnd();
    }
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
        // Initialize available number counter.
        symTable.back().resetVarNumber(0);

        // Create new symbol table.
        push_SymbolTable(true); 
        ignoreNextCompound=true; 
        symTable.back().addParameters($3);
        symTable[symTable.size()-2].addFunction($1, $3, $5);
        
        if ($5.typeID == T_ERROR || ($5.typeID != T_NONE && $5.dimensions.size() != 0))
            semanticError("a function cannot return an array type");
        else {
            genFuncBegin(symTable[symTable.size()-2].entries.back());
        }
    }    
   compound_statement 
   KW_END IDENT
    {
        if (strcmp($1, $10) != 0)
            semanticError("the end of the functionName mismatch");

        genFuncEnd($5);

        if ($5.typeID == T_ERROR || ($5.typeID != T_NONE && $5.dimensions.size() != 0))
            for(int i=0; i<symTable[0].entries.size(); i++)
                if (strcmp(symTable[0].entries[i].name, $1) == 0) {
                    symTable[0].entries.erase(symTable[0].entries.begin()+i);
                    break;
                }
    }
 ; 

function_return_type
 : COLON type { $$ = $2; }
 | empty { $$.typeID = T_NONE; $$.dimensions.clear(); }
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
    if ($3.typeID == T_ERROR) {
        string msg = "wrong dimension declaration for array " + $1[0];
        for (int i=1; i<$1.size(); ++i)
            msg += ", " + $1[i];
        semanticError(msg);
    } else {
        for(int i=0; i<$1.size(); i++) {
          Arg arg;
          arg.name = $1[i];
          arg.t = $3;
          $$.push_back(arg); 
        }
    }
   }
 ;



variable_declaration
 : KW_VAR identifier_list COLON type SEMICOLON {
    if ($4.typeID == T_ERROR) {
        string msg = "wrong dimension declaration for array " + $2[0];
        for (int i=1; i<$2.size(); ++i)
            msg += ", " + $2[i];
        semanticError(msg);
    }
    else {
        symTable.back().addVariables($2, $4);
        // printf("%d\n", symTable.back().level);

        if ($4.dimensions.size() == 0 && $4.typeID != T_STRING && $4.typeID != T_NONE) {
            // Array and String type code generation are not implemented.
            if (symTable.back().level == 0) {
                // Generate global variables java bytecode
                for (int i=0; i<$2.size(); i++) {
                    genCode(0, ".field public static %s %c ", $2[i].c_str(), typeCode[$4.typeID]);
                }
            } else {

            }  
        }
    }
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
 : variable_reference ASSIGN boolean_expr SEMICOLON {
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

            // Generate bytecode for store
            if ($1.type.typeID == T_REAL && $3.typeID == T_INTEGER)
                genI2F(); 
            genStoreVar($1);
        }    
    } else if ($1.kind == K_CONST) {
        sprintf(buf, "constant '%s' cannot be assigned", $1.name);
        semanticError(buf);
    } else if ($1.kind == K_LOOP_VAR) {
        sprintf(buf, "loop variable '%s' cannot be assigned", $1.name);
        semanticError(buf);
    } 
   }
 | KW_PRINT { genCode(1, "getstatic java/lang/System/out Ljava/io/PrintStream; "); }
   boolean_expr SEMICOLON {
    if ($3.dimensions.size() > 0)
        semanticError("operand of print statement is array type");
    else
        genPrint($3.typeID);
   }
 | KW_READ variable_reference SEMICOLON {
    if ($2.kind == K_PROG) {
        sprintf(buf, "'%s' is program", $2.name);
        semanticError(buf);
    } else if ($2.kind == K_FUNC) {
        sprintf(buf, "'%s' is function", $2.name);
        semanticError(buf);
    }  else if ($2.kind == K_PARAM || $2.kind == K_VAR) {
        if ($2.type.dimensions.size() > 0)
            semanticError("operand of read statement is array type");
        genRead($2);
    }
   }
 ;

conditional_statement 
 : KW_IF condition KW_THEN statements 
    {
        genCode(1, "goto Lexit_%d ", labelStack.back());
        genCode(0, "Lelse_%d: ", labelStack.back());        
    }
   KW_ELSE statements 
    {
        genCode(0, "Lexit_%d: ", labelStack.back());
        labelStack.pop_back();
    }
   KW_END KW_IF
 | KW_IF condition KW_THEN statements 
    {
        genCode(0, "Lelse_%d: ", labelStack.back());   
    }
   KW_END KW_IF 
    {
        labelStack.pop_back();
    }
 ;

condition
 : boolean_expr 
    {
        if ($1.typeID != T_BOOLEAN)
            semanticError("operand of if statement is not boolean type");
        labelStack.push_back(nextLabelNo++);
        genCode(1, "ifeq Lelse_%d ", labelStack.back());
    } 
 ;

while_statement 
 : KW_WHILE 
    {
        labelStack.push_back(nextLabelNo++);
        genCode(0, "Lbegin_%d: ", labelStack.back());
    }
   boolean_expr 
    {
        if ($3.typeID != T_BOOLEAN)
            semanticError("operand of while statement is not boolean type");
        genCode(1, "ifeq Lexit_%d ", labelStack.back());
    } 
   KW_DO statements KW_END KW_DO
    {
        genCode(1, "goto Lbegin_%d ", labelStack.back());
        genCode(0, "Lexit_%d: ", labelStack.back());
        labelStack.pop_back();
    }
 ;

for_statement 
 : KW_FOR IDENT ASSIGN integer_constant KW_TO integer_constant KW_DO 
    { 
        // Create invisible symbol table.
        push_SymbolTable(false); 

        // Check loop variable redeclare.
        if(checkLoopVarRedeclare($2))
            symTable.back().addLoopVar($2);

        if ($4 > $6)
            semanticError("loop parameter's lower bound > uppper bound");
        genForLoop(symTable.back().entries.back(), $4, $6);
    }
    statements 
    { 
        genForLoopEnd(symTable.back().entries.back());
        pop_SymbolTable(false); 
    }
   KW_END KW_DO
 ;

return_statement 
 : KW_RETURN expression SEMICOLON {
    if (isParsingProgram)
        semanticError("program cannot be returned");
    else {
        SymbolTableEntry p = getLastFunc();
        if (p.type.typeID != $2.typeID)
            semanticError("return type mismatch");
        else if (p.type.dimensions.size() != $2.dimensions.size())
            semanticError("return dimension number mismatch");
        genReturn($2);
    }
   }
 ;

function_invocation_statement
 : function_invocation SEMICOLON
 ;


/* common grammar */
expressions
 : empty { $$.clear(); }
 | { func_param_counter = 0; }
   expression_list 
   { $$ = $2; }
 ;

expression_list
 : expression_list COMMA boolean_expr
    { 
        $$=$1; 
        $$.push_back($3);
        if ($3.typeID == T_INTEGER && func_invoke.attr.paramLst[func_param_counter].typeID == T_REAL)
            genI2F();
        func_param_counter++;
    }
 | boolean_expr
    { 
        $$.clear();
        $$.push_back($1); 
        if ($1.typeID == T_INTEGER && func_invoke.attr.paramLst[func_param_counter].typeID == T_REAL)
            genI2F();
        func_param_counter++;
    }
 ;

boolean_expr
 : boolean_expr OR boolean_term
    {
        $$.dimensions.clear();
        if (!verifyAndOrOp($1, $2, $3))
            $$.typeID = T_ERROR;
        else {
            $$.typeID = T_BOOLEAN;
            genCode(1, "ior ");
        }
    }
 | boolean_term { $$ = $1; }
 ;

boolean_term        
 : boolean_term AND boolean_factor
    {
        $$.dimensions.clear();
        if (!verifyAndOrOp($1, $2, $3))
            $$.typeID = T_ERROR;
        else {
            $$.typeID = T_BOOLEAN;
            genCode(1, "iand ");
        }
    }
 | boolean_factor { $$ = $1; }
 ;

boolean_factor      
 : NOT boolean_factor
    {
        $$.dimensions.clear();
        if (!verifyNotOp($2))
            $$.typeID = T_ERROR;
        else {
            $$.typeID = T_BOOLEAN;
            genCode(1, "iconst_1 ");
            genCode(1, "ixor ");
        }
    }
 | relop_expr { $$ = $1; }
 ;

relop_expr      
 : expression rel_op expression
    {
        char buf[300];
        if (!verifyRelOp($1, $2, $3))
            $$.typeID = T_ERROR;
        else {
            $$.typeID = T_BOOLEAN;
            // Generate relational op bytecodes
            genRelOp($1, $2, $3);
        }
    }
 | expression { $$ = $1; }
 ;

expression           
 : expression add_op term
    {
        char buf[300];
        $$.dimensions.clear();

        if (!verifyArithOp($1, $2, $3))
            $$.typeID = T_ERROR;
        else if ($1.typeID == T_STRING && $3.typeID == T_STRING && strcmp($2, "+") == 0) {
            $$.typeID = T_STRING;
        } else if (($1.typeID != T_INTEGER && $1.typeID != T_REAL) ||
                   ($3.typeID != T_INTEGER && $3.typeID != T_REAL)) {
            sprintf(buf, "operands of operator '%s' are not both integer or both real", $2);
            semanticError(buf);
            $$.typeID = T_ERROR;
        } else if ($1.typeID == T_INTEGER && $3.typeID == T_INTEGER) {
            $$.typeID = T_INTEGER;
            genCode(1, "i%s ", operatorCode[$2].c_str());
        } else {
            $$.typeID = T_REAL;
            if ($1.typeID == T_INTEGER)
                genStoreAndI2F();
            else if ($3.typeID == T_INTEGER)
                genI2F();
            genCode(1, "f%s ", operatorCode[$2].c_str());
        }
    }
 | term { $$ = $1; }
 ;

term            
 : term mul_op factor 
    {
        char buf[300];
        $$.dimensions.clear();
        
        if (!verifyArithOp($1, $2, $3))
            $$.typeID = T_ERROR;
        else if( strcmp($2, "mod") == 0 ) {

            if (!verifyModOp($1, $3))
                $$.typeID = T_ERROR;
            else {
                $$.typeID = T_INTEGER;
                genCode(1, "irem ");
            }
        } else { // *, /
            if (($1.typeID != T_INTEGER && $1.typeID != T_REAL) ||
                ($3.typeID != T_INTEGER && $3.typeID != T_REAL)) {
                sprintf(buf, "operands of operator '%s' are not both integer or both real", $2);
                semanticError(buf);
                $$.typeID = T_ERROR;
            } else if ($1.typeID == T_INTEGER && $3.typeID == T_INTEGER) {
                $$.typeID = T_INTEGER;
                genCode(1, "i%s ", operatorCode[$2].c_str());
            } else {
                $$.typeID = T_REAL;
                if ($1.typeID == T_INTEGER)
                    genStoreAndI2F();
                else if ($3.typeID == T_INTEGER)
                    genI2F();
                genCode(1, "f%s ", operatorCode[$2].c_str());
            }
        }
    }
 | factor { $$ = $1; }
 ;


factor          
 : SUB factor {

    if ($2.typeID == T_ERROR)
        $$.typeID = T_ERROR;
    else if ($2.dimensions.size()>0){
        sprintf(buf, "operand of operator 'negative' is array type");
        semanticError(buf);
        $$.typeID = T_ERROR;
    } else if ($2.typeID == T_INTEGER) {
        $$.typeID = T_INTEGER;
        genCode(1, "ineg ");
    } else if ($2.typeID == T_REAL) {
        $$.typeID = T_REAL;
        genCode(1, "fneg ");
    } else {
        semanticError("operand of operator 'negative' is not number");
        $$.typeID = T_ERROR;
    }
   }
 | variable_reference 
    { 
        $$ = $1.type;
        if ($1.kind == K_PROG) {
            $$.typeID = T_ERROR;
            sprintf(buf, "'%s' is program", $1.name);
            semanticError(buf);
        } else if ($1.kind == K_FUNC) {
            $$.typeID = T_ERROR;
            sprintf(buf, "'%s' is function", $1.name);
            semanticError(buf);
        } else if ($1.kind == K_CONST) {
            genLoadConst($1.attr.constant);
        } else {
            genLoadVar($1);
        }
    }
 | L_PAREN boolean_expr R_PAREN
    {
        $$ = $2;
    }
 | function_invocation { $$ = $1; }
 | literal_constant
    { 
        $$.typeID = $1.typeID;
        genLoadConst($1);
    }
 ;

rel_op
 : GREAT  { $$ = $1; }
 | GREAT_EQU  { $$ = $1; }
 | EQU  { $$ = $1; }
 | LESS_EQU  { $$ = $1; }
 | LESS  { $$ = $1; }
 | NOT_EQU { $$ = $1; }
 ;

add_op
 : ADD { $$ = $1; }
 | SUB  { $$ = $1; }
 ;

mul_op
 : MOD { $$ = $1; }
 | MUL { $$ = $1; }
 | DIV { $$ = $1; }
 ;

function_invocation
 : IDENT 
    {
        func_invoke = findFunction($1);
    }
   L_PAREN expressions R_PAREN 
    { 
        $$.typeID = T_ERROR;
        if (func_invoke.type.typeID != T_ERROR) {
            char buf[300];
            int argNum = $4.size();
            int paramNum = func_invoke.attr.paramLst.size();
            if (argNum < paramNum) {
                sprintf(buf, "too few arguments to function '%s'", $1);
                semanticError(buf);
            } else if (argNum > paramNum) {
                sprintf(buf, "too many arguments to function '%s'", $1);
                semanticError(buf);
            } else {
                bool allMatch = true;
                for (int i=0; i<argNum; i++) {
                    if (func_invoke.attr.paramLst[i].acceptable($4[i]) != E_OK) {
                        allMatch = false;
                        semanticError("parameter type mismatch");
                        break;
                    }
                }

                if (allMatch) {
                    $$ = func_invoke.type;
                    genFuncInvoke(func_invoke);
                }
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
            if ($2 == -1) {
                semanticError("array index is not integer");
                $$.type.typeID = T_ERROR;
            } else if ($2 > dim) {
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
 : reference_list L_BRACKET boolean_expr R_BRACKET { 
    if ($1 != -1 && $3.typeID == T_INTEGER)
        $$ = $1 + 1;
    else
        $$ = -1;
   }
 | empty { $$ = 0; }
 ;

type
 : scalar_type {
     $$.typeID = $1;
   }
 | KW_ARRAY integer_constant KW_TO integer_constant KW_OF type {
    $$.typeID = $6.typeID;
    if ($$.typeID != T_ERROR){
        if ($4 > $2) {
            $$.dimensions = $6.dimensions;
            $$.dimensions.insert($$.dimensions.begin(),$4-$2+1);  
        } else {
            $$.typeID = T_ERROR;
            $$.dimensions.clear();
        }
    }
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
    if( argc < 2 ) {
        fprintf(  stdout,  "Usage:  ./parser  [input_filename] [output_filename]\n"  );
        exit(0);
    }

    FILE *fp = fopen( argv[1], "r" );
    fileName = getFileName(argv[1]);
    if( fp == NULL )  {
        fprintf( stdout, "Open  file  error\n" );
        exit(-1);
    }
    
    symTable.clear();
    operatorCode["+"] = "add";
    operatorCode["-"] = "sub";
    operatorCode["*"] = "mul";
    operatorCode["/"] = "div";
    operatorCode["mod"] = "rem";
    operatorCode["neg"] = "neg";
    operatorCode["and"] = "and";
    operatorCode["or"] = "or";
    operatorCode["not"] = "xor";


    yyin = fp;
    if (argc == 3)
        yyoutput = fopen( argv[2], "w" );
    yyparse();
    // if (noError) {
    //     printf("|-------------------------------------------|\n");
    //     printf("| There is no syntactic and semantic error! |\n");
    //     printf("|-------------------------------------------|\n");
    // }
    exit(0);
}

