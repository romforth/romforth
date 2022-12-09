[ // rom.4th : arch neutral (for the most part) test cases and init code
[
[ // Copyright (c) 2022 Charles Suresh <romforth@proton.me>
[ // SPDX-License-Identifier: AGPL-3.0-only
[ // Please see the LICENSE file for the Affero GPL 3.0 license details

[ // init code goes outside the TESTROM flag
[ // test code goes inside the TESTROM flag
[ // each step of the porting process can be individually controlled using
[ // the unadorned "step" variable. Dollar variables (eg. $AAAA) are used to
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
#JUMP	[ 	// the byte offset to skip over the emit below
'j' emit

't'	[ 't'
emit	[ > 't'

#}if

#{if step>=4.2

0	[ 0
jz	[	// raw opcode test of the 'jz' operator
#JUMP	[	// the byte offset to skip over the emit below
'z' emit

'h'	[ 'h'
emit	[ > 'h'

#}if

#{if step>=4.3

1	[ 1
jnz	[	// raw opcode test of the 'jnz' operator
#JUMP	[	// the byte offset to skip over the emit below
'n' emit

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
2		[ 0b10
&		[ 0b00
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=10.2

1		[ 0b01
2		[ 0b10
|		[ 0b11
3		[ 0b11 3
-		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>=10.3

-1		[ 0b111...
0		[ 0b000...
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

#{if step>11

1		[ 1
2		[ 1 2
swap		[ 2 1
-		[ 1
dec		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>12

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

#{if step>13

$AAAA		[ $AAAA
@		[ $CCCC
$CCCC		[ $CCCC $CCCC
-		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>14

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

#{if step>15

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

#{if step>16

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

#{if step>17

2		[ 2
1		[ 2 1
1		[ 2 1 1
stick		[ 1
dec		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>18

0		[ 0
sp@! sp@!	[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#}ifdef

#{if step>19

[ // set up the return stack

here		[ here (here:mem)
@		[ mem (rp:r)
rp@!		[ r (rp:mem)
drop		[
$RRRR		[ $RRRR
here		[ $RRRR here
@		[ $RRRR mem
+		[ $RRRR+mem
here		[ $RRRR+mem here
!		[ (here:mem+$RRRR)

#}if

#{ifdef TESTROM

#{if step>20

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

#{if step>21

1		[ 1
2		[ 1 2
lit		[ 1 2	// lit escapes the following byte(s)
swap		[ 1 2	// escaped by lit
lit		[ 1 2	// escaped by lit
exec		[ 2 1
-		[ 1
dec		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>22

bl		[ ' '	// ASCII space == 32
32		[ 32 32
-		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>23

testnest	[ ret
call		[ 1234
1234		[ 1234 1234
-		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>24

$SERIAL		[ $SERIAL < 't'
p@		[ 't'
$SERIAL		[ 't' $SERIAL
p!		[ > 't'

#}if

#{if step>25

loop{		[
	$SSSS	[ $SSSS
	p@	[ ready
	1	[ ready 1
	$T	[ ready 1 $T
	<<	[ ready 1<<$T
	&	[ ready&(1<<$T)
}until{		[ ready&(1<<$T)==0
}loop		[ ready&(1<<$T)!=0
key		[ 'x'
'x'		[ 'x' 'x'
-		[ 0
if{		[	// not taken
	#assert
}if		[

#}if

#{if step>26

1		[ 1 < 'h'
loop{		[ n:1
	dup	[ n n
}while{		[ n < c	// n!=0
	key	[ n 'h'
	emit	[ n > 'h'
	dec	[ n:n-1
}loop		[ n	// n==0
drop		[

#}if

#{if step>27

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

#{if step>28

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

#{if step>29

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

#{if step>30

1		[ 1
7		[ 1 7
for{		[ < " rom !"
	key
	emit
}for		[ > " rom !"

#}if

#{if step>31

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

#{if step>32

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

#{if step>33

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

#{if step>34

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

#{if step>35

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

#{if step>36

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

#{if step>37

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

#}ifdef

bye
