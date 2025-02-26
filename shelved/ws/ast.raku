#!/usr/bin/perl6

# ast.raku : Perl6/Raku grammar to directly parse romforth
#
# Copyright (c) 2025 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

grammar ast {
	rule TOP {
		^ <ast> $
	}
	rule ast {
		<atom>*
	}
	rule atom {
			'if{'	<ast> '}else{' <ast> '}if'
		|	'loop{'	<ast> '}while{' <ast> '}loop'
		|	'loop{'	<ast> '}until{' <ast> '}loop'
		|	'loop{'	<ast> '}loop'
		|	<opcodes>
	}
	rule opcodes {
		<opcode>+ %% ' '
	}
	token opcode {
		\w+
	}
}
say ast.parse("");
say ast.parse("bb 42");
say ast.parse("bb 42 1");
say ast.parse('
if{
	bb 42 1
}else{
	bb 12 23
}if
');
say ast.parse('
	bb 42 1
	if{ bb 12 }else{ bb 23 }if
	loop{ bb 12 }while{ bb 23 }loop
');
say ast.parse('
	bb 42 1
	if{ bb 12 }else{ bb 23 }if
	loop{ bb 12 }while{ bb 23 }loop
	loop{ bb 12 }until{ bb 23 }loop
');
say ast.parse('
	bb 42 1
	if{ bb 12 }else{ bb 23 }if
	loop{ bb 12 }while{ bb 23 }loop
	loop{ bb 12 }until{ bb 23 }loop
	loop{ bb 12 23 }loop
');
say ast.parse('
	bb foo bar
	if{ bb foo }else{ bb bar }if
	loop{ bb foo }while{ bb bar }loop
	loop{ bb foo }until{ bb bar }loop
	loop{ bb foo bar baz }loop
');
