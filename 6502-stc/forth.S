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
	lda #'s'
	sta 0x7fff
