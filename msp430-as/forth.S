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

	.cpu 430
start:
	jmp cold
halt:
	nop

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

	.data
	.org 32
spbase:
mem:
