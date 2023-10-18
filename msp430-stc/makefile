# makefile : drive the build and test for the MSP430 STC assembly code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

CC=msp430-gcc

all : forth
	./run_mspdebug forth
forth : forth.S
	$(CC) -o forth forth.S
clean :
	rm -f forth fpp.config
