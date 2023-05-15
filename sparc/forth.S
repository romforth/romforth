# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

#define ip	%l0
#define i	%l1
#define w	%l2
#define link	%i7
#define tos	%l3
#define sp	%l4
#define buf	%l5
#define temp	%l6
#define offset	%l7

	.globl _start
_start:
	set rom, ip
	set next, i
	set dstk, sp
	set iobuf, buf
	jmpl i,link
	nop
quit:
	mov 1, %g1
	mov 0, %o0
	ta 0x10

reallit:
	add sp, 4, sp
	ldub [ip], tos

	sll tos, 8, tos
	ldub [ip+1], temp
	or tos, temp, tos

	sll tos, 8, tos
	ldub [ip+2], temp
	or tos, temp, tos

	sll tos, 8, tos
	ldub [ip+3], temp
	or tos, temp, tos

	jmp i
	add ip, 4, ip

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

	.comm dstk,100
	.comm iobuf,4
