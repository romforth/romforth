/*
 * forth.c : inner interpreter and other glue logic
 *
 * Copyright (c) 2022 Charles Suresh <romforth@proton.me>
 * SPDX-License-Identifier: AGPL-3.0-only
 * Please see the LICENSE file for the Affero GPL 3.0 license details
 */

#include <stdlib.h>	// exit

typedef unsigned char byte;

enum {
#include "enums.h"
};

byte rom[]={
	HLT,
};

byte w, *ip=rom;

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
