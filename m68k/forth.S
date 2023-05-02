# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

	.globl _start
_start:
	move.l #rom, %a0
next:
	move.b (%a0)+, %d0
	jmp next(%d0)
bye:
	move.l #247, %d0
	move.l #0, %d1
	trap #0

rom:
	.byte bye-next
