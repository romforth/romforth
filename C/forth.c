/*
 * forth.c : inner interpreter and other glue logic
 *
 * Copyright (c) 2022 Charles Suresh <romforth@proton.me>
 * SPDX-License-Identifier: AGPL-3.0-only
 * Please see the LICENSE file for the Affero GPL 3.0 license details
 */

#include <stdlib.h>	// exit
#include <stdio.h>	// getchar, putchar

typedef unsigned char byte;

enum {
#include "enums.h"
};

byte rom[]={
#ifdef TEST_INVALID_OPCODE
	-1,
#endif
#include "rom.h"
};

byte w, *ip=rom;

typedef short cell;

cell tos;

#include <stdarg.h>

void
_die(char *f, int l, int n, char *s, ...) {
	va_list ap;

	va_start(ap, s);
	vfprintf(stderr, s, ap);
	fprintf(stderr, "Died in file %s at line %d\n", f, l);
	exit(n);
}

#define die(n, s, w) _die(__FILE__, __LINE__, n, s, w);

void
exec(byte w) {
	switch(w) {
#include "prims.h"
	default:
		die(1, "unknown opcode %d\n", w);
	}
}

int
main() {
	for(;;) {
		exec(w=*ip++);
	}
}
