# forth.S : initialization and glue code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

	.globl _start
_start:
	mov 1, %g1
	mov 0, %o0
	ta 0x10
