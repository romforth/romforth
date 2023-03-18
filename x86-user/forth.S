# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

#define w	%rax
#define ip	%rsi
#define sp	%rsp
#define rp	%rbp
#define tos	%rbx
#define nos	%rcx
#define out	%rdi

	.globl main
main:
	call cold
	mov $0, %rax
	ret
cold:
	mov $rom, ip
	mov $next, w
	jmp *w

key1:
	push tos
	push w
	push ip
	call getchar
	mov w, tos
	pop ip
	pop w
	jmp next
emit1:
	push tos
	pop out
	push w
	push ip
	call putchar
	pop ip
	pop w
	pop tos
	jmp next

rfrom:
	push tos
	sub $8, rp
	mov (rp), tos
	jmp next
tor:
	mov tos, (rp)
	add $8, rp
	pop tos
	jmp next

rom:
#include "rom.s"

	.align 256
#include "prims.s"

mem:
