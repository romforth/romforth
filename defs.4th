[ // defs.4th : Forth definitions which are architecture independent
[
[ // Copyright (c) 2022 Charles Suresh <romforth@proton.me>
[ // SPDX-License-Identifier: AGPL-3.0-only
[ // Please see the LICENSE file for the Affero GPL 3.0 license details

[ // "test only" definitions must be wrapped inside the TESTROM flag

#{if step>=22

def{ bl 32 }def

#}if

#{ifdef TESTROM

#{if step>=23

def{ 2ret	[	| r ]
	r>	[ r	|   ]
}def

def{ testnest
	2ret	[ r	// nothing below here will be executed due to the 2ret
		[	// but control does come back here indirectly due to
		[	// the explicit "call" done in the rom test code
	1234	[ 1234
}def

#}if

#}ifdef

#{if step>=29

def{ third 2 pick }def

#}if

#{if step>=30

def{ fourth 3 pick }def

#}if

#{if step>=32

def{ i		[		| ret i n
	r>	[ ret		|     i n ]
	r>	[ ret i		|       n ]
	swap	[ i ret		|       n ]
	over	[ i ret i	|       n ]
	>r	[ i ret		|     i n ]
	>r	[ i		| ret i n ]
}def

#}if

#{if step>=33

#{if NEEDSIGNUM

def{ ~			[ a b
	-		[ s=a-b
	dup		[ s s
	if{ 		[ s	// a!=b
		0xF000	[ s 0x8000
		&	[ s&8000
		if{	[	// a<b
			1
		}else{	[	// a>b
			-1
		}if	[ -1/1
		exit
	}if		[ 0	// a=b
}def

#}if

#}if

#{if step>=34

def{ >=		[ a b
	~	[ a~b	// -1:a>b 0:a=b 1:a<b
	dec	[ a>=b	// -2:a>b -1:a=b 0:a<b
}def

#}if

#{if step>=35

def{ <=		[ a b
	~	[ a~b	// -1:a>b 0:a=b 1:a<b
	inc	[ a<=b	// 0:a>b 1:a=b 2:a<b
}def

#}if

#{if step>=37

def{ <		[ a b
	>=	[ a>=b	// -2:a>b -1:a=b 0:a<b
	0=	[ a<b	// 1:a<b, 0 otherwise
}def

#}if

#{if step>=38

def{ >		[ a b
	<=	[ a<=b	// 0:a>b 1:a=b 2:a<b
	0=	[ a>b	// 1:a>b, 0 otherwise
}def

#}if

#{if step>=39

def{ 2dup	[ a b
	over	[ a b a
	over	[ a b a b
}def

def{ tuck	[ a b
	nip	[ b	// nos:a
	dup	[ b b
	dip	[ b a b
}def

[ Given address a, offset o, delimiter d and character c, store c at a+o this
[ usually writes to the un-alloc'ated area in memory beyond the dictionary. By
[ design, allocation is not done, but we write to the unallocated space anyway
def{ append		[ a o d c
	fourth		[ a o d c a
	fourth		[ a o d c a o
	+		[ a o d c a+o
	c!		[ a o d // (a+o:c)
	swap		[ a d o
	inc		[ a d o:o+1
	swap		[ a o d
}def

[ Given character c, check if it is a "whitespace" in the range [9:13]
[ return 1 if it is in the range [9:13], return 0 otherwise
def{ ws?		[ c
	dup		[ c c
	dup		[ c c c
	9		[ c c c 9
	>=		[ c c c>=9
	swap		[ c c>=9 c
	13		[ c c>=9 c 13
	<=		[ c c>=9 c<=13
	&		[ c flag // flag!=0 if (c in 9..13), 0 otherwise
}def

[ Given a delimiter d and a character c, return a boolean flag f, which is
[ 1, if c==d
[ 1, if d==32 and c is a whitespace in the range [9:13]
[ 0, otherwise
def{ wscmpr			[ d c
	2dup			[ d c d c
	-			[ d c d-c
	if{			[ d c // d != c
		over		[ d c d
		32		[ d c d 32
		-		[ d c d-32
		if{		[ d c // d != 32
			0	[ d c 0
		}else{		[ d c // d == 32
			ws?	[ d c f // f is !0 if (c in 9..13), 0 otherwise
		}if		[ d c f
	}else{			[ d c // d == c
		1		[ d c 1
	}if			[ d c f
}def				[ d c f

[ Given a delimiter d, read and append characters from the input stream
[ until delimiter d is seen (after skipping any initial delimiters).
[ Denoting the delimiter with $d, the regex is just this : $d*([^$d]+)$d
def{ parse		[ d
	here @		[ d a
	swap		[ a d
	0		[ a d 0
	swap		[ a 0 d
	loop{		[ a 0 d
		key	[ a 0 d c
		wscmpr	[ a 0 d c flag
	}while{		[ a 0 d c // c is ~same as d
		drop	[ a 0 d
	}loop		[ a 0 d c // c is not ~same as d
	append		[ a 1 d (a:c)
	loop{		[ a n d
		key	[ a n d c
		wscmpr	[ a n d c flag
	}until{		[ a n d c // c is not ~same as d
		append	[ a n:n+1 d (a+n:c)
	}loop		[ a n d c // c is ~same as d
	2drop		[ a n
}def

#}if

#{if step==39

[ Assume that this definition of the repl is just a stepping stone, so it is
[ ifdef'ed only within this one step (ie step==39)
def{ repl
	32	[ 32 < "token "
	parse	[ addr n (addr:"token")
}def

#}if

#{if step>=40

[ Multiply by 10 : needed only because * is not yet defined
def{ 10*			[ n
	dup			[ n n
	dup			[ n n n
	3 <<			[ n n n*8
	+			[ n n*9
	+			[ n*10
}def

[ aggregate current digit(c) into the accumulator(acc) as decimal
def{ num			[ acc c
	'0'			[ acc c '0'
	-			[ acc n:c-'0'
	swap			[ n acc
	10*			[ n acc*10
	+			[ acc*10+n
}def

[ Turn an ascii "counted string" into an integer
[ assumes that the string is composed of digits in the range [0:9]
def{ atoi			[ addr n
	0			[ addr n acc:0
	swap			[ addr acc n
	0			[ addr acc n 0
	swap			[ addr acc 0 n
	for{			[ addr acc		| i n ]
		over		[ addr acc addr		| i n ]
		i		[ addr acc addr i	| i n ]
		+		[ addr acc addr+i	| i n ]
		c@		[ addr acc c		| i n ]
		num		[ addr acc:acc*10+c-'0'	| i n ]
	}for			[ addr acc
	swap			[ acc addr
	drop			[ acc
}def

#}if

#{if step==40

[ Assume that this definition of the repl is just a stepping stone, so it is
[ ifdef'ed only within this one step (ie step==40)
[ The only change from the previous repl at step==39 is an attempt to turn
[ the token into a number
def{ repl
	32		[ 32 < "1000 "
	parse		[ addr n (addr:"1000")
	state		[ addr n state (state:s)
	c@		[ addr n s
	if{		[ addr n	// interpreting
		atoi	[ 1000
	}if		[ 1000		// unless it is not interpreting
}def

#}if

#{if step>=41

[ allocate n bytes and return previous value of here
def{ alloc		[ n
	here		[ n here (here:h)
	@		[ n h
	swap		[ h n
	over		[ h n h
	+		[ h n+h
	here		[ h n+h here
	!		[ h (here:h+n)
}def

#}if
