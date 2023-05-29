/*
 * forth.c : inner interpreter and other glue logic
 *
 * Copyright (c) 2023 Charles Suresh <romforth@proton.me>
 * SPDX-License-Identifier: AGPL-3.0-only
 * Please see the LICENSE file for the Affero GPL 3.0 license details
 */

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

int tos;
int datastk[100], *d=datastk;

int main() {
	char rom[]={
#include "rom.h"
	}, w, *ip=rom;
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
	return 1;
}
