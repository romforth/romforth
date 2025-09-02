; forth.S : initialization and glue code
;
; Copyright (c) 2025 Charles Suresh <romforth@proton.me>
; SPDX-License-Identifier: AGPL-3.0-only
; Please see the LICENSE file for the Affero GPL 3.0 license details

	.area	CODEIVT (ABS)
	.org	0xfffe
	.dw	start

	.area	CODE
start:
	.db 0xbd	; jsr
	.dw rom		; rom
	.db 0x86	; lda
	.db #'s'	; 's'
	.db 0xB7	; sta
	.dw 0x7fff	; 0x7fff
rom:
	.db 0x39	; rts
