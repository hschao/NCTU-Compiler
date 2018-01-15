#include "genCode.h"

#include <cstdio>
#include <cstdlib>
#include <cstdarg>

extern std::string fileName;

char typeCode[3] = {'I', 'F', 'Z'};
char arithCode[3] = {'i', 'f', 'i'};

void genCode(int add_indent, const char *fmt, ...) { 
    static int indent = 0;
    indent += add_indent;
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
    genCode(0, ".limit locals 100 ");
    genCode(0, "new java/util/Scanner "); 
    genCode(0, "dup ");
    genCode(0, "getstatic java/lang/System/in Ljava/io/InputStream; ");
    genCode(0, "invokespecial java/util/Scanner/<init>(Ljava/io/InputStream;)V ");
    genCode(0, "putstatic %s/_sc Ljava/util/Scanner; ", fileName.c_str());
}

void genMainEnd() {
    genCode(0, "return ");
    genCode(-1, ".end method ");
}

void genStoreVar(SymbolTableEntry ste) {

    if (ste.attr.varNo == -1) { // global variable
        genCode(0, "putstatic %s/%s %c ", fileName.c_str(), ste.name, typeCode[ste.type.typeID]);
    } else { // local variable
        genCode(0, "%cstore %d ", arithCode[ste.type.typeID], ste.attr.varNo);
    }
}

void genLoadVar(SymbolTableEntry ste) {

    if (ste.attr.varNo == -1) { // global variable
        genCode(0, "getstatic %s/%s %c ", fileName.c_str(), ste.name, typeCode[ste.type.typeID]);
    } else { // local variable
        genCode(0, "%cload %d ", arithCode[ste.type.typeID], ste.attr.varNo);
    }
}

void genLoadConst(Variant val) {
    if (val.typeID == T_INTEGER) {
        genCode(0, "ldc %d ", val.integer);
    } else if (val.typeID == T_REAL) {
        genCode(0, "ldc %f ", val.real);
    } else if (val.typeID == T_BOOLEAN) {
        genCode(0, val.bl? "iconst_1 ": "iconst_0 ");
    } else if (val.typeID == T_STRING) {
        genCode(0, "ldc \"%s\" ", val.str);
    }
}