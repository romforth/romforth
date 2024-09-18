# makefile : drive the build and test for Padauk 14 microcontrollers
#
# Copyright (c) 2024 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

AS=sdaspdk14
LD=sdldpdk
all : forth.ihx
	cat cmds.ucsim | ucsim_pdk forth.ihx > test.log
	grep -q 'Stop at 0x000002: (101) Halted' test.log
forth.ihx : forth.rel
	$(LD) -i $<
forth.rel : forth.s
	$(AS) -l -o $@ $<
forth.s : forth.S
	cpp -P forth.S > forth.s
clean :
	rm -f forth.rel forth.s forth.lst forth.ihx test.log fpp.config
