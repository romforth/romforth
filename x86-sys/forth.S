# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

	.globl _start
_start:
	mov $rom, %rsi
	mov $next, %rax
	jmp *%rax

	.align 256
next:
	lodsb
	jmp *%rax
bye:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
rom:
	.byte bye-next
