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

#define MAXD 100
cell dstk[MAXD], *d=dstk, maxd=0;

void
checkempty(cell *d, cell *s) {
	if (d!=s) {
		die(2, "Data stack is not empty, remaining=%d\n", d-s);
	}
}

void
verify() {
	checkempty(d, dstk);
}

void
push(cell c) {
	*d++=c;
	int l=d-dstk;
	if (l>maxd) {
		maxd=l;
	}
	if (maxd>MAXD) {
		die(3, "Data stack size needs to be increased, current=%d\n", MAXD);
	}
}

void
pop(cell *cp) {
	*cp=*--d;
	if (d-dstk < 0) {
		die(4, "Data stack underflowed by %d\n", d-dstk);
	}
}

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
	atexit(verify);
	for(;;) {
		exec(w=*ip++);
	}
}
