# makefile : drive the build and test for C code
#
# Copyright (c) 2024 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

all : fourforth

oneforth : test.out
twoforth : test.defs
threeforth : test.dict
fourforth : test.dict

test.defs : forth_defs.ihx test.inp test.exp
	cat test.inp | perl -pe chomp > test.in
	cat cmds.ucsim | ucsim_mos6502 -I in=test.in,out=test.defs,if=rom'[0x7fff]' ./forth_defs.ihx > test.log
	grep 'Stop at 0x00024a: (110) Program stopped itself' test.log > /dev/null
	cmp test.defs test.exp
test.dict : forth_dict.ihx test.inp test.exp
	cat cmds.ucsim | ucsim_mos6502 -I in=test.inp,out=test.dict,if=rom'[0x7fff]' ./forth_dict.ihx > test.log
	grep 'Stop at 0x00024a: (110) Program stopped itself' test.log > /dev/null
	cmp test.dict test.exp
test.out : forth.ihx test.inp test.exp
	cat test.inp | perl -pe chomp > test.in
	cat cmds.ucsim | ucsim_mos6502 -I in=test.in,out=test.out,if=rom'[0x7fff]' ./forth.ihx > test.log
	grep 'Stop at 0x00024a: (110) Program stopped itself' test.log > /dev/null
	cmp test.out test.exp
test.inp : ../test.inp ../fpp fpp.config ../rest.inp
	cat ../test.inp | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.inp
	cat ../rest.inp | ../fpp -DTESTROM -c fpp.config >> test.inp
test.exp : ../test.expected ../fpp fpp.config
	cat ../test.expected | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.exp
forth : forth.ihx
forth.ihx : forth.c prims.h rom.h
	sdcc -mmos6502 forth.c
forth_dict.ihx : forth_dict.c prims_dict.h rom.h defs_dict.h
	sdcc -mmos6502 forth_dict.c
forth_defs.ihx : forth_defs.c defs_dict.h rom.h
	sdcc -mmos6502 forth_defs.c
forth_defs.c : forth.c
	cp forth.c forth_defs.c
	sed -i 's/define USEDEFS 0/define USEDEFS 1/' forth_defs.c
	sed -i 's/include \"defs/include \"defs_dict/' forth_defs.c
forth_dict.c : forth.c
	cp forth.c forth_dict.c
	sed -i 's/include \"prims/include \"prims_dict/' forth_dict.c
	sed -i 's/include \"defs/include \"defs_dict/' forth_dict.c
rom.h : ../rom.4th ../fpp fpp.config prims.h genrom defs.h
	cat ../rom.4th | ../fpp -DTESTROM -c fpp.config | ./genrom rom.map dict.map defs.map | ./patchrom --sdcc > rom.h
	test -s rom.h
fpp.config : stepfile fpp.config.C
	cat stepfile fpp.config.C > fpp.config
prims.h : genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genprims dict.map > prims.h
prims_dict.h : prims.h genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genprims -d dict.map > prims_dict.h
defs.h : ../defs.4th ../fpp fpp.config prims.h genrom
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ./genrom -g defs.map dict.map | ./patchrom --sdcc > defs.h
defs_dict.h : ../defs.4th ../fpp fpp.config prims_dict.h genrom
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ./genrom -g -d defs.map dict.map | ./patchrom --sdcc > defs_dict.h
clean :
	rm -f forth.o forth test.out forth.lst rom.h rom.map fpp.config prims.h dict.map test.inp test.exp defs.h defs.map sim forth_dict forth_dict.o defs_dict.h dict.h latest.h prims_dict.h test.dict forth_dict.c test.defs forth_defs forth_defs.o forth_defs.c profile.names enum.h test.in test.log
	bash -c "rm -f forth.{asm,ihx,lk,lst,map,noi,rel,sym,mem,rs,s19}"
	bash -c "rm -f forth_defs.{asm,ihx,lk,lst,map,noi,rel,sym,mem,rs,s19}"
	bash -c "rm -f forth_dict.{asm,ihx,lk,lst,map,noi,rel,sym,mem,rst,s19}"
