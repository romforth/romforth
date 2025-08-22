; forth.S : initialization and glue code
;
; Copyright (c) 2025 Charles Suresh <romforth@proton.me>
; SPDX-License-Identifier: AGPL-3.0-only
; Please see the LICENSE file for the Affero GPL 3.0 license details

	.area CSEG (CODE)
start:
	mov dptr, #0xffff
	mov a, #'s'
	movx @dptr, a
