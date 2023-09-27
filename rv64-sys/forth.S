# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

#define ip	a0
#define i	a1
#define nr	a2

	.globl _start
_start:
	la ip, rom
	la nr, next
	call next
	li a0, 0
	li a7, 93
	ecall

next:
	lbu i, (ip)
	add ip, ip, 1
	add i, i, nr
	jr i

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
