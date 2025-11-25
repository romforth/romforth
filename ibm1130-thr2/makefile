# makefile : drive the build and test for the IBM 1130 assembly code
#
# Copyright (c) 2025 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

all : fourforth

oneforth : test.out
twoforth : test.defs
threeforth : test.dict
fourforth : threeforth

test.out : forth.out test.inp test.exp
	(echo "load forth.out" ; cat simh.cmds) | ibm1130 | grep Wait > test.out
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
	cat ../test.inp | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.inp
	cat ../rest.inp | ../fpp -DTESTROM -c fpp.config >> test.inp

fpp.config : stepfile fpp.config.1130
	cat stepfile fpp.config.1130 > fpp.config

test.exp : ../test.expected ../fpp fpp.config
	cat ../test.expected | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.exp

test.defs : forth_defs.out test.inp test.exp
	(echo "load forth_defs.out" ; cat simh.cmds) | ibm1130 | grep Wait > test.defs
	cmp test.defs test.lst
	cmp test.ptp test.exp

test.dict : forth_dict.out test.inp test.exp
	(echo "load forth_dict.out" ; cat simh.cmds) | ibm1130 | grep Wait > test.dict
	cmp test.dict test.lst
	cmp test.ptp test.exp

forth_defs.out : forth_defs.asm
	asm1130 -l forth_defs.asm 2> forth.err
	! test -s forth.err

forth_dict.out : forth_dict.asm
	asm1130 -l forth_dict.asm 2> forth.err
	! test -s forth.err

forth_defs.asm : forth_defs.S rom.s defs.asm
	m4 forth_defs.S > forth_defs.asm

forth_dict.asm : forth_dict.S prims_dict.s defs_dict.s rom.s defs.asm
	m4 -DUSEDICT forth_dict.S > forth_dict.asm

forth_defs.S : forth.S
	cp forth.S forth_defs.S

forth_dict.S : forth.S
	cp forth.S forth_dict.S

prims_dict.s : dict.map ../ast/genprims code.prims ../fpp fpp.config ../ast/gendict gencode
	../ast/gendict prims.ast dict.map > prims_dict.s
	[ -L dict.s ] || ln -s prims_dict.s dict.s

dict.map : prims.ast

defs_dict.s : dict.map ../defs.4th ../fpp fpp.config ../ast/genast ../ast/genbin gencode
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ../ast/genast -g -d defs.map dict.map > defs_dict.ast
	../ast/genbin -d defs_dict.ast > defs_dict.s

defs.asm : defs.s
	../ast/m2 -p dc defs.s > defs.asm

clean :
	rm -f forth.lst forth.out fpp.config test.out test.inp defs.ast defs.map defs.s dict.map forth.asm prims.ast rom.ast rom.map rom.s forth.err test.ptp test.exp defs.asm forth_defs.S forth_defs.asm forth_defs.lst forth_defs.out test.defs rom.s2 defs_dict.ast defs_dict.s dict.s forth_dict.S forth_dict.asm forth_dict.lst latest.s prims_dict.ast prims_dict.s test.dict forth_dict.out
