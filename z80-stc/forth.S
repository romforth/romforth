; forth.S : initialization and glue code
;
; Copyright (c) 2024 Charles Suresh <romforth@proton.me>
; SPDX-License-Identifier: AGPL-3.0-only
; Please see the LICENSE file for the Affero GPL 3.0 license details

#define w	hl
#define tos	de
#define tosh	d
#define tosl	e
#define dp	iy
#define nos	bc
#define nosh	b
#define nosl	c
#define mp	ix

cold:
	ld sp, #0xffff
	ld dp, #stack
	call rom
	halt

dpswap:			; [ x			w:ow dp:d
	push w		; [ x	|    ow ]
	push dp		; [ x	|  d ow ]
	pop w		; [ x	|    ow ]	w:dp
	ex tos, w	; [ d	|    ow ]	w:x
	push w		; [ d	|  x ow ]
	pop dp		; [ d	|    ow ]	dp:x
	pop w		; [ d
	ret

realdip:
	ld (dp), nosl
	inc dp
	ld (dp), nosh
	inc dp
	ret

realnip:
	dec dp
	ld nosh, (dp)
	dec dp
	ld nosl, (dp)
	ret

realdup:
	ld (dp), tosl
	inc dp
	ld (dp), tosh
	inc dp
	ret

realdrop:
	dec dp
	ld tosh, (dp)
	dec dp
	ld tosl, (dp)
	ret

realkey:
	call realdup
	ld w, #0x7fff
	ld (w), #'r'
	ld tosl, (w)
	ret

realemit:
	ld w, #0x7fff
	ld (w), #'w'
	ld (w), tosl
	call realdrop
	ret

invert:
	ld a, tosh
	cpl
	ld tosh, a
	ld a, tosl
	cpl
	ld tosl, a
	ret

negate:
	call invert
	inc tos
	ret

realadd:
	call realnip
	ld a, nosl
	add a, tosl
	ld tosl, a
	ld a, nosh
	adc a, tosh
	ld tosh, a
	ret

realand:
	call realnip
	ld a, nosl
	and a, tosl
	ld tosl, a
	ld a, nosh
	and a, tosh
	ld tosh, a
	ret

realor:
	call realnip
	ld a, nosl
	or a, tosl
	ld tosl, a
	ld a, nosh
	or a, tosh
	ld tosh, a
	ret

realxor:
	call realnip
	ld a, nosl
	xor a, tosl
	ld tosl, a
	ld a, nosh
	xor a, tosh
	ld tosh, a
	ret

realpick:
	push w
	push dp
	pop w
	ld a, tosl
	INC a
	add a, a
	ld tosl, a
	sbc w, tos
	ld tosl, (w)
	INC w
	ld tosh, (w)
	pop w
	ret

realstick:
	push w
	push dp
	pop w
	ld a, tosl
	INC a
	add a, a
	ld tosl, a
	sbc w, tos
	call realnip
	ld (w), nosl
	INC w
	ld (w), nosh
	pop w
	call realdrop
	ret

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

stack	: .ds 100
mem	: .ds 2048
