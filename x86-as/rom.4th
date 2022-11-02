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

bye
