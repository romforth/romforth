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
	call read
	pcadd a
decode:
#include "prims.s"

init:
	clear ip
	mov a, #datastack
	mov dp, a
	ret
read:
	inc ip
	mov a, ip
	pcadd a
rom:
#include "rom.s"

	.area PREG (ABS)
	.org 0
	.ds 16 ; reserve some space for the call stack
p:	.ds 1
ip:	.ds 1
dp:	.ds 1
tos:	.ds 1
	.ds 16 ; reserve some space for the data stack
datastack:
