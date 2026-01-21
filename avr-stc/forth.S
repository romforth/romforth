; forth.S : initialization and glue code
;
; Copyright (c) 2026 Charles Suresh <romforth@proton.me>
; SPDX-License-Identifier: AGPL-3.0-only
; Please see the LICENSE file for the Affero GPL 3.0 license details

	.avr8

	.set SIF=0xffff

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
