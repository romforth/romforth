# makefile : drive the build and test for the Z80 assembly code
#
# Copyright (c) 2024 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

AS=sdasz80
ASFLAGS=-l
LD=sdldz80
all : fourforth
oneforth : test.out
twoforth : test.defs
threeforth : test.dict
fourforth : test.dict
test.dict : forth_dict.ihx test.inp test.exp
	cp test.inp test.in
	cat cmds.ucsim | ucsim_z80 -I in=test.in,out=test.dict,if=rom'[0x7fff]' forth_dict > test.log
	grep 'Stop at 0x00000b: (101) Halted' test.log > /dev/null
	cmp test.dict test.exp
test.defs : forth_defs.ihx test.inp test.exp
	cat test.inp | perl -pe chomp > test.in
	cat cmds.ucsim | ucsim_z80 -I in=test.in,out=test.defs,if=rom'[0x7fff]' forth_defs.ihx > test.log
	grep 'Stop at 0x00000b: (101) Halted' test.log > /dev/null
	cmp test.defs test.exp
test.out : forth.ihx test.inp test.exp
	cat test.inp | perl -pe chomp > test.in
	touch test.out
	cat cmds.ucsim | ucsim_z80 -I in=test.in,out=test.out,if=rom'[0x7fff]' forth.ihx > test.log
	grep 'Stop at 0x00000b: (101) Halted' test.log > /dev/null
	cmp test.out test.exp
test.inp : ../test.inp ../fpp fpp.config ../rest.inp
	cat ../test.inp | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.inp
	cat ../rest.inp | ../fpp -DTESTROM -c fpp.config >> test.inp
test.exp : ../test.expected ../fpp fpp.config
	cat ../test.expected | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.exp
forth.ihx : forth.rel
	$(LD) -i forth.rel
forth.s : forth.S prims.s rom.s
	../fix_comments rom.s
	cpp -P forth.S | m4 > forth.s
forth.rel : forth.s
	sdasz80 -l -o forth.s
forth_defs.ihx : forth_defs.rel
	$(LD) -i forth_defs.rel
forth_defs.rel : forth_defs.s
	sdasz80 -l -o forth_defs.s
forth_defs.S : forth.S
	cp forth.S forth_defs.S
	sed -i 's/define USEDEFS 0/define USEDEFS 1/' forth_defs.S
forth_defs.s : forth_defs.S prims.s rom.s
	../fix_comments rom.s
	../fix_comments defs.s
	cpp -P forth_defs.S | m4 > forth_defs.s
forth_dict.ihx : forth_dict.rel
	$(LD) -i forth_dict.rel
forth_dict.rel : forth_dict.s
	sdasz80 -l -o forth_dict.s
forth_dict.s : forth_dict.S prims_dict.s defs_dict.s rom.s
	../fix_comments rom.s
	../fix_comments defs_dict.s
	../fix_comments prims_dict.s
	cpp -P forth_dict.S | m4 > forth_dict.s
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
fpp.config : stepfile fpp.config.z80
	cat stepfile fpp.config.z80 > fpp.config
rom.s : ../rom.4th ../fpp fpp.config prims.s genrom defs.s
	cat ../rom.4th | ../fpp -DTESTROM -c fpp.config | ./genrom rom.map dict.map defs.map > rom.s
clean :
	rm -f forth.ihx dict.map fpp.config prims.s rom.map rom.s test.out test.inp test.exp forth.rel forth_defs.S forth_defs.rel forth_defs.ihx forth_defs.lst defs.s defs.map test.defs dict.s forth_dict.S latest.s defs_dict.s prims_dict.s forth_dict.rel forth_dict.ihx forth_dict.lst test.dict forth.s forth_defs.s forth_dict.s test.in test.log forth.lst
