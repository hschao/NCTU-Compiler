

typedef struct _Type {
  unsigned kind;
  struct _Type* array_type;
} Type;

typedef struct _SymbolTableEntry {
  char name[35];
  Type type;
  struct _SymbolTableEntry* next;
} SymbolTableEntry;

typedef struct {
  SymbolTableEntry* head;
  unsigned int level, size;
} SymbolTable;

