# makefile : drive the build and test for the F16 encoding
#
# Copyright (c) 2025 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

all : forth
	./forth
forth : forth.zig
	zig build-exe forth.zig
clean:
	rm -f forth forth.o fpp.config
