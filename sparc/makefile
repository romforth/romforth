# makefile : drive the build and test for the sparc assembly code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

CC=sparc-unknown-linux-gnu-as
LD=sparc-unknown-linux-gnu-ld
all : forth
	qemu-sparc forth
forth : forth.o
	$(LD) -o forth forth.o
forth.o : forth.S
clean :
	rm -f forth.o forth
