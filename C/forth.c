/*
 * forth.c : inner interpreter and other glue logic
 *
 * Copyright (c) 2022-2023 Charles Suresh <romforth@proton.me>
 * SPDX-License-Identifier: AGPL-3.0-only
 * Please see the LICENSE file for the Affero GPL 3.0 license details
 */

#include <stdlib.h>	// atexit
#include <stdio.h>	// getchar putchar
#include <stddef.h>	// offsetof

#define USEDEFS 0

#define bin(op) tos = nos op tos;
#define VAR(x) offsetof(struct var, x)

// when switching stacks, save the current tos location at the 0'th element
// and after switching to the new stack, switch to the tos using saved value
#define swapstk(t,s,stk) { \
	int temp=t; \
	t=(s-stk[0])/(sizeof(stk[0])/sizeof(int)); \
	stk[t][0]=s-stk[t]; \
	s=stk[temp]; \
	s+=s[0]; \
}

#ifdef DEBUG
int rprint=0;

#define debugstk(t,s,stk,x,rstk) { \
	int temp=(s-stk[0])/(sizeof(stk[0])/sizeof(int)); \
	printf("ip:%p *ip:%d ", ip, *ip); \
	printf("%d [", temp); \
	for (int i=0; &stk[temp][i]!=s; i++) { \
		printf(" 0x%x/%d", stk[temp][i], stk[temp][i]); \
	} \
	printf(" tos: 0x%x/%d |", t, t); \
	int z, *y; \
	if (mem==x) rprint=1; \
	if (rprint) { \
		for(y=x; y!=mem; y--) { \
			z=*y; \
			printf(" 0x%x", z); \
		} \
	} \
	printf("] %d\n",temp); \
}
#else
#define debugstk(t,s,stk,x,rstk)
#endif

void
verify() {
}

typedef const struct lfa {
	const struct lfa *prev;
} lfa;

unsigned char mem[1<<16];

struct var {
	char *test;
	const struct lfa *latest;
	unsigned char *here;
	char state;
} vars = {
	(char *)&vars.test,
	0,
	(unsigned char *)mem,
	1
};
char *varalias=(char *)&vars;

#define ndstacks 10

int
main() {
	static const short rom[] = {
#include "rom.h"
	};
#ifdef USEDEFS
#include "dict.h"
#include "defs.h"
#include "latest.h"
#endif
	const short register *ip=rom;
	short i;
	int register tos, nos;
	int datastk[ndstacks][100], *d=&datastk[1][1];
	int returnstk[100], *r=returnstk;

	for (int i=0; i<ndstacks; i++) {
		datastk[i][0]=1; // use the 0'th element to save tos location
	}
	atexit(verify);
#include "prims.h"
}
