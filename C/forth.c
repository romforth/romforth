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
	t=(s-stk[0])/sizeof(stk[0]); \
	stk[t][0]=s-stk[t]; \
	s=stk[temp]; \
	s+=s[0]; \
}

void
verify() {
}

struct ram {
	int here;
	char state;
	unsigned char mem[1<<16];
} ram;

#define ndstacks 10

int
main() {
	static const unsigned short rom[] = {
#include "rom.h"
	};
	const unsigned short register *ip=rom;
	unsigned short i;
	int register tos, nos;
	int datastk[ndstacks][100], *d=&datastk[1][1];

	for (int i=0; i<ndstacks; i++) {
		datastk[i][0]=1; // use the 0'th element to save tos location
	}
	ram.here=offsetof(struct ram, mem);
	ram.state=1;
	atexit(verify);
#include "prims.h"
}
