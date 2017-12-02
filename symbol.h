typedef struct _ListNode {
  void* data;
  struct _ListNode* next;
} ListNode;

typedef enum _Kind {
  PROG, FUNC, PARAM, VAR, CONSTANT
} Kind;

typedef enum _TypeName {
  INTEGER, REAL, BOOLEAN, STRING, ARRAY;
} TypeName;

typedef struct _ArrayInfo {
  TypeName typeName;
  ListNode* dimLst;
} ArrayInfo;

typedef struct _Type {
  TypeName typeName;
  ArrayInfo arrayInfo;
} Type;

typedef union _Attr {
  union constant {
    int integer;
    float real;
    bool bl;
    char* str; 
  }, 
  ListNode* paramLst;
} Attr;

typedef struct _SymbolTableEntry {
  char name[35];
  Kind kind;
  Type type;
  struct _SymbolTableEntry* next;
} SymbolTableEntry;

typedef struct {
  SymbolTableEntry* head;
  unsigned int level, size;
} SymbolTable;

