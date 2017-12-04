#include "symbol.h"

std::vector<SymbolTable> symTable;
const char* lookUp[] = {"program", "function", "parameter", "variable", "constant", "integer", "real", "boolean", "string"};

SymbolTable::SymbolTable(int level) {
  this->level = level;

}

void SymbolTable::PrintTable() {
  // Print header.
  int i;
  for(i=0;i< 110;i++) {
    printf("=");
  }
  printf("\n");
  printf("%-33s%-11s%-11s%-17s%-11s\n","Name","Kind","Level","Type","Attribute");
  for(i=0;i< 110;i++) {
    printf("-");
  }
  printf("\n");

  // Print contents.
  for(i=0; i<entries.size(); i++) {
    // Name
    printf("%-33s", entries[i].name);

    // Kind
    printf("%-11s", lookUp[entries[i].kind]);
    
    // Level
    printf("%d%-10s", level, (level==0? "(global)": "(local)"));

    // Type
    char buf[200];
    TypeToString(buf, entries[i].type);
    printf("%-17s", buf);  


    // Attribute
    std::string output;
    if (entries[i].kind == K_FUNC) {
      if (entries[i].attr.paramLst.size() > 0) {
        std::vector<Type> v = entries[i].attr.paramLst;
        output = TypeToString(buf, v[0]);
        for(i=1; i<v.size(); i++) {
          output += ", " ;
          output += TypeToString(buf, v[i]);
        }
        printf("%-11s", output.c_str());
      }
    } else if (entries[i].kind == K_CONST) {
      switch (entries[i].type.typeName) {
        case T_INTEGER: printf("%-11d", entries[i].attr.constant.integer); break;
        case T_REAL: printf("%-11f", entries[i].attr.constant.real); break;
        case T_BOOLEAN: printf("%-11s", entries[i].attr.constant.bl? "true": "false"); break;
        case T_STRING: printf("%-11s", entries[i].attr.constant.str.c_str()); break;
      }
    }
    printf("\n");
  }

  // Print
  for(i=0;i< 110;i++) {
    printf("-");
  }
  printf("\n");
}

char* SymbolTable::TypeToString(char* buf, Type t) {
  switch (t.typeName) {
    case T_INTEGER: 
    case T_REAL: 
    case T_BOOLEAN: 
    case T_STRING: 
      sprintf(buf, "%-17s", lookUp[t.typeName]); 
      break;
    case T_ARRAY: 
      int i = sprintf(buf, "%s ", lookUp[t.arrayInfo.typeName]);
      for(int j=0; j<t.arrayInfo.dimensions.size(); j++) {
        int dim = t.arrayInfo.dimensions[j];
        sprintf(buf+i, "[%d]", dim);
      }
      break; 
  }
  return buf;
}

SymbolTableEntry::~SymbolTableEntry() {
  // if (kind == K_FUNC && attr.paramLst != NULL)
  //   delete attr.paramLst;
}

SymbolTableEntry::SymbolTableEntry() {
  // attr.paramLst = NULL;
}

void push_SymbolTable() {
  int tableCount = symTable.size();
  SymbolTable st(tableCount);
  symTable.push_back(st);
}

void pop_SymbolTable(bool print) {
  SymbolTable st = symTable.back();
  if (print)
    st.PrintTable();
  symTable.pop_back();
}