#ifndef UTILS_H
#define UTILS_H

#include "symtable.h"

/* Retorna o menor limite superior entre dois tipos na hierarquia:
 * boolean -> int -> float
 */
int max(int t1, int t2);

#endif /* UTILS_H */