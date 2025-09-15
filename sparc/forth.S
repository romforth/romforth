# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

#define ip	%l0
#define i	%l1
#define w	%l2
#define link	%i7
#define tos	%l3
#define sp	%l4
#define buf	%l5
#define temp	%l6
#define offset	%l7
#define nos	%i0
#define addr	%i1
#define rp	%i2

	.globl _start
_start:
	set rom, ip
	set next, i
	set dstk, sp
	set iobuf, buf
	jmpl i,link
	nop
quit:
	mov 1, %g1
	mov 0, %o0
	ta 0x10

reallit:
	add sp, 4, sp
	ldub [ip], tos

	sll tos, 8, tos
	ldub [ip+1], temp
	or tos, temp, tos

	sll tos, 8, tos
	ldub [ip+2], temp
	or tos, temp, tos

	sll tos, 8, tos
	ldub [ip+3], temp
	or tos, temp, tos

	jmp i
	add ip, 4, ip

key1:
	st tos, [sp]
	add sp, 4, sp

	mov 3, %g1
	mov 0, %o0
	mov buf, %o1
	mov 1, %o2
	ta 0x10

	mov %g0, tos
	jmp i
	ldub [buf], tos

emit1:
	stub tos, [buf]

	mov 4, %g1
	mov 1, %o0
	mov buf, %o1
	mov 1, %o2
	ta 0x10

	add sp, -4, sp
	jmp i
	ld [sp], tos

jcommon:
	ld [sp], tos
	jmp i
	inc ip

cfetch:
	jmp i
	ldub [tos], tos

realpick:
	sll tos, 2, tos
	sub sp, tos, tos
fetch:
	mov tos, addr
	ldub [addr], tos

	sll tos, 8, tos
	ldub [addr+1], temp
	or tos, temp, tos

	sll tos, 8, tos
	ldub [addr+2], temp
	or tos, temp, tos

	sll tos, 8, tos
	ldub [addr+3], temp
	jmp i
	or tos, temp, tos

cstore:
	mov tos, addr
	ld [sp-4], nos
	ld [sp-8], tos
	add sp, -8, sp
	jmp i
	stb nos, [addr]

store:
	mov tos, addr
	ld [sp-4], nos
	ld [sp-8], tos
	add sp, -8, sp
	stb nos, [addr+3]

	srl nos, 8, nos
	stb nos, [addr+2]

	srl nos, 8, nos
	stb nos, [addr+1]

	srl nos, 8, nos
	jmp i
	stb nos, [addr]

jdrop:
	ld [sp], tos
branch:
	ldsb [ip], offset
	inc ip
	jmp i
	add ip, offset, ip
brz:
	be jdrop
	add sp, -4, sp
	b jcommon
	nop
brnz:
	bne jdrop
	add sp, -4, sp
	b,a jcommon

realstick:
	sll tos, 2, tos
	sub sp, tos, tos
	ld [sp-4], temp
	st temp, [tos]
	add sp, -8, sp
	jmp i
	ld [sp], tos

spswap:
	mov tos, sp
	jmp i
	mov temp, tos
rpswap:
	mov tos, rp
	jmp i
	mov temp, tos
realxor:
	ld [sp], nos
	jmp i
	xor tos, nos, tos
realor:
	ld [sp], nos
	jmp i
	or tos, nos, tos
realand:
	ld [sp], nos
	jmp i
	and tos, nos, tos
realadd:
	ld [sp], nos
	jmp i
	add tos, nos, tos
realnip:
	add sp, -4, sp
	jmp i
	ld [sp], nos
realdip:
	st nos, [sp]
	jmp i
	add sp, 4, sp
tor:
	st tos, [rp]
	add rp, 4, rp
	jmp i
	ld [sp], tos
fromr:
	st tos, [sp]
	add sp, 4, sp
	sub rp, 4, rp
	jmp i
	ld [rp], tos
realexec:
	mov tos, w
	and w, 0xff, w
	jmp i+w
	ld [sp], tos
realenter:
	ldub [ip], w

	sll w, 8, w
	ldub [ip+1], temp
	or w, temp, w

	sll w, 8, w
	ldub [ip+2], temp
	or w, temp, w

	sll w, 8, w
	ldub [ip+3], temp
	or w, temp, w

	add ip, 4, ip
	st ip, [rp]
	add rp, 4, rp
	mov w, ip
	jmp i
	clr w
realexit:
	sub rp, 4, rp
	jmp i
	ld [rp], ip
realcall:
	st ip, [rp]
	add rp, 4, rp
	mov tos, ip
	add sp, -4, sp
	jmp i
	ld [sp], tos
lshift:
	add sp, -4, sp
	ld [sp], nos
	jmp i
	sll nos, tos, tos
rshift:
	add sp, -4, sp
	ld [sp], nos
	jmp i
	srl nos, tos, tos
realover:
	st tos, [sp]
	ld [sp-4], tos
	jmp i
	add sp, 4, sp

#if USEDICT
#include "prims_dict.s"
#else
#include "prims.s"
#endif

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

	.comm dstk,100
	.comm iobuf,4
	.comm mem,2048
