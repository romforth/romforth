[ // rom.4th : arch neutral (for the most part) test cases and init code
[
[ // Copyright (c) 2022 Charles Suresh <romforth@proton.me>
[ // SPDX-License-Identifier: AGPL-3.0-only
[ // Please see the LICENSE file for the Affero GPL 3.0 license details

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

[ // verify nested branches
1		[
if{		[ // taken
	1	[ 1
	if{	[ // taken
	}else{	[ // not taken regression test
	}if	[
}if

[ // verify inc/dec
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

bye
