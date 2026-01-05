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

	call rom
	stopsys

bye:
	popaf
	ret

rom:
	call bye
