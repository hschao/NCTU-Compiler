#include <vector>
#include <cstring>
#include <iostream>

typedef enum _Kind {
  K_PROG=0, K_FUNC, K_PARAM, K_VAR, K_CONST
} Kind;

typedef enum _TypeName {
  T_INTEGER=5, T_REAL, T_BOOLEAN, T_STRING, T_ARRAY
} TypeName;

typedef struct _ArrayInfo {
  TypeName typeName;
  std::vector<int> dimensions;
} ArrayInfo;

typedef struct _Type {
  TypeName typeName;
  ArrayInfo arrayInfo;
} Type;

typedef struct {
  struct {
    int integer;
    float real;
    bool bl;
    std::string str; 
  } constant;
  std::vector<Type> paramLst;
} Attr;

class SymbolTableEntry {
public:
  SymbolTableEntry();
  ~SymbolTableEntry();
  char name[35];
  Kind kind;
  Type type;
  Attr attr;
};

class SymbolTable {
public:
  SymbolTable() {};
  SymbolTable(int level);
  void PrintTable();
  void addEntry();
  std::vector<SymbolTableEntry> entries;
  int level;
private:
  char* TypeToString(char* buf, Type t);
};

void push_SymbolTable();
void pop_SymbolTable(bool print);

extern std::vector<SymbolTable> symTable;

