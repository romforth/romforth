; forth.S : initialization and glue code
;
; Copyright (c) 2025 Charles Suresh <romforth@proton.me>
; SPDX-License-Identifier: AGPL-3.0-only
; Please see the LICENSE file for the Affero GPL 3.0 license details

	.area CSEG (CODE)
start:
	mov sp, #rstk
	acall rom
	mov dptr, #0xffff
	mov a, #'s'
	movx @dptr, a
realkey:
	mov dptr, #0xffff
	mov a, #'r'
	movx @dptr, a
	movx a, @dptr
	ret
realemit:
	push a
	mov dptr, #0xffff
	mov a, #'w'
	movx @dptr, a
	pop a
	movx @dptr, a
	ret
rom:
	mov r0, #dstk
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

;--------------------------------------------------------
; Stack segment in internal ram
;--------------------------------------------------------

	.area SSEG
bank0: .ds 8
bank1: .ds 8
bank2: .ds 8
bank3: .ds 8
bits: .ds 16
rstk: .ds 80
dstk:
