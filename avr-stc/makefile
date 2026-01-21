# makefile : drive the build and test for the AVR assembly code
#
# Copyright (c) 2026 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

AS=naken_asm
ASFLAGS=-l -o

all : test.log
	grep ' ! 0x0014: 0x9508 ret' test.log > /dev/null

test.log : forth.ihx
	naken_util -avr8 -run forth.ihx > test.log

forth.ihx : forth.S
	$(AS) $(ASFLAGS) forth.ihx forth.S > /dev/null

clean :
	rm -f forth.ihx forth.lst test.log fpp.config
