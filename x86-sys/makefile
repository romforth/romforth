# makefile : drive the build and test for the x86 assembly syscall based code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

all : oneforth
oneforth : test.out
twoforth : test.defs
threeforth : test.dict
fourforth : test.dict
test.dict : forth_dict test.inp test.exp
	cat test.inp | ./forth_dict > test.dict
	cmp test.dict test.exp
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
forth : forth.o
	ld -o forth forth.o
forth.o : forth.S prims.s rom.s
forth_defs : forth_defs.o
	ld -o forth_defs forth_defs.o
forth_defs.o : forth_defs.S defs.s rom.s
forth_defs.S : forth.S
	cp forth.S forth_defs.S
	sed -i 's/define USEDEFS 0/define USEDEFS 1/' forth_defs.S
forth_dict : forth_dict.o
	ld -o forth_dict forth_dict.o
forth_dict.o : forth_dict.S prims_dict.s defs_dict.s rom.s
forth_dict.S : forth.S forth_defs.S rom.s
	cp forth_defs.S forth_dict.S
	sed -i 's/define USEDICT 0/define USEDICT 1/' forth_dict.S
defs_dict.s : ../defs.4th ../fpp fpp.config prims_dict.s genrom
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ./genrom -g -d defs.map dict.map > defs_dict.s
defs.s : ../defs.4th ../fpp fpp.config prims.s genrom
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ./genrom -g defs.map dict.map > defs.s
prims_dict.s : prims.s genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genprims -d dict.map > prims_dict.s
prims.s : genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genprims dict.map > prims.s
fpp.config : stepfile fpp.config.x86
	cat stepfile fpp.config.x86 > fpp.config
rom.s : ../rom.4th ../fpp fpp.config prims.s genrom defs.s
	cat ../rom.4th | ../fpp -DTESTROM -c fpp.config | ./genrom rom.map dict.map defs.map > rom.s
clean :
	rm -f forth dict.map fpp.config prims.s rom.map rom.s test.out test.inp test.exp forth.o forth_defs.S forth_defs.o forth_defs defs.s defs.map test.defs dict.s forth_dict.S latest.s defs_dict.s prims_dict.s forth_dict.o forth_dict test.dict
