# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

#define ip	%a0
#define w	%d0
#define tos	%d1
#define nos	%d2
#define temp	%d7
#define cache	%a1
#define i	%a5
#define rp	%a6
#define sp	%a7

	.globl _start
_start:
	bra cold

	.align 2
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
tor:
	move.l tos, (rp)+
	move.l (sp)+, tos
	jmp next
rfrom:
	move.l tos, -(sp)
	move.l -(rp), tos
	jmp next
realenter:
	move.l (ip)+, i
	move.l ip, (rp)+
	move.l i, ip
	bra inner
lshift:
	move.l (sp)+, nos
	exg tos, nos
	lsl.l nos, tos
	bra inner
rshift:
	move.l (sp)+, nos
	exg tos, nos
	lsr.l nos, tos
	bra inner

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

	.align 2
#if USEDICT
#include "prims_dict.s"
#else
#include "prims.s"
#endif

	.comm buf,4
	.comm mem,2048
