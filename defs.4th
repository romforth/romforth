[ // defs.4th : Forth definitions which are architecture independent
[
[ // Copyright (c) 2022-2023 Charles Suresh <romforth@proton.me>
[ // SPDX-License-Identifier: AGPL-3.0-only
[ // Please see the LICENSE file for the Affero GPL 3.0 license details

[ // "test only" definitions must be wrapped inside the TESTROM flag

[ Note: bl is used as a boundary marker starting from step 46.
[ Do not place other definitions ahead of it.

#{if step>=22

def{ bl 32 }def

#}if

#{ifdef TESTROM

#{if step>=23

def{ 2ret	[	| r ]
#{if machinestack==1
	m>	[ r	|   ]
#}if
#{if machinestack==0
	r>	[ r	|   ]
#}if
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
		0x8000	[ s 0x8000
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

[ Given the link field address, map it to the name field address
[ where the dictionary header is: nfa:(name | count) | lfa:link | cfa:code
[ note that cfa2nfa usually denoted >NAME and other such mappings are
[ trivial compared to conventional Forth, so I'll not implement them
def{ lfa2nfa	[ link
	dec	[ count:link-1
	dup	[ count count
	c@	[ count n
	0x7f	[ count n 0x7f	// mask off the MSB
	&	[ count n&0x7f	// ie the immediate flag
	-	[ name
}def

def{ cell
	$CELL			[ arch dependent value configured in fpp.config
}def

[ Check if two strings are the same (equivalent to memcmp, except return value)
[ return 1 if they are the same, return 0 if they are different
def{ same			[ addr name n
	0			[ addr name n 0
	swap			[ addr name 0 n
	for{			[ addr name		| i n ]
		over		[ addr name addr	| i n ]
		c@		[ addr name c1		| i n ]
		over		[ addr name c1 name	| i n ]
		c@		[ addr name c1 c2	| i n ]
		-		[ addr name c1-c2	| i n ]
		if{		[ addr name 		| i n ] // c1 != c2
			r>	[ addr name n		|   n ]
			r>	[ addr name n i
			2drop	[ addr name
			0	[ addr name 0
			exit
		}if		[ addr name		| i n ] // c1 == c2
		inc		[ addr name+1		| i n ]
		swap		[ name+1 addr		| i n ]
		inc		[ name+1 addr+1		| i n ]
		swap		[ addr+1 name+1		| i n ]
	}for			[ addr+n name+n
	1			[ addr+n name+n 1
}def

#}if

#{if step==41

[ Assume that this definition of the repl is just a stepping stone, so it is
[ ifdef'ed only within this one step (ie step==41)
[ The only change from the previous repl at step==40 is to see if the token
[ is the same as the last ("latest") name (just the string) in the dictionary
def{ repl
	32		[ 32
	parse		[ addr n
	over		[ addr n addr
	over		[ addr n addr n
	latest		[ addr n addr n latest (latest:link)
	@		[ addr n addr n link
	lfa2nfa		[ addr n addr n name
	swap		[ addr n addr name n
	same		[ addr n addr+x name+x flag //flag=0||((flag==1)&&(n=x))
}def

#}if

#{if step>=42

#{if NEEDROT

def{ rot	[ a b c
	>r	[ a b	| c ]
	swap	[ b a	| c ]
	r>	[ b a c
	swap	[ b c a
}def

#}if

[ Check if the counted string on the stack matches the dictionary entry at lfa
[ Return 1 if there is a match, return 0 if there is no match
def{ match		[ addr n lfa
	over		[ addr n lfa n
	over		[ addr n lfa n lfa
	dec		[ addr n lfa n nfa:lfa-1	// to get to the nfa
	dup		[ addr n lfa n nfa nfa
	c@		[ addr n lfa n nfa c		// get the count byte
	rot		[ addr n lfa nfa c n
	swap		[ addr n lfa nfa n c
	0x7f		[ addr n lfa nfa n c 0x7f	// mask off the MSB
	&		[ addr n lfa nfa n c:c&0x7f	// ie the immediate flag
	tuck		[ addr n lfa nfa c n c
	-		[ addr n lfa nfa c n-c
	if{		[ addr n lfa nfa c	// n != c, count mismatch
		2drop	[ addr n lfa
		0	[ addr n lfa 0		// return 0
		exit
	}if		[ addr n lfa nfa c	// n == c, count matches
	-		[ addr n lfa name:nfa-c
	fourth		[ addr n lfa name addr	// so, pass that count as the
	fourth		[ addr n lfa name addr n	// parameter to "same"
	same		[ addr n lfa name+? addr+? flag	// We care only for
	swap		[ addr n lfa name+? flag addr+?	// the return value
	drop		[ addr n lfa name+? flag	// so drop the rest
	swap		[ addr n lfa flag name+?	// of the stuff from
	drop		[ addr n lfa flag		// the stack
}def

#}if

#{if step==42

[ Assume that this definition of the repl is just a stepping stone, so it is
[ ifdef'ed only within this one step (ie step==42)
[ The only change from the previous repl at step==41 is to see if the token
[ match'es the latest entry in the dictionary by checking the entire name field
def{ repl
	32		[ 32
	parse		[ addr n
	latest		[ addr n latest (latest:l)
	@		[ addr n l
	match		[ addr n l flag
}def

#}if

#{if step>=43

[ find the counted string in the dictionary
[ return 0 if it is not found otherwise return the lfa of the dictionary entry
def{ find			[ addr n
	latest			[ addr n (latest:lfa)
	@			[ addr n lfa
	loop{			[ addr n lfa
		dup		[ addr n lfa lfa
	}while{			[ addr n lfa		// lfa != 0
		match		[ addr n lfa flag	// see if it matches
		if{		[ addr n lfa		// flag != 0
			exit	[ addr n lfa		// return the lfa
		}else{		[ addr n lfa (lfa:p)	// flag == 0
			@	[ addr n lfa:p		// move to next entry
		}if		[ addr n lfa		// flag == 0
	}loop			[ addr n lfa		// return lfa:0
}def

#}if

#{if step==43

[ Assume that this definition of the repl is just a stepping stone, so it is
[ ifdef'ed only within this one step (ie step==43)
[ The only change from the previous repl at step==42 is to see if the token
[ can be found by walking the dictionary and if not, turn it into a number
def{ repl
	32		[ 32 < "1000 find "
	parse		[ addr n (addr:"1000")
	find		[ addr n lfa
	dup		[ addr n lfa lfa
	if{		[ addr n lfa	// lfa!=0, so for now,
		exit	[ addr n lfa	// just return it.
	}else{		[ addr n lfa	// lfa==0, it is not in the dictionary
		drop	[ addr n	// so drop the 0 value
		atoi	[ 1000		// and turn the string into a number
	}if
}def

#}if

#{if step>=44

[ Assume "latest" is the last of the "primitive variables" so it can serve
[ as the boundary marker between primitive variables and definitions. The cfa
[ of variables are returned as is but definitions are exec'ed
def{ cfaexec		[ cfa
	dup		[ cfa cfa
	latest		[ cfa cfa latest
	>		[ cfa cfa>latest
	if{		[ cfa		// cfa>latest : implies a definition
		@	[ exe		// get the address to execute
		exec	[ ?		// and exec it
	}if		[ ?|cfa		// cfa<=latest : variable, leave as is
}def

#}if

#{if step>=46

#{if THREAD==1

[ Compile/escape the cfa of the "defined word" and push it on the stack
[ Currently this is needed only on the x86 port which uses the "thread"ing
[ convention of prepending a word's cfa with the bytecode for "enter".
[ THREAD type of 1 is used to denote the x86 port's calling convention.
[ THREAD type of 2 is used by PDP11 which stores only the cfa so it can be
[ escaped by prepending a "lit", so no equivalent functionality is needed there
def{ ESCAPE	[		| w ]
	r>	[ w		|   ]	// get the next exec'utable address
	inc	[ a:w+1		|   ]	// skip the exec bytecode (enter)
	dup	[ a a		|   ]
	@	[ a cfa		|   ]	// retrieve the cfa value at that addr
	swap	[ cfa a		|   ]
	cell	[ cfa a	cell	|   ]	// skip to the next exec'utable address
	+	[ cfa w:a+cell	|   ]
	>r	[ cfa		| w ]	// restore next exec'utable address
}def

#}if

[ check if the cfa is that of a defined word
[ The cfa of "bl" (which is the very first "defined" word) is used as the
[ boundary marker for defined words. As described in the comment for ESCAPE,
[ THREAD'ing of type 2 which uses bare cfa's can be escaped using lit
def{ isdefn		[ cfa
	dup		[ cfa cfa
#{if THREAD==1
	ESCAPE bl	[ cfa cfa blcfa	// on x86, ESCAPE escape's the enter
#}if
#{if THREAD==2
	lit bl		[ cfa cfa blcfa	// on pdp11, lit escapes a bare cfa
#}if
	>=		[ cfa cfa>=blcfa
}def

[ exec the cfa of a defined word
[ All cfa's that are not defined words are passed through to cfaexec for
[ exec'ution.
def{ defexec		[ cfa
	isdefn		[ cfa flag
	if{		[ cfa		// defined word
#{if THREAD==1
		>r	[	| cfa ]	// on x86
#}if
#{if THREAD==2
		exec	[ ?		// on pdp11
#}if
	}else{		[ cfa		// variable or primitive
		cfaexec	[ ?
	}if
}def

#}if

#{if step==44 || step==45

[ Assume that this definition of the repl is just a stepping stone, so it is
[ ifdef'ed only within steps 44 and 45
[ The only change from the previous repl at step==43 is to "exec" a word
[ if it was found in the dictionary
def{ repl
	32		[ 32 < "1000 here "
	parse		[ addr n (addr:"1000")
	find		[ addr n lfa
	dup		[ addr n lfa lfa
	if{		[ addr n lfa	// lfa!=0, so get rid of
		nip	[ addr lfa	// unneeded elements
		nip	[ lfa		// in preparation to turn the
		cell	[ lfa cell	// lfa into the
		+	[ lfa+cell	// cfa
		cfaexec	[ ?		// and then exec it
	}else{		[ addr n lfa	// lfa==0, it is not in the dictionary
		drop	[ addr n	// so drop the 0 value
		atoi	[ 1000		// and turn the string into a number
	}if
}def

#}if

#{if step==46

[ Assume that this definition of the repl is just a stepping stone, so it is
[ ifdef'ed only within steps 46
[ The only change from the previous repl at step==44 and 45 is to call defexec
[ to exec defined words (in addition to primitives and variables)
def{ repl
	32		[ 32 < "1000 here "
	parse		[ addr n (addr:"1000")
	find		[ addr n lfa
	dup		[ addr n lfa lfa
	if{		[ addr n lfa	// lfa!=0, so get rid of
		nip	[ addr lfa	// unneeded elements
		nip	[ lfa		// in preparation to turn the
		cell	[ lfa cell	// lfa into the
		+	[ lfa+cell	// cfa
		defexec	[ ?		// and then exec it
	}else{		[ addr n lfa	// lfa==0, it is not in the dictionary
		drop	[ addr n	// so drop the 0 value
		atoi	[ 1000		// and turn the string into a number
	}if
}def

#}if

#{if step>=47

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

[ allocate n bytes aligned on the specified power of 2 alignment
[ bits		: 1 2 3 ... n
[ alignment	: 2 4 8 ... 2**n
def{ alloca		[ n bits
	1		[ n bits 1
	swap		[ n 1 bits
	<<		[ n align:1<<bits
	dup		[ n align align
	dec		[ n align a:align-1
	here		[ n align a here (here:h)
	@		[ n align a h
	&		[ n align l:a&h
	dup		[ n align l l
	if{		[ n align l	// a&h!=0, unaligned by l
		-	[ n m:align-l	// m(misalignment):1..a
		tuck	[ m n m
		+	[ m n+m		// pad allocation with misalignment
		alloc	[ m h
		+	[ p:h+m		// offset by the misalignment
	}else{		[ n align l	// a&h==0, aligned already
		2drop	[ n
		alloc	[ p:h
	}if		[ p
}def

#}if

#{if step>=48

[ Given n, return m such that *here+m will fall on an aligned address
[ It is used prior to calling alloc when the current allocation can be
[ unaligned but the allocation _after_ that must be aligned.
def{ align		[ n
#{if ALIGN==0		[ n	// no alignment is required
	exit
#}if
	dup		[ n n
	1		[ n n 1
	$ALIGN		[ n n 1 bits
	<<		[ n n align:1<<bits
	dup		[ n n align align
	dec		[ n n align a:align-1
	rot		[ n align a n
	here		[ n align a n here (here:h)
	@		[ n align a n h
	+		[ n align a f:n+h
	&		[ n align l:a&n
	dup		[ n align l l
	if{		[ n align l	// l!=0
		-	[ n m:align-l	// m(misalignment):1..a
		+	[ m:n+m		// bring it back into alignment
	}else{		[ n align l	// l==0
		2drop	[ m:n
	}if		[ m		// m is now aligned (relative to here)
}def

[ Copy the bytes s[0:n) to d[0:n)
[ the destination d is greater than s but may overlap, so we copy from the end
def{ revstrdup		[ n d s
	third		[ n d s n
	loop{		[ n d s i
		dup	[ n d s i i
	}while{		[ n d s i		// i!=0
		dec	[ n d s i:i-1
		dup	[ n d s i i
		third	[ n d s i i s
		+	[ n d s i s+i (s[i]:c)
		c@	[ n d s i c
		fourth	[ n d s i c d
		third	[ n d s i c d i
		+	[ n d s i c d+i
		c!	[ n d s i (d[i]:c)
	}loop		[ n d s i		// i==0
	2drop
}def

[ Create a new entry in the dictionary
[                                             v nfa   v lfa  v cfa
[                          --------------------------------------------
[ Dictionary entry layout: ... pad | name ... | count | link | code ...
[                          --------------------------------------------
[                           ^ byte+ ^ byte+   ^ byte  ^ cell ^ cell/byte+
[ See the JOURNAL entry dated 06 Jan '23 for more details about the layout
[ Cell boundaries need to be aligned on architectures that need alignment
def{ create		[
	32		[ 32
	parse		[ addr n
	dup		[ addr n n
	dup		[ addr n n n
	inc		[ addr n n n+1		// count(1+)
	cell +		[ addr n n m:n+1+cell	// link(cell+)
	dup		[ addr n n m m
	align		[ addr n n m m+d	// so lfa will be aligned
	tuck		[ addr n n m+d m m+d
	-		[ addr n n m+d -d
	neg		[ addr n n m+d d
	swap		[ addr n n d m+d
	alloc		[ addr n n d h		// n+1+cell+d allocated
	+		[ addr n n e:h+d	// skip d bytes for padding
	fourth		[ addr n n e addr
	revstrdup	[ addr n n e		// copy addr[0:n) to e[0:n)
	+		[ addr n c:e+n		// get to the count byte
	tuck		[ addr c n c
	c!		[ addr c (c:n)		// store the count byte
	inc		[ addr lfa:c+1		// get to the lfa
	swap		[ lfa addr
	drop		[ lfa
	latest		[ lfa latest (latest:prev)
	@		[ lfa prev
	over		[ lfa prev lfa
	!		[ lfa (lfa:prev)	// hook up to previous link
	latest		[ lfa latest
	!		[ (latest:lfa)		// and update to the latest
}def

#}if

#{if step>=49

#{if step>=58

[ get the override flag (MSB of state)
def{ override@		[
	state		[ state (state:s)
	c@		[ s
	0x80		[ s 0x80
	&		[ s&0x80
}def

[ toggle the override flag (MSB of state)
def{ override!		[
	0x80		[ 0x80
	state		[ 0x80 state (state:s)
	c@		[ 0x80 s
	^		[ y:0x80^s
	state		[ y state
	c!		[ (state:y)
}def

[ return the current value of the override flag (and clear it if set)
def{ override			[
	override@		[ x
	dup			[ x x
	if{			[ x	// override (MSB of state) is set
		override!	[ x	// clear the override bit (toggle it)
	}if			[ x	// override (MSB of state) is clear
}def

#}if

def{ isimmediate	[ nfa (nfa:c)
	c@		[ c
	0x80		[ c 0x80	// immediate flag is MSB
	&		[ k:c&0x80

#{if step>=58
	override	[ k x
	^		[ k^x		// override immediate flag if required
#}if

}def

[ make the word at lfa "immediate"
def{ immediatelfa	[ lfa
	dec		[ nfa
	dup		[ nfa nfa (nfa:c)
	c@		[ nfa c
	0x80		[ nfa c 0x80
	|		[ nfa i:c|0x80
	swap		[ i nfa
	c!		[ (nfa:i)
}def

[ "immediate" marks the latest dictionary entry as an "immediate" word
[ immediate'ness is marked in the most significant bit of the nfa's count byte
def{ immediate	[
	latest	[ latest (latest:lfa)
	@	[ lfa
	immediatelfa
}def

#}if

#{if step>=50

[ append the byte at the top of the stack to the dictionary (with allocation)
def{ c,		[ c
	1	[ c 1
	alloc	[ c p
	c!	[ (p:c) \ c
}def

[ append the "word" at the top of the stack to the dictionary (with allocation)
[ the available dictionary entry is expected to be aligned
def{ ,		[ n
	cell	[ n cell
	alloc	[ n p
	!	[ (p:n) \ n
}def

[ Implementations that use THREAD'ing type 2 need a prefix at the start of
[ definitions. On the PDP11, for example, all definitions need to start with
[ the "JSR ip, (nr)" linkage. The newly introduced "defprefix" is meant to be
[ an arch specific means of adding such a prefix which abstracts away all of
[ the arch specific details.
def{ defprefix	[

#{if THREAD==2

[ The thinking behind having both THREAD and ARCH ifdef's is that any given
[ ARCH may have more than one THREAD'ing implementation. TECHDEBT until I
[ have more ports under my belt so I have a bigger picture to think through.

#{if ARCH eq "PDP11"
0x080c	[ 0x080c	// definitions start with "JSR ip, (nr)" on PDP11
,	[ \ 0x080c	// append it to the dictionary
#}if

#}if

}def

#}if

#{if step>=51

[ switch to compile mode
def{ ]run
	1		[ 1
	state		[ 1 state
	c!		[ (state:1)
}def

[ start the definition of a new word (and switch to compilation mode)
def{ :			[
	create		[	\ nfa lfa
	defprefix	[	\ prefix	// to prefix the definition
	]run		[			// switch to compile mode
}def

[ switch to interpret mode
def{ run[
	0	[ 0
	state	[ 0 state
	c!	[ (state:0)
}def

def{ offset,	[ val

#{if THREAD==1
	c,	[ \ val	// x86/THREAD type1 exec token uses just 1 byte
#}if

#{if THREAD==2
	,	[ \ val	// PDP11/THREAD type2 exec token uses a full cell
#}if

}def

[ finish up the definition of a new word (and switch to interpret mode)
def{ ;		[
	lit	[	// lit escapes the following byte(s)
	exit	[ exit	// escaped by lit

#{if offset==1
	lit	[ exit	// padding used for 1 byte offset, escaped by lit
#}if
	offset,	[ \ exit
	run[
}def

#}if

#{if step>=52

def{ literal	[ n
	lit	[ n	// to escape the next "token"
	lit	[ n lit	// so as to get lit on the stack

#{if offset==1
	lit	[ n lit	// additional padding but only on x86, for now
#}if

	offset,	[ n \ lit
	,	[ \ n		// in either case, the value needs a full cell

}def

def{ number		[ n
	state		[ n state (state:s)
	c@		[ n s
	if{		[ n	// compiling, append it to dictionary
		literal	[ \ lit n	// after wrapping it in a lit
	}if		[ n|empty	// intepreting state, leave n as is
}def

#}if

#{if step==52

[ Assume that this definition of the repl is just a stepping stone, so it is
[ ifdef'ed only within step 52
[ The only change from the previous repl at step==46 is the addition of state
[ handling for numbers. So in addition to being nops, definitions can now have
[ numbers as well. Since everything except numbers is always executed, ';' does
[ not yet have to be marked "immediate".
def{ repl
	32		[ 32 < ": baz 1234 ; baz "
	parse		[ addr n
	find		[ addr n lfa
	dup		[ addr n lfa lfa
	if{		[ addr n lfa	// lfa!=0, so get rid of
		nip	[ addr lfa	// unneeded elements
		nip	[ lfa		// in preparation to turn the
		cell	[ lfa cell	// lfa into the
		+	[ lfa+cell	// cfa
		defexec	[ ?		// and then exec it
	}else{		[ addr n lfa	// lfa==0, it is not in the dictionary
		drop	[ addr n	// so drop the 0 value
		atoi	[ 1000		// and turn the string into a number
		number	[ ?		// and either compile it or leave as is
	}if
}def

#}if

#{if step>=54

[ compile the cfa of a variable or primitive
def{ compcfa		[ cfa	// cfa: var/prim, defs are handled in compdef
	dup		[ cfa cfa
	latest		[ cfa cfa latest
	>		[ cfa cfa>latest
	if{		[ cfa		// cfa>latest : it is a primitive
		@	[ exe		// get the address/offset of code
		offset,	[ \ exe
	}else{		[ cfa		// cfa<=latest : it is a variable
		literal	[ \ lit cfa	// variables push their address
	}if
}def

#}if

#{if step>=53

[ make ';' an immediate word
def{ ;immediate		[
	here		[ here (here:h)
	@		[ h
	dup		[ h h
	';'		[ h h ';'
	swap		[ h ';' h
	c!		[ h (h:';')
	1		[ h 1
	find		[ h 1 lfa	// lfa of ';'
	immediatelfa	[ h 1
	2drop		[
}def

[ compile a definition (or a native definition/variable)
def{ compdef		[ cfa		// cfa: var/prim/def
	isdefn		[ cfa flag
	if{		[ cfa		// defined word

#{if THREAD==1
		lit	[ cfa		// escape the next byte
		enter	[ cfa enter	// x86/THREAD=1 needs enter as prefix
#{if offset==1
		lit	[ cfa enter	// padding, needed only on x86/offset=1
#}if
		c,	[ cfa	\ enter
		,	[	\ cfa
#}if

#{if THREAD==2
		,	[ 	\ cfa	// on pdp11, just the cfa is sufficient
#}if

	}else{		[ cfa		// variable or primitive,
#{if step>=54
		compcfa	[ \ cfa	// compile the variable or primitive's cfa
#}if
	}if
}def

[ cpl_ex_imm will either compile or execute the lfa based on "immediacy"
def{ cpl_ex_imm		[ cfa
	dup		[ cfa cfa
	cell		[ cfa cfa cell
	-		[ cfa lfa:cfa-cell	// cfa2lfa
	dec		[ cfa nfa:lfa-1 (nfa:c)	// lfa2nfa
	isimmediate	[ cfa c&0x80
	if{		[ cfa			// immediate,
		defexec	[ ?			// execute it
	}else{		[ cfa			// not immediate,
		compdef	[			// compile the cfa definition
	}if		[ ?
}def

[ cpl_ex will either compile or execute the lfa based on this decision table:
[	state		immediate?	action
[ 	0:interpret	no		exec
[ 	0:interpret	yes		exec
[ 	1:compile	no		compile
[ 	1:compile	yes		exec
def{ cpl_ex			[ cfa
	state			[ cfa state (state:s)
	c@			[ cfa s
	if{			[ cfa		// s==1, compiling
		cpl_ex_imm	[ ?		// compile or exec if immediate
	}else{			[ cfa		// s==0, interpreting
		defexec		[ ?		// go ahead and exec it
	}if			[ ?
}def

#}if

#{if step==53 || step==54 || step==55 || step>=56

[ Assume that this definition of the repl is just a stepping stone, so it is
[ ifdef'ed only within step 53
[ The only change from the previous repl at step==52 is that cpl_ex is called
[ instead of defexec to compile definitions (in addition to executing them).
[ With this change, the repl can include definitions that use other definitions
[ (including itself) in addition to numbers which were added at step 52. Since
[ definitions may be executed or compiled based on state, ';' needs to be
[ marked "immediate" before this is called.
def{ repl
	32		[ 32 < ": foo 1234 bl ; foo "
	parse		[ addr n
	find		[ addr n lfa
	dup		[ addr n lfa lfa
	if{		[ addr n lfa	// lfa!=0, so get rid of
		nip	[ addr lfa	// unneeded elements
		nip	[ lfa		// in preparation to turn the
		cell	[ lfa cell	// lfa into the
		+	[ lfa+cell	// cfa
		cpl_ex	[ ?		// and then compile/exec it
	}else{		[ addr n lfa	// lfa==0, it is not in the dictionary
		drop	[ addr n	// so drop the 0 value
		atoi	[ 1000		// and turn the string into a number
		number	[ ?		// and either compile it or leave as is
	}if
}def

#}if

#{if step>=55

def{ 3ret

#{if THREAD==2
	r>	[ defexec+?	// THREAD type 2 needs an additional ret entry
	drop	[	// this is not a real coroutine, just a multi level ret
#}if

	r>	[ cpl_ex+?	// after the call to defexec
	drop	[		// multi level ret, so we drop rather than save
	r>	[ repl+?	// after the call to cpl_ex
	drop	[		// multi level ret, so we drop rather than save
	r>	[ outer+?	// after the call to repl
	drop	[		// multi level ret, so we drop rather than save
}def

[ This is probably the final version of the repl.
[ The only change from the previous repl at step==53/54 is that it is no
[ longer a one shot exec wrapper, instead it loops "forever" as the 'l' in repl
[ implies. We still need to return control back to the test and this is done
[ using 3ret which is defined above which does a multi level ret. Obviously
[ this requires that each test now needs to be terminated with 3ret. Perhaps it
[ should really be called "eot" for "end of test", but I digress.
def{ outer
	loop{
		repl
	}loop
}def

#}if
