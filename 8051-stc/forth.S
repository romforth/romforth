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
mcstk:
	.ds 10
