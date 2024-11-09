; forth.S : initialization and glue code
;
; Copyright (c) 2024 Charles Suresh <romforth@proton.me>
; SPDX-License-Identifier: AGPL-3.0-only
; Please see the LICENSE file for the Affero GPL 3.0 license details

	.area	CODEIVT (ABS)
	.org	0xfffa
	.dw	start
	.dw	start
	.dw	start

	.area	ZP
	.ds	0x100
	.area	STACK
	.ds	0x100

	.area	CODE
start:
	ldx #0xff
	txs
	jsr rom
	lda #'s'
	sta 0x7fff

realemit:
	pha
	lda #'w'
	sta 0x7fff
	pla
	sta 0x7fff
realdrop:
	dex
	lda dstk,x
	rts

realdup:
	sta dstk,x
	inx
	rts

realkey:
	jsr realdup
	lda #'r'
	sta 0x7fff
	lda 0x7fff
	rts

realneg:
	eor #0xff
	clc
	adc #0x1
	rts

realnip:
	dex
	; ldy dstk,x	; ucsim treats this as an illegal instruction
	pha
	lda dstk,x
	tay
	pla
	rts

realdip:
	; sty dstk,x	; ucsim treats this as an illegal instruction
	pha
	tya
	sta dstk,x
	pla
	inx
	rts

rom:
	ldx #0
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

	.area DATA
dstk:
	.ds 32
