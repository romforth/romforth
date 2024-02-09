# forth.S : initialization and glue code
#
# Copyright (c) 2024 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

#define ip	R4
#define i	R5

	.cpu 430
start:
	br #cold
halt:
	nop
cold:
	mov #rom, ip
next:
	mov.b @ip+, i
	rla i
	add #jmptbl, i
	br @i
jmptbl:
	.skip 254,0
	.word halt
rom:
	.byte 0x7f
