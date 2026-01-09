# forth.S : initialization and glue code
#
# Copyright (c) 2023,2026 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

#define sp	R1
#define w	R5
#define tos	R6
#define dsp	R7
#define nos	R8

	.cpu 430
start:
	mov #__stack, sp
	mov #spbase, dsp
	mov #6, r15
data_copy:
	decd r15
	mov _etext(r15),state(r15)
	jnz data_copy
	call #rom
halt:
	nop

#if USEDICT
#include "prims_dict.s"
#else
#include "prims.s"
#endif

	.text

shiftleft:
	and tos, tos
	JZ 2f
	nip
1 :	rla nos
	DEC tos
	JNZ 1b
	mov nos, tos
	ret
2 :	drop
	ret

shiftright:
	and tos, tos
	JZ 2f
	nip
1 :	rra nos
	DEC tos
	JNZ 1b
	mov nos, tos
	ret
2 :	drop
	ret

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

	.comm spbase,50,1
	.comm mem,200,1
