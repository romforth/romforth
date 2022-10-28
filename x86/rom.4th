	[ x < c	// x == some random value in the bx register
key	[ c
dup	[ c c
dup	[ c c c
2drop	[ c
dup	[ c c
dup	[ c c c
neg	[ c c -c
+	[ c 0
+	[ c
dup	[ c c
&	[ c:c&c
dup	[ c c
|	[ c:c|c
dup	[ c c
dup	[ c c c
^	[ c 0
|	[ c
dup	[ c c
dup	[ c c c
-	[ c 0
inc	[ c 1
swap	[ 1 c
+	[ c+1
dec	[ c
dup	[ c c
neg	[ c -c
neg	[ c c
inv	[ c ~c
inv	[ c c
nip	[ c
dip	[ c c
emit	[ c > c
'o'	[ c 'o'
emit	[ c > 'o'
drop	[
114	[ 114 // ascii 'r'
dup	[ 114 114
dup	[ 114 114 114
dup	[ 114 114 114 114
dup	[ 114 114 114 114 114
2 <<	[ 114 114 114 114 114*4
-	[ 114 114 114 -114*3
+	[ 114 114 -114*2
+	[ 114 -114
-	[ 114*2
1 >>	[ 114
emit	[ > 'r'
0x100	[ 0x100
@	[ 0x0CBF
0x0CBF	[ 0x0CBF 0x0CBF
dup	[ 0x0CBF 0x0CBF 0x0CBF
here	[ 0x0CBF 0x0CBF 0x0CBF here (here:mem)
@	[ 0x0CBF 0x0CBF 0x0CBF mem
swap	[ 0x0CBF 0x0CBF mem 0x0CBF
here	[ 0x0CBF 0x0CBF mem 0x0CBF here
!	[ 0x0CBF 0x0CBF mem (here:0x0CBF)
swap	[ 0x0CBF mem 0x0CBF
dup	[ 0x0CBF mem 0x0CBF 0x0CBF
here	[ 0x0CBF mem 0x0CBF 0x0CBF here
@	[ 0x0CBF mem 0x0CBF 0x0CBF 0x0CBF
-	[ 0x0CBF mem 0x0CBF 0
+	[ 0x0CBF mem 0x0CBF
swap	[ 0x0CBF 0x0CBF mem
here	[ 0x0CBF 0x0CBF mem here
!	[ 0x0CBF 0x0CBF (here:mem)
-	[ 0
inc	[ 1
state	[ 1 state
c!	[ (state:1)
state	[ state
c@	[ 1
dec	[ 0
't'	[ 0 't'
+	[ 't'
emit	[ > 't'
0x3f8	[ 0x3f8	// serial port #1
dup	[ 0x3f8 0x3f8
p@	[ 0x3f8 'h'
swap	[ 'h' 0x3f8
p!	[ > 'h'

here	[ here (here:mem)
@	[ mem
sp@!	[ x	// SP=mem, x==previous value of SP
sp@!	[ mem	// restore SP, since this was just for testing
drop	[

[ // This is init code, not test code, to allocate space for the return stack {
[ // First, setup RP the return stack pointer to point to the start of free
[ // memory. In this implementation, the return stack grows upward
here	[ here (here:mem)
@	[ mem
rp@!	[ x	// RP=mem, x==mem since DI was used as loadrom register pointer
here	[ x here
@	[ x mem
-	[ x-mem // should be zero in this implementation
drop	[ assert?

[ // Next, use a minimal allocator to reserve mem .. mem+99 (100 bytes total)
[ // for the return stack usage
100	[ 100	// memory constrained devices can choose a smaller size
here 	[ 100 here
@	[ 100 mem
+	[ mem+100
here	[ mem+100 here
!	[ (here:mem+100) // mem .. mem+99 is now reserved for the return stack
[ // this is init code, not test code, to allocate space for the return stack }

32	[ ' '
>r	[	| ' '	] (mem:32) // mem .. mem+99 was reserved earlier
r>	[ ' '	|	]
emit	[ > ' '

'r'	[ 'r'
lit	[ 'r' // push the next 2 bytes which will be escaped by lit at runtime
emit	[ 'r' emit
lit	[ 'r' lit|emit // escaped by the above lit and ignored by below exec
exec	[ > 'r'

testdef  [ > 'o'

testnest [ r
call     [ > 'm'

	[ < ' '
getc	[ ' '
emit	[ > ' '

1	[ 1 < '!'
echon	[ > '!'

0		[ 0
if{		[ // not taken regression test
	'!'	[ '!'
	emit	[ > '!'
}if

1		[ 1
if{		[ // taken
}else{		[ // not taken regression test
	'@'	[ '@'
	emit	[ > '@'
}if

1 2 		[ 1 2
1 pick		[ 1 2 1 // over
dec		[ 1 2 0
if{		[ 1 2 // not taken regression test
	'#'	[ 1 2 '#'
	emit	[ 1 2 > '#'
}if		[ 1 2

3 4		[ 1 2 3 4
over		[ 1 2 3 4 3
3 -		[ 1 2 3 4 0
if{		[ 1 2 3 4 // not taken regression test
	'$'	[ 1 2 3 4 '$'
	emit	[ 1 2 3 4 > '$'
}if

third		[ 1 2 3 4 2
2 -		[ 1 2 3 4 0
if{		[ 1 2 3 4 // not taken regression test
	'%'	[ 1 2 3 4 '%'
	emit	[ 1 2 3 4 > '%'
}if

fourth		[ 1 2 3 4 1
dec		[ 1 2 3 4 0
if{		[ 1 2 3 4 // not taken regression test
	'^'	[ 1 2 3 4 '^'
	emit	[ 1 2 3 4 > '^'
}if

2drop		[ 1 2
2dup		[ 1 2 1 2
for{		[ 1 2	| i:1 n:2 ]
	i	[ 1 2 i	| i   n   ]
}for		[ 1 2 1
dec		[ 1 2 0
if{		[ 1 2 // not taken regression test
	'&'	[ 1 2 '&'
	emit	[ 1 2 > '&'
}if		[ 1 2
2 -		[ 1 0
if{		[ 1 // not taken regression test
	'*'	[ 1 '*'
	emit	[ 1 > '*'
}if		[ 1
dec		[ 0
if{		[ // not taken regression test
	'('	[ '('
	emit	[ > '('
}if		[

1 1 ~		[ 0
if{		[ // not taken regression test
	')'	[ ')'
	emit	[ > ')'
}if		[

2 1 ~		[ -1
inc		[ 0
if{		[ // not taken regression test
	'-'	[ '-'
	emit	[ > '-'
}if		[

1 2 ~		[ 1
dec		[ 0
if{		[ // not taken regression test
	'+'	[ '+'
	emit	[ > '+'
}if		[

1 2 >=		[ 0
if{		[ // not taken regression test
	'|'	[ '|'
	emit	[ > '|'
}if

2 1 <=		[ 0
if{		[ // not taken regression test
	'\'	[ '\'
	emit	[ > '\'
}if

0		[ 0
0=		[ 1
if{		[ // taken
}else{		[ // not taken regression test
	'='	[ '='
	emit	[ > '='
}if

3 2 >		[ 1
if{		[ // taken
}else{		[ // not taken regression test
	'-'	[ '-'
	emit	[ > '-'
}if

2 3 <		[ 1
if{		[ // taken
}else{		[ // not taken regression test
	'0'	[ '0'
	emit	[ > '0'
}if

bye
