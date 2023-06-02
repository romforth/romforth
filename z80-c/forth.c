/*
 * forth.c : inner interpreter and other glue logic
 *
 * Copyright (c) 2023 Charles Suresh <romforth@proton.me>
 * SPDX-License-Identifier: AGPL-3.0-only
 * Please see the LICENSE file for the Affero GPL 3.0 license details
 */

#include <stddef.h>

#define VAR(x) offsetof(struct var, x)

#define bin(op) tos = nos op tos;

static unsigned char * volatile sif= (unsigned char *)0x7fff;

typedef const struct lfa {
	const struct lfa *prev;
} lfa;

enum {
#include "enum.h"
};

int getchar() {
	*sif= 'r';
	return *sif;
}

void putchar(unsigned char c) {
	*sif= 'w';
	*sif= c;
}

int tos, nos;
int datastk[100], *d=datastk;

unsigned char mem[2048];

struct var {
	unsigned char *here;
} vars = {
	(unsigned char *)mem,
};

char *varalias=(char *)&vars;

int main() {
	char rom[]={
#include "rom.h"
	}, w, *ip=rom;
	signed char i;
#ifdef USEDEFS
#include "dict.h"
#include "defs.h"
#include "latest.h"
#endif

	for (;;) {
		switch (w=*ip++) {
#include "prims.h"
		default : goto error;
		}
	}
error:
	putchar(w);
	return 1;
}
