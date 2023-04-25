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

	.globl _start
_start:
	mov $rom, %rsi
	mov $next, %rax
	jmp *%rax

pfetch:
	cmp $0xFF70, tos
	jne 1f
	mov $0x80, tos
	jmp next
key1:
	push tos
1:	push w
	push ip
	#call getchar
	mov $3, w
	mov $0, tos
	mov $buf, nos
	mov $1, %rdx
	int $0x80
	mov nos, tos
	mov (tos), tos
	and $0xff, tos
	pop ip
	pop w
	jmp next
emit1:
	push tos
	mov $buf, tos
	pop (tos)
	push w
	push ip
	#call putchar
	mov $4, w
	mov $1, tos
	mov $buf, nos
	mov $1, %rdx
	int $0x80
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

realenter:
	mov w, out
	lodsq
	mov ip, (rp)
	add $8, rp
	mov w, ip
	mov out, w
	jmp next

realcall:
	mov ip, (rp)
	add $8, rp
	mov tos, ip
	pop tos
	jmp next

cfetch:
	mov (tos), %bl
	and $0xFF, tos
	jmp next

branch:
	push w
	xor w, w
	lodsb
	movsx %al, %eax
	movsxd %eax, %rax
	add w, ip
	pop w
	jmp next
bye1:
	mov $1, %eax
	mov $0, %ebx
	int $0x80

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

	.align 256
#if USEDICT
#include "prims_dict.s"
#else
#include "prims.s"
#endif

mem:
