# makefile : drive the build and test for the "not quite Huffman" encoding
#
# Copyright (c) 2024-2025 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

twoforth : test.defs
oneforth : test.out

test.defs : forth_defs test.inp test.exp
	cat test.inp | perl -pe chomp | ./forth_defs > test.defs
	cmp test.defs test.exp
	rm -f headers.list
test.out : forth test.inp test.exp
	cat test.inp | perl -pe chomp | ./forth > test.out
	cmp test.out test.exp
	rm -f headers.list
test.inp : ../test.inp ../fpp fpp.config ../rest.inp
	cat ../test.inp | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.inp
	cat ../rest.inp | ../fpp -DTESTROM -c fpp.config >> test.inp
test.exp : ../test.expected ../fpp fpp.config
	cat ../test.expected | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.exp
fpp.config : stepfile fpp.config.nqh
	cat stepfile fpp.config.nqh > fpp.config
forth_defs : forth_defs.zig rom.zig
	zig fmt forth_defs.zig
	zig build-exe forth_defs.zig
forth_defs.zig : forth_defs.m4 forth_zig.m4 defs_zig.m4 rom.zig
	m4 forth_defs.m4 > forth_defs.zig
forth_defs.m4 : forth.m4
	cp forth.m4 forth_defs.m4
defs_zig.m4 : ../defs.4th ../fpp fpp.config prims_dict.zig genrom
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ./genrom -g -d defs.map dict.map | ./patchrom > defs_zig.m4
prims_dict.zig : genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genprims -d dict.map > prims_dict.zig
forth : forth.zig rom.zig
	zig fmt forth.zig
	zig build-exe forth.zig
forth.zig : forth.m4 forth_zig.m4
	m4 forth.m4 > forth.zig
forth_zig.m4 : genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genprims dict.map > forth_zig.m4
rom.zig : rom.m4 prims.m4 defs_enum.zig dict.zig defs_zig.m4 rom_zig.m4 func.zig
	m4 rom.m4 > rom.zig
rom_zig.m4 : ../rom.4th ../fpp fpp.config genrom patchrom code.prims
	cat ../rom.4th | ../fpp -DTESTROM -c fpp.config | ./genrom rom.map dict.map defs.map | ./patchrom > rom_zig.m4

clean :
	rm -f forth forth.o fpp.config test.out test.inp test.exp rom_zig.m4 rom.map rom.zig dict.map forth.zig forth_zig.m4 profile.names prims.m4 defs.map defs_zig.m4 latest.h prims_dict.zig test.defs forth_defs forth_defs.o forth_defs.m4 forth_defs.zig dict.zig headers.list defs_enum.zig func.zig
