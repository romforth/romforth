# forth.S : initialization and glue code
#
# Copyright (c) 2024 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

#define ip	R4
#define i	R5

	.cpu 430
start:
	mov #rom, ip
next:
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

#if USEDICT
#include "prims_dict.s"
#else
#include "prims.s"
#endif

rom:

#include "rom.s"
