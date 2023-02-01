# makefile : drive the build and test for C code
#
# Copyright (c) 2022 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

CFLAGS=-Os
oneforth : test.out
twoforth : test.out
threeforth : test.dict
fourforth : test.dict
test.dict : forth_dict test.inp test.exp
	cat test.inp | perl -pe chomp | ./forth_dict > test.dict
	cmp test.dict test.exp
test.out : forth test.inp test.exp
	cat test.inp | perl -pe chomp | ./forth > test.out
	cmp test.out test.exp
test.inp : ../test.inp ../fpp fpp.config ../rest.inp
	cat ../test.inp | ../fpp -DTESTROM -c fpp.config > test.inp
	cat ../rest.inp | ../fpp -DTESTROM -c fpp.config >> test.inp
test.exp : ../test.expected ../fpp fpp.config
	cat ../test.expected | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.exp
forth : forth.o
forth.o : forth.c prims.h rom.h
forth_dict : forth_dict.o
forth_dict.o : forth_dict.c prims_dict.h rom.h
forth_dict.c : forth.c
	cp forth.c forth_dict.c
	sed -i 's/include \"prims/include \"prims_dict/' forth_dict.c
	sed -i 's/include \"defs/include \"defs_dict/' forth_dict.c
rom.h : ../rom.4th ../fpp fpp.config prims.h genrom
	cat ../rom.4th | ../fpp -DTESTROM -c fpp.config | ./genrom rom.map dict.map > rom.h
	test -s rom.h
fpp.config : stepfile fpp.config.C
	cat stepfile fpp.config.C > fpp.config
prims.h : genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genprims dict.map > prims.h
prims_dict.h : prims.h genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genprims -d dict.map > prims_dict.h
defs.h : ../defs.4th ../fpp fpp.config prims.h genrom
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ./genrom defs.map dict.map > defs.h
defs_dict.h : ../defs.4th ../fpp fpp.config prims_dict.h genrom
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ./genrom -d defs.map dict.map > defs_dict.h
clean :
	rm -f forth.o forth test.out forth.lst rom.h rom.map fpp.config prims.h dict.map test.inp test.exp defs.h defs.map sim forth_dict forth_dict.o defs_dict.h dict.h latest.h prims_dict.h test.dict forth_dict.c
