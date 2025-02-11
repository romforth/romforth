#!/usr/bin/perl6

# ast.raku : Perl6/Raku grammar to parse the AST using "Perl nested array"
#
# Copyright (c) 2025 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

grammar ast {
	rule TOP {
		^ <ast> $
	}
	rule ast {
		'[' <atom>* ']'
	}
	rule atom {
			'[' 'bb'	<opcodes> ']'
		|	'[' 'cond'	<ast> <ast> ']'
		|	'[' 'while'	<ast> <ast> ']'
		|	'[' 'until'	<ast> <ast> ']'
		|	'[' 'loop'	<ast> ']'
	}
	rule opcodes {
		<opcode>+ %% ','
	}
	token opcode {
		\w+
	}
}
say ast.parse("[]");
say ast.parse("[[bb 42]]");
say ast.parse("[[bb 42,1]]");
say ast.parse("[
	[bb 42,1]
	[cond [[bb 12]] [[bb 23]]]
]");
say ast.parse("[
	[bb 42,1]
	[cond [[bb 12]] [[bb 23]]]
	[while [[bb 12]] [[bb 23]]]
]");
say ast.parse("[
	[bb 42,1]
	[cond [[bb 12]] [[bb 23]]]
	[while [[bb 12]] [[bb 23]]]
	[until [[bb 12]] [[bb 23]]]
]");
say ast.parse("[
	[bb 42,1]
	[cond [[bb 12]] [[bb 23]]]
	[while [[bb 12]] [[bb 23]]]
	[until [[bb 12]] [[bb 23]]]
	[loop [[bb 12, 23]]]
]");
say ast.parse("[
	[bb foo, bar]
	[cond [[bb foo]] [[bb bar]]]
	[while [[bb foo]] [[bb bar]]]
	[until [[bb foo]] [[bb bar]]]
	[loop [[bb foo, bar, baz]]]
]");
