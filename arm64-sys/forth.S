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
#define rp	x21

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

pickoffsets:
	.byte pickitem0-pushpop
	.byte pickitem1-pushpop
	.byte pickitem2-pushpop

stickoffsets:
	.byte stickitem0-pushpop
	.byte stickitem1-pushpop
	.byte stickitem2-pushpop

	.align 2

realdup:
	mov ofsr, pusho
				# and then, fall thru
pushpop:
	ldrb jmprl, [ofsr,sn]
	add jmpr, jmpr, pp
	br jmpr

popitem0:
	ldp tosr, nosr, [sp], #16
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
	ldp nos, nosr, [sp], #16
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

pickitem0:
	cmp tos, #1
	bne pickitem1
	ldp tosr, nosr, [sp], #16
	mov sn, #2
	mov tos, nosr
	ret
pickitem2:
	cmp tos, #1
	bne pickitem1
	mov tos, nosr
	ret
pickitem1:
	sub tos, tos, sn
	lsl tos, tos, #3
	ldr tos, [sp,tos]
	ret

stickitem0:
	ldp tosr, nosr, [sp], #16
stickitem2:
	cmp tos, #1
	mov sn, #1
	bne stickmem
	mov nosr, tosr
	ret
stickitem1:
	mov tosr, nosr
stickmem:
	sub tos, tos, #1
	lsl tos, tos, #3
	str tosr, [sp,tos]
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

realover:
	bl realdup
	mov tos, #1
realpick:
	mov ofsr, pusho
	add ofsr, ofsr, #12
	bl pushpop
	b realnext

realstick:
	mov ofsr, popo
	add ofsr, ofsr, #12
	bl pushpop
	bl realdrop
	b realnext

reallit:
	bl realdup
	mov temp, #7
1:
	ldrb cl, [ip,temp]
	sub temp, temp, #1
	cmn temp, #1
	orr tos, c, tos, lsl #8
	b.ne 1b
	add ip, ip, #8
	b realnext

realkey:
	bl realdup
	mov w8, #63
	mov x0, #0
	mov x1, bufp
	mov x2, #1
	svc 0
	ldrb tosl, [bufp]
	b realnext

realemit:
	strb tosl, [bufp]
	mov w8, #64
	mov x0, #1
	mov x1, bufp
	mov x2, #1
	svc 0
	bl realdrop
	b realnext

realjz:
	ldrb cl, [ip]
	sxtb c, cl
	add ip, ip, #1
	cmp tos, #0
	csel c, c, xzr, eq
	add ip, ip, c
	bl realdrop
	b realnext

realjnz:
	ldrb cl, [ip]
	sxtb c, cl
	add ip, ip, #1
	cmp tos, #0
	csel c, c, xzr, ne
	add ip, ip, c
	bl realdrop
	b realnext

realj:
	ldrb cl, [ip]
	sxtb c, cl
	add ip, ip, #1
	add ip, ip, c
				# and then, fall thru
realnext:
	ldrb wl, [ip]
	add w, w, i
	add ip, ip, #1
	br w

shiftleft:
	bl realnip
	lsl nos, nos, tos
	mov tos, nos
	b realnext

shiftright:
	bl realnip
	lsr nos, nos, tos
	mov tos, nos
	b realnext

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

spswap:
	mov temp, sp
	mov sp, tos
	mov tos, temp
	b realnext

rpswap:
	mov temp, rp
	mov rp, tos
	mov tos, temp
	b realnext

realenter:
	ldr w, [ip]
	add ip, ip, #8
	str ip, [rp]
	add rp, rp, #8
	mov ip, w
	b realnext

realexit:
	sub rp, rp, #8
	ldr ip, [rp]
	b realnext

realcall:
	str ip, [rp]
	add rp, rp, #8
	mov ip, tos
	bl realdrop
	b realnext

tor:
	str tos, [rp]
	add rp, rp, #8
	bl realdrop
	b realnext

rfrom:
	bl realdup
	sub rp, rp, #8
	ldr tos, [rp]
	b realnext

realexec:
	mov w, tos
	and w, w, #0xff
	add w, w, i
	bl realdrop
	br w

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
