# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

	.globl main
main:
	call cold
	mov $0, %rax
	ret
cold:
	mov $rom, %rsi
	mov $next, %rax
	jmp *%rax

rom:
#include "rom.s"

	.align 256
#include "prims.s"

mem:
