// genCode.h
#ifndef GEN_CODE_H
#define GEN_CODE_H

#include "symbol.h"
#include <cstring>

extern char typeCode[3];
extern char arithCode[3];

void genCode(int add_indent, const char *fmt, ...);
void genProgBegin();
void genMainBegin();
void genMainEnd();
void genStoreVar(SymbolTableEntry ste);
void genLoadVar(SymbolTableEntry ste);
void genLoadConst(Variant val);

#endif