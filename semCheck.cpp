#include "semCheck.h"

bool noError = true;
extern int linenum; 

void semanticError( std::string msg )
{
    printf("<Error> found in Line %d: %s\n", linenum, msg.c_str() );
    noError = false;
}

bool verifyAndOrOp(Type a, std::string op, Type b)
{
    char buf[300];
    bool result = true;
    if (a.typeID == T_ERROR || b.typeID == T_ERROR)
        result = false;
    else if (a.dimensions.size()>0 || b.dimensions.size()>0){
        sprintf(buf, "one of the operands of operator '%s' is array type", op.c_str());
        semanticError(buf);
        result = false;
    } else if (a.typeID != T_BOOLEAN || b.typeID != T_BOOLEAN) {
        sprintf(buf, "one of the operands of operator '%s' is not boolean", op.c_str());
        semanticError(buf);
        result = false;
    }
    return result;
}

bool verifyNotOp(Type a)
{
    char buf[300];
    bool result = true;
    if (a.typeID == T_ERROR)
        result = false;
    else if (a.dimensions.size()>0){
        sprintf(buf, "operand of operator 'not' is array type");
        semanticError(buf);
        result = false;
    } else if (a.typeID != T_BOOLEAN) {
        semanticError("operand of operator 'not' is not boolean");
        result = false;
    }
    return result;
}

bool verifyRelOp(Type a, std::string op, Type b)
{
    char buf[300];
    bool result = true;
    if (a.typeID == T_ERROR || b.typeID == T_ERROR)
        result = false;
    else if (a.dimensions.size()>0 || b.dimensions.size()>0){
        sprintf(buf, "one of the operands of operator '%s' is array type", op.c_str());
        semanticError(buf);
        result = false;
    } else if ((a.typeID != T_INTEGER && a.typeID != T_REAL) || (a.typeID != b.typeID)) {
        sprintf(buf, "operands of operator '%s' are not both integer or both real", op.c_str());
        semanticError(buf);
        result = false;
    }
    return result;
}

bool verifyArithOp(Type a, std::string op, Type b)
{
    char buf[300];
    bool result = true;
    if (a.typeID == T_ERROR) {
        sprintf(buf, "error in left operand of '%s' operator", op.c_str());
        semanticError(buf);
        result = false;
    } else if (b.typeID == T_ERROR) {
        sprintf(buf, "error in right operand of '%s' operator", op.c_str());
        semanticError(buf);
        result = false;
    } else if (a.dimensions.size()>0 || b.dimensions.size()>0){
        sprintf(buf, "one of the operands of operator '%s' is array type", op.c_str());
        semanticError(buf);
        result = false;
    }
    return result;
}

bool verifyModOp(Type a, Type b)
{
    char buf[300];
    bool result = true;
    if (a.typeID != T_INTEGER || b.typeID != T_INTEGER) {
        semanticError("one of the operands of operator 'mod' is not integer");
        result = false;
    } else if (a.dimensions.size()>0 || b.dimensions.size()>0){
        sprintf(buf, "one of the operands of operator 'mod' is array type");
        semanticError(buf);
        result = false;
    }
    return result;
}

