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
