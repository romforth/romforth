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

// when switching stacks, save the current tos location at the 0'th element
// and after switching to the new stack, switch to the tos using saved value
#define swapstk(t,s,stk) { \
	int temp=t; \
	t=(s-stk[0])/(sizeof(stk[0])/sizeof(int)); \
	stk[t][0]=s-stk[t]; \
	s=stk[temp]; \
	s+=s[0]; \
}

#define ndstacks 2

int tos, nos;
int datastk[ndstacks][100], *d=&datastk[1][1];
int returnstk[100], *r=returnstk;

unsigned char mem[2048];

struct var {
	unsigned char *here;
	char state;
} vars = {
	(unsigned char *)mem,
	1
};

char *varalias=(char *)&vars;

const char rom[]={
#include "rom.h"
}, *ip=rom;
char w;
signed char i;

#ifdef USEDEFS
#include "dict.h"
#include "defs.h"
#include "latest.h"
#endif

int
main()
{
	for (;;) {
		w=*ip++;
next:
		switch (w) {
#include "prims.h"
		default : goto error;
		}
	}
error:
	putchar(w);
	return 1;
}
