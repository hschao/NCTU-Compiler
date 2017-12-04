#include <vector>
#include <cstring>
#include <iostream>

typedef enum {
  K_PROG, K_FUNC, K_PARAM, K_VAR, K_CONST
} Kind;

typedef enum {
  T_INTEGER, T_REAL, T_BOOLEAN, T_STRING
} TypeID;

typedef struct {
  TypeID typeID;
  std::vector<int> dimensions;
} Type;

typedef struct {
  TypeID typeID;
  int integer;
  double real;
  bool bl;
  char* str;  
} Variant;

typedef struct {
  Variant constant;
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
  void addConstants(std::vector<std::string> &ids, Variant value);
  void addVariables(std::vector<std::string> &ids, Type t);

  std::vector<SymbolTableEntry> entries;
  int level;
private:
  char* TypeToString(char* buf, Type t);
};

void push_SymbolTable();
void pop_SymbolTable(bool print);

extern std::vector<SymbolTable> symTable;

