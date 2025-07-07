/*
 * forth.c : inner interpreter and other glue logic
 *
 * Copyright (c) 2023-2025 Charles Suresh <romforth@proton.me>
 * SPDX-License-Identifier: AGPL-3.0-only
 * Please see the LICENSE file for the Affero GPL 3.0 license details
 */

#include <stdio.h>
#include <stddef.h>

#define USEDEFS 0

#define VAR(x) offsetof(struct var, x)

#define bin(op) tos = nos op tos;

static unsigned char * volatile sif= (unsigned char *)0xffff;

typedef const struct lfa {
	const struct lfa *prev;
} lfa;

enum {
#include "enum.h"
};

void exits() {
	*sif= 's';
}

int getchar() {
	*sif= 'r';
	return *sif;
}

int putchar(int c) {
	*sif= 'w';
	*sif= c;
	return c;
}

// #define DEBUG

#ifdef DEBUG

int rprint=0;
int tabs=0;

void showname(char *p) {
       unsigned char c=*--p;
       c &=~0x80;
       p-=c;
       putchar('"');
       for (int i=0;i<c;i++) putchar(*p++);
       putchar('"');
       putchar('\n');
}

#define debugstk(t,s,stk,x,rstk) { \
	if (vars.debug) { \
		for (int i=0;i<tabs;i++) putchar(' '); \
		int temp=(s-stk[0])/(sizeof(stk[0])/sizeof(int)); \
		printf("ip:%p *ip:0x%x/%d ", ip, *ip, *ip); \
		printf("%d [", temp); \
		for (int i=0; &stk[temp][i]!=(int)s; i++) { \
			printf(" 0x%x/%d", stk[temp][i], stk[temp][i]); \
		} \
		printf(" tos: 0x%x/%d |", t, t); \
		printf("] %d\n",temp); \
	} \
}

#define trace(n) \
	if (n) { \
		putchar('{'); putchar(' '); \
		char *p=(char *)ip; \
		p-=sizeof(lfa *); \
		char c=*--p; \
		c&=~0x80; \
		p-=c; \
		for (int i=0;i<c;i++) putchar(*p++); \
		putchar('\n'); \
		tabs++;\
	} else { \
		putchar('}'); putchar('\n'); \
		if (tabs>0) tabs--; \
	} \
	// fflush(stdout);
#else
#define debugstk(t,s,stk,x,rstk)
#define trace(n)
#endif

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
	const struct lfa *latest;
	unsigned char *here;
	char state;
#ifdef DEBUG
	int debug;
#endif
} vars = {
	0,
	(unsigned char *)mem,
	1
#ifdef DEBUG
	,0
#endif
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
#endif

int
main()
{
#ifdef USEDEFS
#include "latest.h"
#endif

	for (;;) {
		w=*ip++;
next:
		debugstk(tos, d, datastk, r, returnstk);
		switch (w) {
#include "prims.h"
		default : goto error;
		}
	}
error:
	putchar(w);
	return 1;
}
