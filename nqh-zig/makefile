# makefile : drive the build and test for the "not quite Huffman" encoding
#
# Copyright (c) 2024 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

oneforth : test.out

test.out : forth test.inp test.exp
	cat test.inp | perl -pe chomp | ./forth > test.out
	cmp test.out test.exp
test.inp : ../test.inp ../fpp fpp.config ../rest.inp
	cat ../test.inp | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.inp
	cat ../rest.inp | ../fpp -DTESTROM -c fpp.config >> test.inp
test.exp : ../test.expected ../fpp fpp.config
	cat ../test.expected | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.exp
fpp.config : stepfile fpp.config.nqh
	cat stepfile fpp.config.nqh > fpp.config
forth : forth.zig rom.zig
	zig fmt forth.zig
	zig build-exe forth.zig

clean :
	rm -f forth forth.o fpp.config test.out test.inp test.exp
