# makefile : drive the build and test for the 6809 assembly code
#
# Copyright (c) 2025 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

all : forth.ihx
	echo run | ucsim_m6809 -I if=rom'[0x7fff]' forth.ihx
forth.ihx : forth.rel
	sdld -i forth.rel
forth.rel : forth.S
	sdas6808 -l -o forth.S
clean:
	rm -f forth.ihx forth.rel forth.lst fpp.config
