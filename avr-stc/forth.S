; forth.S : initialization and glue code
;
; Copyright (c) 2026 Charles Suresh <romforth@proton.me>
; SPDX-License-Identifier: AGPL-3.0-only
; Please see the LICENSE file for the Affero GPL 3.0 license details

	.avr8

	.set SIF=0xffff
	.set SPH=0x3e
	.set SPL=0x3d

#define TOSH r27
#define TOSL r26
#define NOSH r25
#define NOSL r24
#define YL r28
#define YH r29

	.org	0

	rjmp reset	; reset vector

	; remaining interrupt vectors go here

	.org 0x10

reset:
	; any other reset handling goes here
	jmp start

start:
	jmp rom

halt:
	ret	; unmatched ret to terminate the naken_util emulation as per docs

rom:

	ldi YL, 1	; initialize the state variable in memory
	sts state, YL	; ... to 1
	ldi YL, stk	; YL <- data stack base (assume 128 byte Internal SRAM)
	eor YH, YH	; YH <- 0

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

	.org 0
	.resb 0x60	; Register and I/O memory map region as per docs
stk:
	.resw 20	; Data stack
state:	.resb 1
here:	.resw 1
mem:	.resb 128-$
