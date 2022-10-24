def{ getc		[
	loop{		[
		0x3f8	[ p // serial port #1
		5	[ p 5 // p+5 is the ready indication
		+	[ r:p+5 (r:ready byte)
		p@	[ ready
		1	[ ready // lowest bit is the ready flag
		&	[ ready&1
	}until{		[ // ready&1==0
	}loop		[ // ready&1==1
}def
