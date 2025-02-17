/*
 * ast.y : Yacc/Bison grammar to parse the AST using whitespace delimiters
 *
 * Copyright (c) 2025 Charles Suresh <romforth@proton.me>
 * SPDX-License-Identifier: AGPL-3.0-only
 * Please see the LICENSE file for the Affero GPL 3.0 license details
 */

%{

#include <stdio.h>

int
yylex() {
	getchar();
}

void
yyerror(char *s) {
	printf("%s\n", s);
}

int
main() {
	yyparse();
}

%}

%token NUMBER

%%

ast	: atomic ;

atomic	:
	| atoms
	;

atoms	: atom
	| atoms atom
	;

atom	: 'B' { printf("[_]Opcode{"); } quarks '\n' { printf("};\n"); }
	| 'C' ast '\n' ast '\n'
	| 'W' ast '\n' ast '\n'
	| 'U' ast '\n' ast '\n'
	| 'L' ast '\n'
	;

quarks	: quark { printf("%d",$1); }
	| quarks ' ' { printf(","); } quark { printf("%d",$4); }
	;

quark	: digits {$$=$1;} ;

digits	: digit { $$=$1;}
	| digits digit { $$=$1*10+$2; }
	;

digit	: '0' { $$=0; }
	| '1' { $$=1; }
	| '2' { $$=2; }
	| '3' { $$=3; }
	| '4' { $$=4; }
	| '5' { $$=5; }
	| '6' { $$=6; }
	| '7' { $$=7; }
	| '8' { $$=8; }
	| '9' { $$=9; }
	;
