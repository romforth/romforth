# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

#define sp	R1
#define ip	R4
#define w	R5
#define tos	R6
#define nos	R7
#define rp	R8
#define nr	R9

	.cpu 430
start:
	mov #spbase, sp
	call #cold
halt:
	nop
init:
	mov #0, r15
	mov #linkage, nr
data_copy:
	mov _unexpected_+2(r15), __data_start(r15)
	incd r15
	cmp #4, r15
	jnz data_copy
	ret
linkage:
	decd rp
	mov ip, @rp
	pop ip
	br @ip+
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

#if USEDICT
#include "prims_dict.s"
#else
#include "prims.s"
#endif

	.org 32
spbase:
mem:
