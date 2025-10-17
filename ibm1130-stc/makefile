# makefile : drive the build and test for the IBM 1130 assembly code
#
# Copyright (c) 2025 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

all : forth.out
	cat simh.cmds | ibm1130 | grep Wait > test.out
	cmp test.exp test.out

forth.out : forth.asm
	asm1130 -l forth.asm

clean :
	rm -f forth.lst forth.out fpp.config test.out
