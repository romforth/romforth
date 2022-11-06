# makefile : drive the build and test for C code
#
# Copyright (c) 2022 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

all : forth
	./forth
forth : forth.c prims.h enums.h
	cc -Ofast -o forth forth.c
enums.h prims.h : code.prims genprims
	cat code.prims | ./genprims dict.map enums.h > prims.h
clean:
	rm -f forth dict.map enums.h prims.h
