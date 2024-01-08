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

cold:
	ld sp, #0xffff
	ld dp, #stack
	call rom
	halt

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

stack:    .ds 100
