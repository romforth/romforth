# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

#define w	%eax
#define ip	%esi
#define sp	%esp
#define rp	%ebp
#define tos	%ebx
#define nos	%ecx
#define out	%edi

	.globl main
main:
	call cold
	mov $0, %eax
	ret
cold:
	mov $rom, ip
	mov $next, w
	jmp *w

pfetch:
	cmp $0xFF70, tos
	jne 1f
	mov $0x80, tos
	jmp next
key1:
	push tos
1:	push w
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
	push out
	call putchar
	pop out
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
	lodsl
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
	add w, ip
	pop w
	jmp next

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

	.comm mem,2048
