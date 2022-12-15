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

def{ 2dup	[ a b
	over	[ a b a
	over	[ a b a b
}def

#}if
