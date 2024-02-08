# makefile : drive the build and test for the MSP430 assembly code
#
# Copyright (c) 2024 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

CC=msp430-gcc

all : forth run_mspdebug
	./run_mspdebug forth > test.log 2>&1
	grep 'Breakpoint 0 triggered' test.log > /dev/null

forth : forth.S

clean :
	rm -f forth test.log test.out
