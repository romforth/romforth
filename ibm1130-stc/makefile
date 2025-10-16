# makefile : drive the build and test for the IBM 1130 assembly code
#
# Copyright (c) 2025 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

all : forth.out
	(echo "load forth.out" ; echo go) | ibm1130 > test.out
	grep -q 'Wait, IAR: 00000001 (0000 ?00     0000   )' test.out

forth.out : forth.asm
	asm1130 -l forth.asm

clean :
	rm -f forth.lst forth.out fpp.config test.out
