; forth.S : initialization and glue code
;
; Copyright (c) 2026 Charles Suresh <romforth@proton.me>
; SPDX-License-Identifier: AGPL-3.0-only
; Please see the LICENSE file for the Affero GPL 3.0 license details

	.avr8

	.org	0

	rjmp reset	; reset vector

	; remaining interrupt vectors go here

	.org 0x10

reset:
	; any other reset handling goes here
	jmp start

start:
	ret	; unmatched ret to terminate the naken_util emulation as per docs
