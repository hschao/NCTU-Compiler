#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include "symbol.h"

typedef struct 
{
  int intValue;
  double doubleValue;
  bool boolValue;
  char *stringValue;
  Variant variant;
  std::vector<std::string> ids;
  std::vector<Arg> args;
  Type type;
  TypeID typeID;
  SymbolTableEntry entry;
} yylvalType;

#define YYSTYPE yylvalType