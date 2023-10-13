# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

#		t0 (x5) is used in bye
#define rp	t1
#		t1 (x6)
#define nos	t2
#		t2 (x7)
#define dp	s0
#		s1 (x8)
#define tos	s1
#		s1 (x9)
#		a0 (x10) is used for the fd in the write syscall
#		a1 (x11) is used for bufp
#		a2 (x12) is used for the byte count in the write syscall
#define ip	a3
#		a3 (x13)
#define i	a4
#		a4 (x14)
#define nr	a5
#		a5 (x15)

	.globl _start
_start:
	la dp, datastack
	la a1, bufp
	la ip, rom
	la nr, next
	jal x5, next
	li a0, 0
	li a7, 93
	ecall

reallit:
	call realdup
	ld tos, (ip)
	add ip, ip, 8
# fall thru
realnext:
	lbu i, (ip)
	add ip, ip, 1
	add i, i, nr
	jr i

spfetchstore:
	mv a0, dp
	mv dp, tos
	mv tos, a0
	j realnext

rpfetchstore:
	mv a0, rp
	mv rp, tos
	mv tos, a0
	j realnext

tor:
	sd tos, (rp)
	add rp, rp, 8
	call realdrop
	j realnext

fromr:
	call realdup
	add rp, rp, -8
	ld tos, (rp)
	j realnext

realcall:
	sd ip, (rp)
	add rp, rp, 8
	mv ip, tos
	call realdrop
	j realnext

realenter:
	ld i, (ip)
	add ip, ip, 8
	sd ip, (rp)
	add rp, rp, 8
	mv ip, i
	j realnext

realexit:
	add rp, rp, -8
	ld ip, (rp)
	j realnext

realexec:
	andi tos, tos, 0xff
	add i, tos, nr
	call realdrop
	jr i

realdup:
	sd tos, (dp)
	add dp, dp, 8
	ret

realdrop:
	add dp, dp, -8
	ld tos, (dp)
	ret

realnip:
	add dp, dp, -8
	ld nos, (dp)
	ret

realdip:
	sd nos, (dp)
	add dp, dp, 8
	j realnext

realjz:
	bne tos, x0, 1f
realj:
	lb i, (ip)
	add ip, ip, i
1:
	add ip, ip, 1
	call realdrop
	j realnext
realjnz:
	beq tos, x0, 1b
	j realj

realkey:
	call realdup
	li a7, 63
	li a0, 0
	li a2, 1
	ecall
	lbu tos, (a1)
	j realnext

realemit:
	sb tos, (a1)
	li a7, 64
	li a0, 1
	li a2, 1
	ecall
	call realdrop
	j realnext

realand:
	call realnip
	and tos, tos, nos
	j realnext

realor:
	call realnip
	or tos, tos, nos
	j realnext

realxor:
	call realnip
	xor tos, tos, nos
	j realnext

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
	.comm bufp, 4
	.comm datastack, 200
	.comm mem, 4096
