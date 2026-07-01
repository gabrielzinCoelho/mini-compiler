#include "utils.h"

static int type_rank(int type) {
    switch (type) {
        case SYM_TYPE_BOOL:
            return 0;
        case SYM_TYPE_INT:
            return 1;
        case SYM_TYPE_FLOAT:
            return 2;
        default:
            return -1;
    }
}

int max(int t1, int t2) {
    int r1 = type_rank(t1);
    int r2 = type_rank(t2);

    if (r1 < 0) {
        fprintf(stderr, "Erro: tipo invalido em max(%d, %d)\n", t1, t2);
        return t2;
    }

    if (r2 < 0) {
        fprintf(stderr, "Erro: tipo invalido em max(%d, %d)\n", t1, t2);
        return t1;
    }

    return (r1 >= r2) ? t1 : t2;
}