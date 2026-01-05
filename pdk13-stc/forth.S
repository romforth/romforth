; forth.S : initialization and glue code
;
; Copyright (c) 2026 Charles Suresh <romforth@proton.me>
; SPDX-License-Identifier: AGPL-3.0-only
; Please see the LICENSE file for the Affero GPL 3.0 license details

start:
	goto cold

cold:
	mov     a, 0
	mov.io  sp, a
	call init
	call rom
	stopsys
init:
	mov a, #datastack
	mov dp, a
	mov rp, a
	mov a, #mem
	mov here, a
	mov a, #1
	mov state, a
	ret

#if USEDICT
#include "prims_dict.s"
#else
#include "prims.s"
#endif

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

	.area   PREG (ABS)
	.org 0
	.ds 16 ; reserve some space for the call stack
p:	.ds 2
dp:	.ds 1
nos: 	.ds 1
sa:	.ds 1  ; save/restore for the accumulator
	.ds 16 ; reserve some space for the data stack
datastack:
	.ds 16 ; reserve some space for the return stack
rp:	.ds 1
here:	.dw mem
state:	.ds 1
mem:	.ds 1 ; reserve some space for alloc
