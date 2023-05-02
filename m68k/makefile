# makefile : drive the build and test for the m68k assembly code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

CC=m68k-unknown-linux-gnu-as
LD=m68k-unknown-linux-gnu-ld
all : forth
forth : forth.o
	$(LD) -o forth forth.o
	qemu-m68k forth
forth.o : forth.S
clean :
	rm -f forth.o forth
