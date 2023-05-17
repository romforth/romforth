# makefile : drive the build and test for the sparc assembly code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

AS=sparc-unknown-linux-gnu-as
LD=sparc-unknown-linux-gnu-ld
all : fourforth
oneforth : test.out
twoforth : test.defs
threeforth : test.dict
fourforth : test.dict
test.dict : forth_dict test.inp test.exp
	cat test.inp | qemu-sparc forth_dict > test.dict
	cmp test.dict test.exp
test.defs : forth_defs test.inp test.exp
	cat test.inp | perl -pe chomp | qemu-sparc forth_defs > test.defs
	cmp test.defs test.exp
test.out : forth test.inp test.exp
	cat test.inp | perl -pe chomp | qemu-sparc forth > test.out
	cmp test.out test.exp
test.inp : ../test.inp ../fpp fpp.config ../rest.inp
	cat ../test.inp | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.inp
	cat ../rest.inp | ../fpp -DTESTROM -c fpp.config >> test.inp
test.exp : ../test.expected ../fpp fpp.config
	cat ../test.expected | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.exp
forth : forth.o
	$(LD) -o forth forth.o
forth.s : forth.S prims.s rom.s
	../fix_comments rom.s
	cpp -E forth.S > forth.s
forth.o : forth.s
forth_defs : forth_defs.o
	$(LD) -o forth_defs forth_defs.o
forth_defs.o : forth_defs.s
forth_defs.S : forth.S
	cp forth.S forth_defs.S
	sed -i 's/define USEDEFS 0/define USEDEFS 1/' forth_defs.S
forth_defs.s : forth_defs.S prims.s rom.s
	../fix_comments rom.s
	../fix_comments defs.s
	cpp -E forth_defs.S > forth_defs.s
forth_dict : forth_dict.o
	$(LD) -o forth_dict forth_dict.o
forth_dict.o : forth_dict.s
forth_dict.s : forth_dict.S prims_dict.s defs_dict.s rom.s
	../fix_comments rom.s
	../fix_comments defs_dict.s
	../fix_comments prims_dict.s
	cpp -E forth_dict.S > forth_dict.s
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
fpp.config : stepfile fpp.config.sparc
	cat stepfile fpp.config.sparc > fpp.config
rom.s : ../rom.4th ../fpp fpp.config prims.s genrom defs.s
	cat ../rom.4th | ../fpp -DTESTROM -c fpp.config | ./genrom rom.map dict.map defs.map > rom.s
clean :
	rm -f forth dict.map fpp.config prims.s rom.map rom.s test.out test.inp test.exp forth.o forth_defs.S forth_defs.o forth_defs defs.s defs.map test.defs dict.s forth_dict.S latest.s defs_dict.s prims_dict.s forth_dict.o forth_dict test.dict forth.s forth_defs.s forth_dict.s
