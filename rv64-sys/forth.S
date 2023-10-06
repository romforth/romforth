# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

#		t0 (x5) is used in bye
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

realdup:
	sd tos, (dp)
	add dp, dp, 8
	ret

realdrop:
	add dp, dp, -8
	ld tos, (dp)
	ret

realj:
	lb i, (ip)
	add ip, ip, 1
	add ip, ip, i
	j realnext

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
