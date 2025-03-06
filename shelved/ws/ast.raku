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
		|	'if{'	<ast> '}if'
		|	'loop{'	<ast> '}while{' <ast> '}loop'
		|	'loop{'	<ast> '}until{' <ast> '}loop'
		|	'loop{'	<ast> '}loop'
		|	'for{'	<ast> '}for'
		|	<opcodes>
	}
	rule opcodes {
		<opcode>+ %% ' '
	}
	token opcode {
			sp\@\!
		|	rp\@\!
		|	\>r
		|	r\>
		|	\<\<
		|	\>\>
		|	\>\=
		|	\<\=
		|	0\=
		|	c\@
		|	p\@
		|	\@
		|	c\!
		|	p\!
		|	c\,
		|	s\,
		|	\,
		|	\:
		|	\;
		|	\<
		|	\>
		|	\!
		|	\+
		|	\-
		|	\&
		|	\|
		|	\^
		|	\~
		|	\#\-\d+
		|	\#\d+
		|	\-\d+
		|	\'.\'
		|	\w+
	}
}

say ast.parse(slurp);
