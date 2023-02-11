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

#define bin(op) tos = nos op tos;
#define VAR(x) offsetof(struct ram, x), 0

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
#define debugstk(t,s,stk,x,rstk) { \
	int temp=(s-stk[0])/(sizeof(stk[0])/sizeof(int)); \
	printf("%d [", temp); \
	for (int i=0; &stk[temp][i]!=s; i++) { \
		printf(" 0x%x/%d", stk[temp][i], stk[temp][i]); \
	} \
	printf(" tos: 0x%x/%d |", t, t); \
	temp=(x-rstk[0])/(sizeof(rstk[0])/sizeof(int)); \
	int z, *y=x; \
	for(z=*y; rstk[temp]!=y; y--) { \
		printf(" 0x%x/%d", z, z); \
	} \
	printf("] %d\n",temp); \
}
#else
#define debugstk(t,s,stk,x,rstk)
#endif

void
verify() {
}

struct ram {
	int here;
	char state;
	unsigned char mem[1<<16];
} ram;

#define ndstacks 10
#define nrstacks 8

int
main() {
	static const unsigned short rom[] = {
#include "rom.h"
	};
	const unsigned short register *ip=rom;
	unsigned short i;
	int register tos, nos;
	int datastk[ndstacks][100], *d=&datastk[1][1];
	int returnstk[nrstacks][100], *r=&returnstk[0][1];

	for (int i=0; i<ndstacks; i++) {
		datastk[i][0]=1; // use the 0'th element to save tos location
	}
	for (int i=0; i<nrstacks; i++) {
		returnstk[i][0]=1; // use the 0'th element to save tos location
	}
	ram.here=offsetof(struct ram, mem);
	ram.state=1;
	atexit(verify);
#include "prims.h"
}
