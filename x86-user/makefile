# makefile : drive the build and test for the x86 assembly userland code
#
# Copyright (c) 2023 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

all : oneforth
oneforth : test.out
test.out : forth test.inp test.exp
	cat test.inp | perl -pe chomp | ./forth > test.out
	cmp test.out test.exp
test.inp : ../test.inp ../fpp fpp.config ../rest.inp
	cat ../test.inp | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.inp
test.exp : ../test.expected ../fpp fpp.config
	cat ../test.expected | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.exp
forth.o : forth.S prims.s rom.s
prims_dict.s : prims_dict.S
prims.s : genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genprims dict.map > prims.s
fpp.config : stepfile fpp.config.x86
	cat stepfile fpp.config.x86 > fpp.config
rom.s : ../rom.4th ../fpp fpp.config prims.s genrom
	cat ../rom.4th | ../fpp -DTESTROM -c fpp.config | ./genrom rom.map dict.map > rom.s
clean :
	rm -f forth dict.map fpp.config prims.s rom.map rom.s test.out test.inp test.exp forth.o
