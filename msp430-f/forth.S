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

realnext:
	mov.b @ip+, i
	rla i
	add #jmptbl, i
	br @i

jmptbl:
	.skip 254,0
	.word bye

rom:
	.byte 0x7f

#define USEDEFS 0
#define USEDICT 0

#if USEDICT
#include "prims_dict.s"
#else
#include "prims.s"
#endif
