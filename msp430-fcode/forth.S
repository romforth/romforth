# forth.S : initialization and glue code
#
# Copyright (c) 2024 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

#define sp	R1
#define ip	R4
#define i	R5
#define w	R6
#define tos	R7
#define tmp	R8
#define nos	R9

	.cpu 430
start:
	mov #spbase, sp
	mov #rom, ip
	mov #0, r15 ; count must be even
data_copy:
	mov _unexpected_+2(r15), __data_start(r15)
	incd r15
	cmp #6, r15
	jnz data_copy

realnext:
	mov.b @ip+, i
	rla i
	add #jmptbl, i
	br @i

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

rom:

#include "rom.s"

#if USEDICT
#include "prims_dict.s"
#else
#include "prims.s"
#endif

	.org 50
spbase:
mem:
