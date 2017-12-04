#include "symbol.h"

std::vector<SymbolTable> symTable;
const char* kindToStr[] = {"program", "function", "parameter", "variable", "constant"};
const char* typeToStr[] = {"integer", "real", "boolean", "string"};

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
  // printf("level = %d\n", level);
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
    printf("%-11s", kindToStr[entries[i].kind]);
    
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
      switch (entries[i].type.typeID) {
        case T_INTEGER: printf("%-11d", entries[i].attr.constant.integer); break;
        case T_REAL: printf("%-11f", entries[i].attr.constant.real); break;
        case T_BOOLEAN: printf("%-11s", entries[i].attr.constant.bl? "true": "false"); break;
        case T_STRING: printf("\"%-11s\"", entries[i].attr.constant.str); break;
        default:;
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

void SymbolTable::addConstants(std::vector<std::string> &ids, Variant value) {
  for(int i=0; i<ids.size(); i++) {
    SymbolTableEntry ste;
    strcpy(ste.name, ids[i].c_str());
    ste.kind = K_CONST;
    ste.type.typeID = value.typeID;
    ste.type.dimensions.clear();
    ste.attr.constant = value;
    entries.push_back(ste);
  }
}

void SymbolTable::addVariables(std::vector<std::string> &ids, Type t) {
  // for(int i=0; i<ids.size(); i++) {
  //   SymbolTableEntry ste;
  //   strcpy(ste.name, ids[i].c_str());
  //   ste.kind = K_CONST;
  //   ste.type.typeID = value.typeID;
  //   ste.type.dimensions.clear();
  //   ste.attr.constant = value;
  //   entries.push_back(ste);
  // }
}

char* SymbolTable::TypeToString(char* buf, Type t) {

  bool isArray = (t.dimensions.size() > 0);
  int i = sprintf(buf, isArray? "%s ": "%s", typeToStr[t.typeID]);
  if (isArray) {
    for(int j=0; j<t.dimensions.size(); j++) {
      int dim = t.dimensions[j];
      sprintf(buf+i, "[%d]", dim);
    }
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