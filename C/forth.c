/*
 * forth.c : inner interpreter and other glue logic
 *
 * Copyright (c) 2022-2023 Charles Suresh <romforth@proton.me>
 * SPDX-License-Identifier: AGPL-3.0-only
 * Please see the LICENSE file for the Affero GPL 3.0 license details
 */

#include <stdlib.h>	// atexit
#include <stdio.h>	// getchar putchar

void
verify() {
}

int
main() {
	static const unsigned short rom[] = {
#include "rom.h"
	};
	const unsigned short register *ip=rom;
	unsigned short i;
	int register tos;
	int datastk[100], *d=datastk;

	atexit(verify);
#include "prims.h"
}
