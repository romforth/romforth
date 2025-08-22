; forth.S : initialization and glue code
;
; Copyright (c) 2025 Charles Suresh <romforth@proton.me>
; SPDX-License-Identifier: AGPL-3.0-only
; Please see the LICENSE file for the Affero GPL 3.0 license details

	.area CSEG (CODE)
start:
	mov sp, #mcstk
	acall rom
	mov dptr, #0xffff
	mov a, #'s'
	movx @dptr, a
rom:
bye:
	ret

;--------------------------------------------------------
; Stack segment in internal ram
;--------------------------------------------------------

	.area SSEG
mcstk:
	.ds 10
