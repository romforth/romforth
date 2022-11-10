# makefile : drive the build and test for C code
#
# Copyright (c) 2022 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

all : forth
	cat ../test.inp | ./forth > test.out
	cmp test.out test.expected
forth : forth.c prims.h enums.h rom.h
	cc -Ofast -o forth forth.c
enums.h prims.h : code.prims genprims
	cat code.prims | ./genprims dict.map enums.h > prims.h
rom.h	: genstc rom.4th prims.h enums.h
	cat rom.4th | ./genstc rom.map dict.map > rom.h
clean:
	rm -f forth dict.map enums.h prims.h rom.map rom.h test.out