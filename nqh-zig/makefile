# makefile : drive the build and test for the "not quite Huffman" encoding
#
# Copyright (c) 2024 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

all : forth
	./forth
forth : forth.zig
	zig fmt forth.zig
	zig build-exe forth.zig

clean :
	rm -f forth forth.o fpp.config
