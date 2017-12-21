#include "symbol.h"
using namespace std;

extern int linenum;
extern void semanticError( string msg );

vector<SymbolTable> symTable;
const char* kindToStr[] = {"program", "function", "parameter", "variable", "constant"};
const char* typeToStr[] = {"integer", "real", "boolean", "string", "void"};

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
        for(int k=1; k<v.size(); k++) {
          output += ", " ;
          output += TypeToString(buf, v[k]);
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

void SymbolTable::addConstants(vector<string> &ids, Variant value) {
  for(int i=0; i<ids.size(); i++) {
    SymbolTableEntry ste;
    strcpy(ste.name, ids[i].c_str());
    ste.kind = K_CONST;
    ste.type.typeID = value.typeID;
    ste.type.dimensions.clear();
    ste.attr.constant = value;
    addEntry(ste);
  }
}

void SymbolTable::addVariables(vector<string> &ids, Type t) {
  for(int i=0; i<ids.size(); i++) {
    SymbolTableEntry ste;
    strcpy(ste.name, ids[i].c_str());
    ste.kind = K_VAR;
    ste.type = t;
    addEntry(ste);
  }
}

void SymbolTable::addFunction(string id, vector<Arg> &paramLst, Type retType) {
  SymbolTableEntry ste;
  strcpy(ste.name, id.c_str());
  ste.kind = K_FUNC;
  ste.type = retType;
  for(int i=0; i<paramLst.size(); i++)
    ste.attr.paramLst.push_back(paramLst[i].t);
  addEntry(ste);
}

void SymbolTable::addParameters(std::vector<Arg> &paramLst) {

  for(int i=0; i<paramLst.size(); i++) {
    SymbolTableEntry ste;
    strcpy(ste.name, paramLst[i].name.c_str());
    ste.kind = K_PARAM;
    ste.type = paramLst[i].t;
    if (!addEntry(ste))
      paramLst.erase(paramLst.begin()+i);
  }
}

void SymbolTable::addProgram(std::string name) {

  SymbolTableEntry ste;
  strcpy(ste.name, name.c_str());
  ste.kind = K_PROG;
  ste.type.typeID = T_NONE;
  addEntry(ste);
}

bool SymbolTable::addEntry(SymbolTableEntry &ste) {
  if (!checkLoopVarRedeclare(ste.name))
    return false;
  for (int i=0; i<entries.size(); ++i)
  {
    if (strcmp(entries[i].name,ste.name)==0) {
      char buf[200];
      sprintf(buf, "symbol '%s' is redeclared", ste.name);
      semanticError(buf);
      return false;
    }
  }
  entries.push_back(ste);
  return true;
}

char* SymbolTable::TypeToString(char* buf, Type t) {

  bool isArray = (t.dimensions.size() > 0);
  int i = sprintf(buf, isArray? "%s ": "%s", typeToStr[t.typeID]);
  if (isArray) {
    for(int j=0; j<t.dimensions.size(); j++) {
      int dim = t.dimensions[j];
      i += sprintf(buf+i, "[%d]", dim);
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

void push_SymbolTable(bool isVisible) {
  int newLevel = (symTable.empty())? 0: symTable.back().level+(isVisible? 1: 0);
  SymbolTable st(newLevel);
  symTable.push_back(st);
}

void pop_SymbolTable(bool print) {
  SymbolTable st = symTable.back();
  if (print)
    st.PrintTable();
  symTable.pop_back();
}

bool checkLoopVarRedeclare(char* name) {
  for (int i=symTable.size()-1; i>=0; i--) {
    if (symTable[i].entries.empty())
      continue;
    if (symTable[i].entries[0].kind==K_LOOP_VAR && strcmp(symTable[i].entries[0].name,name)==0) {
      char buf[200];
      sprintf(buf, "symbol '%s' is redeclared", name);
      semanticError(buf);
      return false;
    }
  }
  return true;
}

SymbolTableEntry* getLastFunc() {
  if (symTable.size() == 0)
    return NULL;
  for(int i=symTable[0].entries.size()-1; i>=0; i--) 
    if (symTable[0].entries[i].kind == K_FUNC)
      return &symTable[0].entries[i];
  return NULL;
}

SymbolTableEntry* findSymbol(string name) {
  for(int i=symTable.size()-1; i>=0; i--)
    for(int j=0; j<symTable[i].entries.size(); j++)
      if (strcmp(symTable[i].entries[j].name, name.c_str()) == 0)
        return &symTable[i].entries[j];
  string msg = "symbol '" + name + "' not found";
  semanticError(msg.c_str());
  return NULL;
}

SymbolTableEntry* findFunction(string name) {

  for(int j=0; j<symTable[0].entries.size(); j++)
    if (strcmp(symTable[0].entries[j].name, name.c_str()) == 0 && symTable[0].entries[j].kind == K_FUNC)
      return &symTable[0].entries[j];
  string msg = "symbol '" + name + "' not found";
  semanticError(msg.c_str());
  return NULL;
}
