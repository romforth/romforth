# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

#define ip	x3
#define i	x4
#define w	x5
#define wl	w5
#define bufp	x6
#define temp	w7

	.globl _start
_start:
	adrp ip, rom
	add ip, ip, #rom
	adrp i, next
	add i, i, #next
	adrp bufp, buf
	add bufp, bufp, #buf
	bl next
	mov x0, #0
	mov w8, #93
	svc #0

#if USEDICT
#include "prims_dict.s"
#else
#include "prims.s"
#endif

rom:

#include "rom.s"

#define USEDEFS 0
#define USEDICT 0

#if USEDEFS
#if USEDICT
#include "dict.s"
#include "defs_dict.s"
#else
#include "defs.s"
#endif
#endif

	.comm buf, 4
