// genCode.h
#ifndef GEN_CODE_H
#define GEN_CODE_H

#include "symbol.h"
#include <cstring>
#include <map>

extern char typeCode[3];
extern char arithCode[3];
extern std::map<std::string, std::string> operatorCode;
extern std::vector<int> labelStack;
extern int nextLabelNo;

void genCode(int add_indent, const char *fmt, ...);
void genProgBegin();
void genMainBegin();
void genMainEnd();
void genStoreVar(SymbolTableEntry ste);
void genLoadVar(SymbolTableEntry ste);
void genLoadConst(Variant val);
void genI2F();
void genStoreAndI2F();
void genPrint(TypeID t);
void genRelOp(Type a, std::string op, Type b);

#endif