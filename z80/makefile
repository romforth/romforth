# makefile : drive the build and test for the Z80 assembly code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

all : forth.ihx
	cat cmds.ucsim | /isodevice/bin/ucsim_z80 -S in=in,out=out forth.ihx
forth.ihx : forth.rel
	sdldz80 -i forth.rel
forth.rel : forth.s
	sdasz80 -l -o forth.s
forth.s : forth.S
	cpp -P forth.S > forth.s
clean :
	rm -f forth.s forth.ihx forth.rel forth.lst forth
