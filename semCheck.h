// semcheck.h
#ifndef SEMCHECK_H
#define SEMCHECK_H

#include "symbol.h"
#include <cstring>

extern bool noError;

void semanticError( std::string msg );
bool verifyAndOrOp(Type a, std::string op, Type b);
bool verifyNotOp(Type a);
bool verifyRelOp(Type a, std::string op, Type b);
bool verifyArithOp(Type a, std::string op, Type b);
bool verifyModOp(Type a, Type b);
#endif