# makefile : drive the build and test for the 6809 assembly code
#
# Copyright (c) 2025 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

AS=sdas6808
ASFLAGS=-l -o
LD=sdld -i
all : oneforth
oneforth : test.out
twoforth : test.defs
threeforth : test.dict
fourforth : test.dict
test.dict : forth_dict.ihx test.inp test.exp
	cp test.inp test.in
	cat cmds.ucsim | ucsim_m6809 -I in=test.in,out=test.dict,if=rom'[0x7fff]' forth_dict > test.log
	grep 'Stop at 0x000088: (110) Program stopped itself' test.log > /dev/null
	cmp test.dict test.exp
test.defs : forth_defs.ihx test.inp test.exp
	cat test.inp | perl -pe chomp > test.in
	cat cmds.ucsim | ucsim_m6809 -I in=test.in,out=test.defs,if=rom'[0x7fff]' forth_defs.ihx > test.log
	grep 'Stop at 0x000088: (110) Program stopped itself' test.log > /dev/null
	cmp test.defs test.exp
test.out : forth.ihx test.inp test.exp
	cat test.inp | perl -pe chomp > test.in
	touch test.out
	cat cmds.ucsim | ucsim_m6809 -I in=test.in,out=test.out,if=rom'[0x7fff]' forth.ihx > test.log
	grep 'Stop at 0x000088: (110) Program stopped itself' test.log > /dev/null
	cmp test.out test.exp
test.inp : ../test.inp ../fpp fpp.config ../rest.inp
	cat ../test.inp | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.inp
	cat ../rest.inp | ../fpp -DTESTROM -c fpp.config >> test.inp
test.exp : ../test.expected ../fpp fpp.config
	cat ../test.expected | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.exp
forth.ihx : forth.rel
	$(LD) forth.rel
forth.s : forth.S prims.s rom.s
	../fix_comments rom.s
	cpp -P forth.S > forth.s
forth.rel : forth.s
	$(AS) $(ASFLAGS) forth.s
forth_defs.ihx : forth_defs.rel
	$(LD) forth_defs.rel
forth_defs.rel : forth_defs.s
	$(AS) $(ASFLAGS) forth_defs.s
forth_defs.S : forth.S
	cp forth.S forth_defs.S
	sed -i 's/define USEDEFS 0/define USEDEFS 1/' forth_defs.S
forth_defs.s : forth_defs.S prims.s rom.s
	../fix_comments rom.s
	../fix_comments defs.s
	./m2 defs.s > defs.s2
	mv defs.s2 defs.s
	cpp -P forth_defs.S > forth_defs.s
forth_dict.ihx : forth_dict.rel
	$(LD) forth_dict.rel
forth_dict.rel : forth_dict.s
	$(AS) $(ASFLAGS) forth_dict.s
forth_dict.s : forth_dict.S prims_dict.s defs_dict.s rom.s
	../fix_comments rom.s
	../fix_comments defs_dict.s
	../fix_comments prims_dict.s
	cpp -P forth_dict.S > forth_dict.s
forth_dict.S : forth.S forth_defs.S
	cp forth_defs.S forth_dict.S
	sed -i 's/define USEDICT 0/define USEDICT 1/' forth_dict.S
defs_dict.s : ../defs.4th ../fpp fpp.config ../ast/genast
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ../ast/genast -g -d defs.map dict.map > defs_dict.ast
defs.s : ../defs.4th ../fpp fpp.config prims.s ../ast/genast
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ../ast/genast -g defs.map dict.map > defs.ast
	./genbin defs.ast > defs.s
prims_dict.s : prims.s genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genprims -d dict.map > prims_dict.s
prims.s : genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genprims dict.map > prims.s
fpp.config : stepfile fpp.config.6809
	cat stepfile fpp.config.6809 > fpp.config
rom.s : ../rom.4th ../fpp fpp.config prims.s ../ast/genast defs.s
	cat ../rom.4th | ../fpp -DTESTROM -c fpp.config | ../ast/genast rom.map dict.map defs.map > rom.ast
	./genbin rom.ast > rom.s
	./m2 rom.s > rom.s2
	mv rom.s2 rom.s
clean :
	rm -f forth.ihx dict.map fpp.config prims.s rom.map rom.s rom.ast test.out test.inp test.exp forth.rel forth_defs.S forth_defs.rel forth_defs.ihx forth_defs.lst defs.s defs.ast defs.map test.defs dict.s forth_dict.S latest.s defs_dict.s prims_dict.s forth_dict.rel forth_dict.ihx forth_dict.lst test.dict forth.s forth_defs.s forth_dict.s test.in test.log forth.lst forth.lk forth.map forth.noi
