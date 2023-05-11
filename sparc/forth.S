# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

	.globl _start
_start:
	sethi %hi(rom), %l0
	add %l0, %lo(rom), %l0
	sethi %hi(next), %l1
	add %l1, %lo(next), %l1
next:
	jmp %l1+%l2
	ldub [%l0], %l2
bye:
	mov 1, %g1
	mov 0, %o0
	ta 0x10
rom:
	.byte bye-next
