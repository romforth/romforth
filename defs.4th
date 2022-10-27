def{ testdef	[
	'o'	[ 'o'
	emit	[ > 'o'
}def

def{ 2ret	[	| r ]
	r>	[ r	|   ]
}def

def{ testnest
	2ret	[ r	// nothing below here will be executed due to the 2ret
		[	// but control does come back here indirectly due to
		[	// the explicit "call" done in the rom test code
	'm'	[ 'm'
	emit	[ > 'm'
}def

def{ echon		[ n
	loop{		[ n
		dup	[ n n
	}while{		[ n < c	// n != 0
		getc	[ n c
		emit	[ n > c
		dec	[ n:n-1
	}loop		[ n	// n == 0
	drop		[
}def

def{ third 2 pick }def
def{ fourth 3 pick }def

def{ i		[		| ret i n
	r>	[ ret		|     i n ]
	r>	[ ret i		|       n ]
	swap	[ i ret		|       n ]
	over	[ i ret i	|       n ]
	>r	[ i ret		|     i n ]
	>r	[ i		| ret i n ]
}def

def{ 2dup	[ a b
	over	[ a b a
	over	[ a b a b
}def
