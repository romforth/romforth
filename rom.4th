[ // rom.4th : arch neutral (for the most part) test cases and init code
[
[ // Copyright (c) 2022 Charles Suresh <romforth@proton.me>
[ // SPDX-License-Identifier: AGPL-3.0-only
[ // Please see the LICENSE file for the Affero GPL 3.0 license details

[ // init code goes outside the TESTROM flag
[ // test code goes inside the TESTROM flag
[ // each step of the porting process can be individually controlled using
[ // the unadorned "step" variable. Dollar variables (eg. $ADDR) are used to
[ // pass in/specify the arch specific constants. Unadorned variables can
[ // only be used as part of "#{if" conditions.

[ // The #{ifdef and #{if directives work just like #ifdef and #if in cpp
[ // the additional brace just helps to find the matching close directive
[ // (for example by toggling on the % key in vi)

[ // There is a #assert directive which is meant to be a generic means
[ // of failing the step/test where it is used.

#{ifdef TESTROM

#{if step==1

	[ < 'f'
key	[ tos='f'
emit	[ tos='f' > 'f'

#}if

#{if step>=2

	[ < 'f'
key	[ 'f'
dup	[ 'f' 'f'
drop	[ 'f'
emit	[ > 'f'

#}if

#{if step>=3

'o'	[ 'o'
emit	[ > 'o'

#}if

#{if step>=4

-114	[ -114
neg	[ 114	// ASCII r == 114
emit	[ > 'r'

#}if

#{if step>=4.1

j	[	// raw opcode test of the 'j' operator
#JUMP	[ 	// the byte offset to skip over the assert below
#assert

't'	[ 't'
emit	[ > 't'

#}if

#{if step>=4.2

0	[ 0
jz	[	// raw opcode test of the 'jz' operator
#JUMP	[	// the byte offset to skip over the assert below
#assert

'h'	[ 'h'
emit	[ > 'h'

#}if

#{if step>=4.3

1	[ 1
jnz	[	// raw opcode test of the 'jnz' operator
#JUMP	[	// the byte offset to skip over the assert below
#assert

32	[ ' '
emit	[ > ' '

#}if

#{if step>=5

0		[ 0
if{		[	// not taken
	#assert
}if		[
1		[ 1
if{		[	// taken
}else{		[	// not taken
	#assert
}if		[

#}if

#{if step>=6

-1		[ -1
inc		[ 0
if{		[	// not taken
	#assert
}if		[
1		[ 1
dec		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=7

1		[ 1
neg		[ -1
inv		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=8

0		[ 0
1		[ 0 1
nip		[ 1	// nos=0
dup		[ 1 1
dip		[ 1 0 1	// tuck
dec		[ 1 0 0
if{		[ 1 0	// not taken
	#assert
}if		[ 1 0
if{		[ 1	// not taken
	#assert
}if		[ 1
dec		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=9

1		[ 1
2		[ 1 2
+		[ 3
2		[ 3 2
-		[ 1
dec		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=10.1

1		[ 0b01
2		[ 0b01 0b10
&		[ 0b00
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=10.2

1		[ 0b01
2		[ 0b01 0b10
|		[ 0b11
3		[ 0b11 3
-		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=10.3

-1		[ 0b111...
0		[ 0b111... 0b000...
^		[ 0b111...
inc		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=11

0		[ 0
1		[ 0 1
2		[ 0 1 2
2drop		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=12

1		[ 1
2		[ 1 2
swap		[ 2 1
-		[ 1
dec		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=13

$ADDR		[ $ADDR
@		[ $VALUE
$VALUE		[ $VALUE $VALUE
-		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=14

here		[ here (here:h)
@		[ h
1234		[ h 1234
here		[ h 1234 here
!		[ h (here:1234)
here		[ h here
@		[ h 1234
1234		[ h 1234 1234
-		[ h 0
if{		[ h	// not taken
	#assert
}if		[ h
here		[ h here
!		[ (here:h)

#}if

#{if step>=15

state		[ state (state:1)
c@		[ 1
dec		[ 0
if{		[	// not taken
	#assert
}if		[

state		[ state (state:s)
c@		[ s
123		[ s 123
state		[ s 123 state
c!		[ s (state:123)
state		[ s state
c@		[ s 123
123		[ s 123 123
-		[ s 0
if{		[ s	// not taken
	#assert
}if		[ s
state		[ s state
c!		[ (state:s)

#}if

#{if step>=16

3		[ 3
2		[ 3 2
1		[ 3 2 1
pick		[ 3 2 3
3		[ 3 2 3 3
-		[ 3 2 0
if{		[ 3 2	// not taken
	#assert
}if		[ 3 2
-		[ 1
dec		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=17

2		[ 2
1		[ 2 1
1		[ 2 1 1
stick		[ 1
dec		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=18

0		[ 0
sp@! sp@!	[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#}ifdef

#{if step>=19

[ // set up the return stack

#{if RGROWLOW==0
here		[ here (here:mem)
@		[ mem (rp:r)
rp@!		[ r (rp:mem)
drop		[
#}if

$RSTKSZ		[ $RSTKSZ
here		[ $RSTKSZ here
@		[ $RSTKSZ mem
+		[ $RSTKSZ+mem
here		[ $RSTKSZ+mem here
!		[ (here:mem+$RSTKSZ)

#{if RGROWLOW==1
here		[ here (here:mem)
@		[ mem (rp:r)
rp@!		[ r (rp:mem)
drop		[
#}if

#}if

#{ifdef TESTROM

#{if step>=20

3		[ 3
2		[ 3 2
>r		[ 3	| 2 ]
dup		[ 3 3	| 2 ]
r>		[ 3 3 2
swap		[ 3 2 3	// over
3		[ 3 2 3 3
-		[ 3 2 0
if{		[ 3 2	// not taken
	#assert
}if		[ 3 2
-		[ 1
dec		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=21

1		[ 1
2		[ 1 2
lit		[ 1 2	// lit escapes the following byte(s)
swap		[ 1 2	// escaped by lit
#{if offset==1
lit		[ 1 2	// padding used for 1 byte offset, escaped by lit
#}if
exec		[ 2 1
-		[ 1
dec		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=22

bl		[ ' '	// ASCII space == 32
32		[ 32 32
-		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=23

4321		[ 4321
testnest	[ 4321 ret
call		[ 4321 1234
1234		[ 4321 1234 1234
-		[ 4321 0
if{		[ 4321 	// not taken
	#assert
}if		[ 4321

4321		[ 4321 4321
-		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=24

$SERIALIN	[ $SERIALIN < 't'
p@		[ 't'
$SERIALOUT	[ 't' $SERIALOUT
p!		[ > 't'

#}if

#{if step>=25

4		[ 0b100
2		[ 0b100 2
<<		[ 0b10000
64		[ 0b10000 0b1000000
2		[ 0b10000 0b1000000 2
>>		[ 0b10000 0b10000
-		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=26

loop{		[
	$TTYCSR	[ $TTYCSR
	p@	[ ready
	1	[ ready 1
	$BIT	[ ready 1 $BIT
	<<	[ ready 1<<$BIT
	&	[ ready&(1<<$BIT)
}until{		[ ready&(1<<$BIT)==0
}loop		[ ready&(1<<$BIT)!=0
key		[ 'x'
'x'		[ 'x' 'x'
-		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=27

1		[ 1 < 'o'
loop{		[ n:1
	dup	[ n n
}while{		[ n < c	// n!=0
	key	[ n 'o'
	emit	[ n > 'o'
	dec	[ n:n-1
}loop		[ n	// n==0
drop		[

#}if

#{if step>=28

1		[ 1
2		[ 1 2
over		[ 1 2 1
-		[ 1 1
dec		[ 1 0
if{		[ 1	// not taken
	#assert
}if		[ 1
dec		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=29

3		[ 3
2		[ 3 2
3		[ 3 2 3
third		[ 3 2 3 2
-		[ 3 2 1
if{		[ 3 2	// not taken
	#assert
}if		[ 3 2
-		[ 1
dec		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=30

4		[ 4
6		[ 4 6
2		[ 4 6 2
4		[ 4 6 2 4
fourth		[ 4 6 2 4 4
-		[ 4 6 2 0
if{		[ 4 6 2	// not taken
	#assert
}if		[ 4 6 2
-		[ 4 4
-		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=31

1		[ 1
4		[ 1 4
for{		[ < "m !"
	key
	emit
}for		[ > "m !"

#}if

#{if step>=32

1		[ 1
4		[ 1 4
for{		[
	i
}for		[ 1 2 3
-		[ 1 -1
+		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=33

1		[ 1
1		[ 1 1
~		[ 0
if{		[	// not taken
	#assert
}if		[

2		[ 2
1		[ 2 1
~		[ -1
inc		[ 0
if{		[	// not taken
	#assert
}if		[

1		[ 1
2		[ 1 2
~		[ 1
dec		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=34

2		[ 2
1		[ 2 1
>=		[ 1
if{		[	// not taken
}else{		[	// taken
	#assert
}if		[

1		[ 1
1		[ 1 1
>=		[ 1
if{		[	// not taken
}else{		[	// taken
	#assert
}if		[

1		[ 1
2		[ 1 2
>=		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=35

1		[ 1
2		[ 1 2
<=		[ 0
if{		[	// not taken
}else{		[	// taken
	#assert
}if		[

1		[ 1
1		[ 1 1
<=		[ 1
if{		[	// not taken
}else{		[	// taken
	#assert
}if		[

2		[ 2
1		[ 2 1
<=		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=36

0		[ 0
0=		[ 1
if{		[	// taken
}else{		[	// not taken
	#assert
}if		[

1		[ 1
0=		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=37

1		[ 1
2		[ 1 2
<		[ 1
if{		[	// taken
}else{		[	// not taken
	#assert
}if		[

1		[ 1
1		[ 1
<		[ 0
if{		[	// not taken
	#assert
}if		[ 1

2		[ 2
1		[ 2 1
<		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=38

2		[ 2
1		[ 2 1
>		[ 1
if{		[	// taken
}else{		[	// not taken
	#assert
}if		[

1		[ 1
1		[ 1
>		[ 0
if{		[	// not taken
	#assert
}if		[ 1

1		[ 1
2		[ 1 2
>		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step==39

here		[ here (here:h)
@		[ h < "token"
repl		[ h addr n (addr:"token")
5		[ h addr n 5	// 5==length("token")
-		[ h addr n-5
if{		[ h addr	// not taken
	#assert
}if		[ h addr	// n==5
tuck		[ addr h addr
-		[ addr h-addr
if{		[ addr 		// not taken
	#assert
}if		[ addr		// h==addr
dup		[ addr addr
4 +		[ addr addr+6 (addr:'t' addr+6:'n')
c@		[ addr c
'n'		[ addr c 'n'
-		[ addr c-'n'
if{		[ addr 		// not taken
	#assert
}if		[ addr		// c=='n'
c@		[ c
't'		[ c 't'
-		[ c-'t'
if{		[		// not taken
	#assert
}if		[		// c=='t'

#}if

#{if step==40
		[ < "1000 "
repl		[ 1000
1000		[ 1000 1000
-		[ 0
if{		[		// not taken
	#assert
}if		[

#}if

#{if step==41
		[ < "1000 repl "
repl		[ addr n addr s 0 (addr:"1000")	// lookup failed on "1000"
if{		[ addr n addr s			// not taken
	#assert
}if		[ addr n addr s
latest		[ addr n addr s latest	// sanity check that s is latest
@		[ addr n addr s l
-		[ addr n addr cell+1
cell		[ addr n addr cell+1 cell
-		[ addr n addr 1
1		[ addr n addr 1 1
-		[ addr n addr 0
if{		[ addr n addr		// not taken
	#assert
}if		[ addr n addr
third		[ addr n addr addr	// sanity check that first byte failed
-		[ addr n 0
+		[ addr n
atoi		[ 1000			// verify that repl returned "1000"
1000		[ 1000 1000
-		[ 0
if{		[			// not taken
	#assert
}if		[
repl		[ addr 4 addr+4 s 1 (addr:"repl")	// lookup ok on "repl"
dec		[ addr 4 addr+4 s 0	// 4 shows up since length("repl")==4
if{		[ addr 4 addr+4 s	// not taken
	#assert
}if		[ addr 4 addr+4 s
latest		[ addr 4 addr+4 s latest (latest:l)	// verify s==l+4+cell+1
@		[ addr 4 addr+4 s l
-		[ addr 4 addr+4 5+cell	// length("repl")+cell+1
cell		[ addr 4 addr+4 5+cell cell
-		[ addr 4 addr+4 5			// verify offset was 4
-		[ addr 4 addr-1
+		[ addr addr+3
-		[ -3
3		[ -3 3
+		[ 0
if{		[			// not taken
	#assert
}if		[

#}if

#{if step==42
		[ < "1000 repl "
repl		[ addr n l 0 (addr:"1000")	// lookup failed on "1000"
if{		[ addr n l			// not taken
	#assert
}if		[ addr n l
latest		[ addr n l latest	// sanity check that l is latest
@		[ addr n l l
-		[ addr n 0
if{		[ addr n		// not taken
	#assert
}if		[ addr n
atoi		[ 1000			// verify that repl returned "1000"
1000		[ 1000 1000
-		[ 0
if{		[			// not taken
	#assert
}if		[
repl		[ addr 4 l 1 (addr:"repl")	// lookup ok on "repl"
dec		[ addr 4 l 0	// 4 shows up since length("repl")==4
if{		[ addr 4 l	// not taken
	#assert
}if		[ addr 4 l
latest		[ addr 4 l latest (latest:l)	// verify l is latest
@		[ addr 4 l l
-		[ addr 4 0
+		[ addr 4 		// verify offset was 4
dec		[ addr 3
+		[ addr+3
c@		[ 'l'
'l'		[ 'l' 'l'
-		[ 0
if{		[			// not taken
	#assert
}if		[

#}if

#{if step==43
		[ < "1000 find "
repl		[ 1000	// lookup failed on 1000 so it was turned into a number
1000		[ 1000 1000		// verify that repl returned 1000
-		[ 0
if{		[			// not taken
	#assert
}if		[
repl		[ addr n l		// it should return lfa of "find" which
latest		[ addr n l latest	// is the second item in the list of
@		[ addr n l lfa#"repl"	// dictionary entries, first is "repl"
@		[ addr n l lfa#"find"	// next is "find"
-		[ addr n 0
if{		[ addr n		// not taken
	#assert
}if		[ addr n
2drop

#}if

#}ifdef

bye
