#ifndef TEMPORARY_H
#define TEMPORARY_H

typedef struct Temporary {
	char name[32];
} Temporary;

Temporary *temporary_new(void);
void temporary_free(Temporary *temporary);
const char *temporary_get_name(const Temporary *temporary);

#endif
