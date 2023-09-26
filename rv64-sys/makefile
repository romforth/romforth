# makefile : drive the build and test for the RISC-V 64 bit assembly code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

AS=riscv64-unknown-linux-gnu-as
LD=riscv64-unknown-linux-gnu-ld

all : forth
	qemu-riscv64 forth
forth : forth.o
	$(LD) -o forth forth.o
forth.o : forth.s
	$(AS) -o forth.o forth.s
forth.s : forth.S
clean :
	rm -f forth forth.o forth.s
