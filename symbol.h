#include <vector>

typedef enum _Kind {
  K_PROG, K_FUNC, K_PARAM, K_VAR, K_CONST
} Kind;

typedef enum _TypeName {
  T_INTEGER, T_REAL, T_BOOLEAN, T_STRING, T_ARRAY
} TypeName;

typedef struct _ArrayInfo {
  TypeName typeName;
  std::vector<int> dimensions;
} ArrayInfo;

typedef struct _Type {
  TypeName typeName;
  ArrayInfo arrayInfo;
} Type;

typedef union _Attr {
  union {
    int integer;
    float real;
    bool bl;
    char* str; 
  } constant;
  std::vector<Type>* paramLst;
} Attr;

class SymbolTableEntry {
public:
  char name[35];
  Kind kind;
  Type type;
  Attr attr;
};

class SymbolTable {
public:
  SymbolTable(int level);
  std::vector<SymbolTableEntry> entries;
  int level, size;
};

