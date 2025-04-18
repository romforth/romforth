; forth.S : initialization and glue code
;
; Copyright (c) 2024 Charles Suresh <romforth@proton.me>
; SPDX-License-Identifier: AGPL-3.0-only
; Please see the LICENSE file for the Affero GPL 3.0 license details

start:
	mov a, 0
	mov.io sp, a
	call init
repl:
	call read0
	call decode
	goto repl

bank1:
	popaf
	clear ip
	inc bank
repl1:
	call read1
	call decode
	goto repl1

decode:
	pcadd a
#include "prims.s"

init:
	clear ip
	mov a, #datastack
	mov dp, a
	mov a, #mem
	mov here, a
	mov a, #1
	mov state, a
	mov bank, a
	ret

read:
	mov a, bank
	pcadd a
	goto read0
	goto read1
	goto read2
	; TODO: everything else should panic

shiftleft:
	pushaf
	call drop
	popaf
sl1:
	sl tos
	dzsn a
	goto sl1
	ret

shiftright:
	pushaf
	call drop
	popaf
sr1:
	sr tos
	dzsn a
	goto sr1
	ret

bank2:
	popaf
	clear ip
	inc bank
repl2:
	call read2
	call decode
	goto repl2

read0:
	inc ip
	mov a, ip
	pcadd a
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

	.area PREG (ABS)
	.org 0
	.ds 16 ; reserve some space for the call stack
p:	.ds 1
ip:	.ds 1
dp:	.ds 1
here:	.ds 1
tos:	.ds 1
	.ds 17	; reserve some space for the data stack
datastack:	; pad 1 byte: '?ASlink-Warning-Invalid address for instruction'
nos:	.ds 1
state:	.ds 1
bank:	.ds 1
	.bndry 2
rp:	.ds 1
mem:	.ds 100 ; reserve some space for alloc
