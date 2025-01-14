# makefile : drive the build and test for the F16 encoding
#
# Copyright (c) 2025 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

all: oneforth

twoforth : test.defs
oneforth : test.out

test.defs : forth_defs test.inp test.exp
	cat test.inp | perl -pe chomp | ./forth_defs > test.defs
	cmp test.defs test.exp
test.out : forth test.inp test.exp
	cat test.inp | perl -pe chomp | ./forth > test.out
	cmp test.out test.exp
test.inp : ../test.inp ../fpp fpp.config ../rest.inp
	cat ../test.inp | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.inp
	cat ../rest.inp | ../fpp -DTESTROM -c fpp.config >> test.inp
test.exp : ../test.expected ../fpp fpp.config
	cat ../test.expected | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.exp
fpp.config : stepfile fpp.config.f16
	cat stepfile fpp.config.f16 > fpp.config
forth_defs : forth_defs.zig rom.zig
	zig fmt forth_defs.zig
	zig build-exe forth_defs.zig
forth_defs.zig : forth.zig
	cp forth.zig forth_defs.zig
defs_zig.m4 : ../defs.4th ../fpp fpp.config prims_dict.zig genrom
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ./genrom -g -d defs.map dict.map | ./patchrom > defs_zig.m4
prims_dict.zig : genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genf16 opc.m4 | ./genprims -d dict.map > prims_dict.zig
forth : forth.zig rom.zig
	zig build-exe forth.zig
prims.zig : genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genf16 opc.m4 | ./genprims dict.map > prims.zig
rom.zig : rom.m4 bytes.m4
	m4 rom.m4 > rom.zig
bytes.m4 : prims.zig
	cat ../rom.4th | ../fpp -DTESTROM -c fpp.config | ./genrom rom.map dict.map | ./patchrom > bytes.m4
rom_zig.m4 : ../rom.4th ../fpp fpp.config genrom patchrom code.prims
	cat ../rom.4th | ../fpp -DTESTROM -c fpp.config | ./genrom rom.map dict.map defs.map | ./patchrom > rom_zig.m4

clean :
	rm -f forth forth.o fpp.config test.out test.inp test.exp opc.m4 rom_zig.m4 rom.map rom.zig dict.map profile.names bytes.m4 prims.zig prims.m4 defs.map defs_zig.m4 latest.h prims_dict.zig test.defs forth_defs forth_defs.o forth_defs.m4 forth_defs.zig dict.zig headers.list defs_enum.zig func.zig
