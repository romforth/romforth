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
forth.zig : forth.m4 forth_zig.m4
	m4 forth.m4 > forth.zig
forth_zig.m4 : genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genprims dict.map > forth_zig.m4
rom.zig : rom.m4 rom_zig.m4
	m4 rom.m4 > rom.zig
rom_zig.m4 : ../rom.4th ../fpp fpp.config genrom patchrom code.prims
	cat ../rom.4th | ../fpp -DTESTROM -c fpp.config | ./genrom rom.map | ./patchrom > rom_zig.m4

clean :
	rm -f forth forth.o fpp.config test.out test.inp test.exp rom_zig.m4 rom.map rom.zig dict.map forth.zig forth_zig.m4 profile.names prims.m4
