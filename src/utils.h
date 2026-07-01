#ifndef UTILS_H
#define UTILS_H

#include <stddef.h>

#include "symtable.h"
#include "temporary.h"

/* Gera código TAC simples. */
#include "tac-generator.h"

/* Retorna o menor limite superior entre dois tipos na hierarquia:
 * boolean -> int -> float
 */
int max(int t1, int t2);

/* Faz widening de um address textual quando t1 < t2.
 * Se os tipos forem iguais, retorna o próprio addr.
 * Em caso de tipos inválidos ou ordem incorreta, imprime erro e retorna addr.
 */
char *widen(char *addr, int t1, int t2);

#endif /* UTILS_H */