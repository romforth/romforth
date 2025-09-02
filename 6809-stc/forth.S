; forth.S : initialization and glue code
;
; Copyright (c) 2025 Charles Suresh <romforth@proton.me>
; SPDX-License-Identifier: AGPL-3.0-only
; Please see the LICENSE file for the Affero GPL 3.0 license details

	.area	CODEIVT (ABS)
	.org	0xfffe
	.dw	start

	.area	ZP
	.ds	100		; reserve 100 bytes for the return stack (grows low)
rstk:

	.area	CODE
start:
	.db 0x10, 0xCE	; lds
	.dw rstk	; #rstk
	.db 0xbd	; jsr
	.dw rom		; rom
	.db 0x86	; lda
	.db #'s'	; 's'
	.db 0xB7	; sta
	.dw 0x7fff	; 0x7fff
realemit:
	.db 0x34, 2	; pshs a
	.db 0x86	; lda
	.db #'w'	; 'w'
	.db 0xB7	; sta
	.dw 0x7fff	; 0x7fff
	.db 0x35, 2	; puls a
	.db 0xB7	; sta
	.dw 0x7fff	; 0x7fff
	.db 0x39	; rts
realkey:
	.db 0x86	; lda
	.db #'r'	; 'w'
	.db 0xB7	; sta
	.dw 0x7fff	; 0x7fff
	.db 0xB6	; lda
	.dw 0x7fff	; 0x7fff
	.db 0x39	; rts
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
