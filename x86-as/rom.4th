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

here		[ here (here:h)
@		[ h
sp@!		[ x	// SP=h, x=previous value of SP
sp@!		[ h	// restore SP, since this was just for testing
drop		[

[ // This is init code, not test code, to allocate space for the return stack {
[ // First, setup RP the return stack pointer to point to the start of free
[ // memory. In this implementation, the return stack grows upward
here	[ here (here:mem)
@	[ mem
rp@!	[ x	// RP=mem, x==mem since DI was used as loadrom register pointer

here		[ x here
@		[ x mem
-		[ x-mem // should be zero in this implementation
if{		[ // not taken regression test
	'7'	[ '7'
	emit	[ > '7'
}if		[

[ // Next, use a minimal allocator to reserve mem .. mem+99 (100 bytes total)
[ // for the return stack usage
100	[ 100	// memory constrained devices can choose a smaller size
here 	[ 100 here
@	[ 100 mem
+	[ mem+100
here	[ mem+100 here
!	[ (here:mem+100) // mem .. mem+99 is now reserved for the return stack
[ // this is init code, not test code, to allocate space for the return stack }

bye
