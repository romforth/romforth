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
#include "rom.h"
};

byte w, *ip=rom;

typedef short cell;

cell tos;

void
exec(byte w) {
	switch(w) {
#include "prims.h"
	}
}

int
main() {
	for(;;) {
		exec(w=*ip++);
	}
}
