#include "symbol.h"

SymbolTable::SymbolTable(int level) {
  this->level = level;

}

SymbolTableEntry::~SymbolTableEntry() {
  if (kind == K_FUNC && attr.paramLst != NULL)
    delete attr.paramLst;
}

SymbolTableEntry::SymbolTableEntry() {
    attr.paramLst = NULL;
}