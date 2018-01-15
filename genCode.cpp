#include "genCode.h"

#include <cstdio>
#include <cstdlib>
#include <cstdarg>
#include <vector>

extern std::string fileName;

char typeCode[3] = {'I', 'F', 'Z'};
char arithCode[3] = {'i', 'f', 'i'};
std::map<std::string, std::string> operatorCode;
std::vector<int> labelStack;
int nextLabelNo = 0;

void genCode(int indent, const char *fmt, ...) { 
    va_list args;
    va_start (args, fmt);
    for (int i = 0; i < indent; ++i)
        printf("\t");
    vprintf (fmt, args);
    printf ("\n");
    va_end (args);
}

void genProgBegin() {
    genCode(0, "; %s.j ", fileName.c_str());
    genCode(0, ".class public %s ", fileName.c_str());
    genCode(0, ".super java/lang/Object ");
    genCode(0, ".field public static _sc Ljava/util/Scanner; ");
}

void genMainBegin() {
    genCode(0, "");
    genCode(0, ".method public static main([Ljava/lang/String;)V ");
    genCode(1, ".limit stack 100 ");
    genCode(1, ".limit locals 100 ");
    genCode(1, "new java/util/Scanner "); 
    genCode(1, "dup ");
    genCode(1, "getstatic java/lang/System/in Ljava/io/InputStream; ");
    genCode(1, "invokespecial java/util/Scanner/<init>(Ljava/io/InputStream;)V ");
    genCode(1, "putstatic %s/_sc Ljava/util/Scanner; ", fileName.c_str());
}

void genMainEnd() {
    genCode(1, "return ");
    genCode(0, ".end method ");
}

void genStoreVar(SymbolTableEntry ste) {

    if (ste.attr.varNo == -1) { // global variable
        genCode(1, "putstatic %s/%s %c ", fileName.c_str(), ste.name, typeCode[ste.type.typeID]);
    } else { // local variable
        genCode(1, "%cstore %d ", arithCode[ste.type.typeID], ste.attr.varNo);
    }
}

void genLoadVar(SymbolTableEntry ste) {

    if (ste.attr.varNo == -1) { // global variable
        genCode(1, "getstatic %s/%s %c ", fileName.c_str(), ste.name, typeCode[ste.type.typeID]);
    } else { // local variable
        genCode(1, "%cload %d ", arithCode[ste.type.typeID], ste.attr.varNo);
    }
}

void genLoadConst(Variant val) {
    if (val.typeID == T_INTEGER) {
        genCode(1, "ldc %d ", val.integer);
    } else if (val.typeID == T_REAL) {
        genCode(1, "ldc %f ", val.real);
    } else if (val.typeID == T_BOOLEAN) {
        genCode(1, val.bl? "iconst_1 ": "iconst_0 ");
    } else if (val.typeID == T_STRING) {
        genCode(1, "ldc \"%s\" ", val.str);
    }
}

void genI2F() {
    genCode(1, "i2f ");
}

void genStoreAndI2F() {
    genCode(1, "fstore %d ", nextVarNo);
    genI2F();
    genCode(1, "fload %d ", nextVarNo);
}

void genPrint(TypeID t) {
    switch(t){
        case T_STRING:
            genCode(1, "invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V ");
            break;
        case T_INTEGER:
            genCode(1, "invokevirtual java/io/PrintStream/print(I)V ");
            break;
        case T_REAL:
            genCode(1, "invokevirtual java/io/PrintStream/print(F)V ");
            break;
        case T_BOOLEAN:
            genCode(1, "invokevirtual java/io/PrintStream/print(Z)V ");
            break;
    }
}

void genRead(SymbolTableEntry ste) {
    genCode(1, "getstatic %s/_sc Ljava/util/Scanner; ", fileName.c_str());
    switch(ste.type.typeID){
        case T_INTEGER:
            genCode(1, "invokevirtual java/util/Scanner/nextInt()I ");
            break;
        case T_REAL:
            genCode(1, "invokevirtual java/util/Scanner/nextFloat()F ");
            break;
        case T_BOOLEAN:
            genCode(1, "invokevirtual java/util/Scanner/nextBoolean()Z ");
            break;
    }
    genStoreVar(ste);
}

void genRelOp(Type a, std::string op, Type b)
{
    labelStack.push_back(nextLabelNo++);
    if(a.typeID == T_INTEGER)
        genCode(1, "isub ");
    else if(a.typeID == T_REAL)
        genCode(1, "fcmpl ");
    if (op == "<")
        genCode(1, "iflt Ltrue_%d ", labelStack.back());
    else if (op == "<=")
        genCode(1, "ifle Ltrue_%d ", labelStack.back());
    else if (op == "<>")
        genCode(1, "ifne Ltrue_%d ", labelStack.back());
    else if (op == ">=")
        genCode(1, "ifge Ltrue_%d ", labelStack.back());
    else if (op == ">")
        genCode(1, "ifgt Ltrue_%d ", labelStack.back());
    else if (op == "=")
        genCode(1, "ifeq Ltrue_%d ", labelStack.back());
    genCode(1, "iconst_0 "); //false
    genCode(1, "goto Lfalse_%d ", labelStack.back());
    genCode(0, "Ltrue_%d: ", labelStack.back());
    genCode(1, "iconst_1 ");//true
    genCode(0, "Lfalse_%d: ", labelStack.back());
    labelStack.pop_back();
}