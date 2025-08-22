# makefile : drive the build and test for the 8051 assembly code
#
# Copyright (c) 2025 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

AS=sdas8051
ASFLAGS=-l -o
LD=sdld -i
all : forth.ihx
	echo 'run' | ucsim_51 -I if=xram'[0xffff]' forth.ihx
forth.ihx : forth.rel
	$(LD) forth.rel
forth.rel : forth.S
	$(AS) $(ASFLAGS) forth.S
clean:
	rm -f forth.ihx forth.lst forth.rel fpp.config
