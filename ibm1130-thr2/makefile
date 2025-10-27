# makefile : drive the build and test for the IBM 1130 assembly code
#
# Copyright (c) 2025 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

all : oneforth

oneforth : test.out

test.out : forth.out test.inp test.exp
	ibm1130 simh.cmds | grep Wait > test.out
	cmp test.out test.lst
	cmp test.ptp test.exp

forth.out : forth.asm
	asm1130 -l forth.asm 2> forth.err
	! test -s forth.err

forth.asm : forth.S rom.s
	m4 forth.S > forth.asm

rom.s : ../rom.4th ../fpp fpp.config prims.ast ../ast/genast defs.s ../ast/genbin gencode genprims
	cat ../rom.4th | ../fpp -DTESTROM -c fpp.config | ../ast/genast rom.map dict.map defs.map > rom.ast
	../ast/genbin rom.ast > rom.s
	../ast/m2 -p dc rom.s > rom.s2
	mv rom.s2 rom.s

prims.ast : ../ast/genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ../ast/genprims dict.map > prims.ast

defs.s : ../defs.4th ../fpp fpp.config prims.ast ../ast/genast ../ast/genbin gencode
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ../ast/genast -g defs.map dict.map > defs.ast
	../ast/genbin defs.ast > defs.s

test.inp : ../test.inp ../fpp fpp.config ../rest.inp
	cat ../test.inp | ../fpp -DTESTROM -c fpp.config > test.inp
	cat ../rest.inp | ../fpp -DTESTROM -c fpp.config >> test.inp

fpp.config : stepfile fpp.config.1130
	cat stepfile fpp.config.1130 > fpp.config

test.exp : ../test.expected ../fpp fpp.config
	cat ../test.expected | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.exp

clean :
	rm -f forth.lst forth.out fpp.config test.out test.inp defs.ast defs.map defs.s dict.map forth.asm prims.ast rom.ast rom.map rom.s forth.err test.ptp test.exp
