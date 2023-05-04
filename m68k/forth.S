# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

	.globl _start
_start:

#if USEDICT
#include "prims_dict.s"
#else
#include "prims.s"
#endif

key1:
	move.l tos, -(sp)
	move.l #3, w
	move.l #0, tos
	move.l #buf, nos
	move.l #1, %d3
	trap #0
	move.b buf, tos
	jmp next

emit1:
	move.b tos, buf
	move.l #4, w
	move.l #1, tos
	move.l #buf, nos
	move.l #1, %d3
	trap #0
	move.l (sp)+, tos
	jmp next
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

	.comm buf,4
	.comm mem,2048
