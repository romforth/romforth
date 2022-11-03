[ // rom.4th : arch neutral (for the most part) test cases and init code
[
[ // Copyright (c) 2022 Charles Suresh <romforth@proton.me>
[ // SPDX-License-Identifier: AGPL-3.0-only
[ // Please see the LICENSE file for the Affero GPL 3.0 license details

[ // init code goes outside the TESTROM flag
[ // test code goes inside the TESTROM flag

key	[ c
dup	[ c c
emit	[ c
drop	[
'o'	[ 'o'
emit	[ > 'o'
0		[ 0
if{		[ // not taken regression test
	'~'	[ '~'
	emit	[ > '~'
}if		[
1		[ 1
if{		[ // taken
}else{		[ // not taken regression test
	'!'	[ '!'
	emit	[ > '!'
}if		[

1		[ 1
dec		[ 0
if{		[ // not taken regression test
	'@'	[ '@'
	emit	[ > '@'
}if		[
-1		[ -1
inc		[ 0
if{		[ // not taken regression test
	'#'	[ '#'
	emit	[ > '#'
}if		[

1		[ 1
neg		[ -1
inc		[ 0
if{		[ // not taken regression test
	'$'	[ '$'
	emit	[ > '$'
}if		[
-1		[ -1
inv		[ 0
if{		[ // not taken regression test
	'%'	[ '%'
	emit	[ > '%'
}if		[

0 1		[ 0 1
nip		[ 1	// nos=0
dup		[ 1 1
dip		[ 1 0 1	// ie tuck == nip dup dip
dec		[ 1 0 0
if{		[ 1 0 // not taken regression test
	'^'	[ 1 0 '^'
	emit	[ 1 0 > '^'
}if		[ 1 0
if{		[ 1 // not taken regression test
	'&'	[ 1 '&'
	emit	[ 1 > '&'
}if		[ 1
dec		[ 0
if{		[ // not taken regression test
	'*'	[ '*'
	emit	[ > '*'
}if		[

1 2 +		[ 3
3 -		[ 0
if{		[ // not taken regression test
	'('	[ '('
	emit	[ > '('
}if		[

1 2 &		[ 0
if{		[ // not taken regression test
	')'	[ ')'
	emit	[ > ')'
}if		[

1 2 |		[ 3
3 -		[ 0
if{		[ // not taken regression test
	'_'	[ '_'
	emit	[ > '_'
}if		[

-1 0 ^		[ -1
inc		[ 0
if{		[ // not taken regression test
	'+'	[ '+'
	emit	[ > '+'
}if		[

0 1 2		[ 0 1 2
2drop		[ 0
if{		[ // not taken regression test
	'|'	[ '|'
	emit	[ > '|'
}if		[

1 2		[ 1 2
swap		[ 2 1
-		[ 1
dec		[ 0
if{		[ // not taken regression test
	'\'	[ '\'
	emit	[ > '\'
}if

4 2 <<		[ 16
64 2 >>		[ 16 16
-		[ 0
if{		[ // not taken regression test
	'='	[ '='
	emit	[ > '='
}if

100		[ 100
@		[ 0x0CBF
-0xCBF		[ 0x0CBF -0x0CBF
+		[ 0
if{		[ // not taken regression test
	'-'	[ '-'
	emit	[ > '-'
}if		[

here		[ here (here:h)
@		[ h
1234		[ h 1234
here		[ h 1234 here
!		[ h (here:1234)
here		[ h here
@		[ h 1234
-1234		[ h 1234 -1234
+		[ h 0
if{		[ h // not taken regression test
	'0'	[ h '0'
	emit	[ h > '0'
}if		[ h
here		[ h here
!		[ (here:h)

state		[ state (state:b)
c@		[ b
123		[ b 123
state		[ b 123 state
c!		[ b (state:123)
state		[ b state
c@		[ b 123
-123		[ b 123 -123
+		[ b 0
if{		[ b // not taken regression test
	'9'	[ b '9'
	emit	[ b > '9'
}if		[ b
state		[ b state
c!		[ (state:b)

3 2		[ 3 2
1 pick		[ 3 2 3 // over
-3		[ 3 2 3 -3
+		[ 3 2 0
if{		[ 3 2 // not taken regression test
	'8'	[ 3 2 '8'
	emit	[ 3 2 > '8'
}if		[ 3 2
2drop		[

0x3f8		[ 0x3f8	// serial port #1
dup		[ 0x3f8 0x3f8
p@		[ 0x3f8 'h'
swap		[ 'h' 0x3f8
p!		[ > 'h'

bye
