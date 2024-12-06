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

realover:
	jsr realdup
	lda #1
realpick:
	sta temp
	txa
	clc
	sbc temp
	tay
	lda dstk,y
	rts

realstick:
	sta temp
	txa
	clc
	sbc temp
	tay
	jsr realdrop
	sta dstk,y
	jsr realdrop
	rts

swapsp:
	stx temp
	tsx
	stx temp1
	tax
	txs
	lda temp1
	ldx temp
	; now restore it so the return will work
	stx temp
	tax
	txs
	ldx temp
	rts

trampoline:
	pha
	jsr realdrop
	pha
	jsr realdrop
	rts		; which results in a "call" to the pushed address

shiftleft:
	tay
	jsr realdrop
	cpy #0
	beq retleft
leftshift:
	asl a
	dey
	bne leftshift
retleft:
	rts

shiftright:
	tay
	jsr realdrop
	cpy #0
	beq retright
rightshift:
	lsr a
	dey
	bne rightshift
retright:
	rts

rom:
	ldx #0
	ldy #state
	lda #1
	sta mem,y
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
here:	.db 0
state:	.ds 1
dstk:
	.ds 32

	.area BSS
temp:	.ds 1
temp1:	.ds 1
mem:	.ds 1		; reserve the first byte for "here"
	.ds 1		; reserve the second byte for "state"
	.ds 1024
