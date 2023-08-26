# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

#define ip	x3
#define i	x4
#define w	x5
#define wl	w5
#define bufp	x6
#define temp	x7
#define templ	w7
#define sn	x9
#define tosr	x10
#define nosr	x11
#define tos	x12
#define tosl	w12
#define pusho	x13
#define popo	x14
#define ofsr	x15
#define jmpr	x16
#define jmprl	w16
#define pp	x17
#define ssp	x18
#define c	x19
#define cl	w19
#define nos	x20
#define nosl	w20

	.globl _start
_start:
	adrp ip, rom
	add ip, ip, #rom
	adrp i, next
	add i, i, #next
	adrp bufp, buf
	add bufp, bufp, #buf
	adrp pusho, pushoffsets
	add pusho, pusho, #pushoffsets
	adrp popo, popoffsets
	add popo, popo, #popoffsets
	adrp pp, pushpop
	add pp, pp, #pushpop
	mov sn, #0
	bl cold
	mov x0, #0
	mov w8, #93
	svc #0

pushoffsets:
	.byte pushitem0-pushpop
	.byte pushitem1-pushpop
	.byte pushitem2-pushpop

popoffsets:
	.byte popitem0-pushpop
	.byte popitem1-pushpop
	.byte popitem2-pushpop

dipoffsets:
	.byte dipitem0-pushpop
	.byte dipitem1-pushpop
	.byte dipitem2-pushpop

nipoffsets:
	.byte nipitem0-pushpop
	.byte nipitem1-pushpop
	.byte nipitem2-pushpop

	.align 2

realdup:
	mov ofsr, pusho
				# and then, fall thru
pushpop:
	ldrb jmprl, [ofsr,sn]
	add jmpr, jmpr, pp
	br jmpr

popitem0:
	ldp tosr, nosr, [sp]
popitem2:
	mov tos, tosr
	mov sn, #1
	ret
popitem1:
	mov tos, nosr
	mov sn, #0
	ret

pushitem2:
	stp tosr, nosr, [sp, #-16]!
pushitem0:
	mov nosr, tos
	mov sn, #1
	ret
pushitem1:
	mov tosr, tos
	mov sn, #2
	ret

nipitem0:
	ldp nos, nosr, [sp]
	mov sn, #1
	ret
nipitem1:
	mov nos, nosr
	mov sn, #0
	ret
nipitem2:
	mov nos, tosr
	mov sn, #1
	ret

dipitem2:
	stp tosr, nosr, [sp, #-16]!
dipitem0:
	mov nosr, nos
	mov sn, #1
	ret
dipitem1:
	mov tosr, nos
	mov sn, #2
	ret

realdrop:
	mov ofsr, popo
	b pushpop

realnip:
	mov ofsr, popo
	add ofsr, ofsr, #6
	b pushpop

realdip:
	mov ofsr, pusho
	add ofsr, ofsr, #6
	b pushpop

reallit:
	mov temp, #7
1:
	ldrb cl, [ip,temp]
	sub temp, temp, #1
	cmn temp, #1
	orr tos, c, tos, lsl #8
	b.ne 1b
	add ip, ip, #8
	ret

realkey:
	mov w8, #63
	mov x0, #0
	mov x1, bufp
	mov x2, #1
	svc 0
	ldrb tosl, [bufp]
	ret

realemit:
	strb tosl, [bufp]
	mov w8, #64
	mov x0, #1
	mov x1, bufp
	mov x2, #1
	svc 0
	ret

realjz:
	ldrb cl, [ip]
	sxtb c, cl
	add ip, ip, #1
	cmp tos, #0
	csel c, c, xzr, eq
	add ip, ip, c
	ret

realjnz:
	ldrb cl, [ip]
	sxtb c, cl
	add ip, ip, #1
	cmp tos, #0
	csel c, c, xzr, ne
	add ip, ip, c
	ret

realj:
	ldrb cl, [ip]
	add ip, ip, #1
	add ip, ip, c
				# and then, fall thru
realnext:
	ldrb wl, [ip]
	add w, w, i
	add ip, ip, #1
	br w

store:
	bl realnip
	str nos, [tos]
	bl realdrop
	b realnext

cstore:
	bl realnip
	strb nosl, [tos]
	bl realdrop
	b realnext

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

	.align 2

#if USEDICT
#include "prims_dict.s"
#else
#include "prims.s"
#endif

	.comm buf, 4
	.comm mem, 1024
