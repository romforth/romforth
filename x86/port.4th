[ // port.4th : Forth definitions which are specific to the x86 architecture
[
[ // Copyright (c) 2022 Charles Suresh <romforth@proton.me>
[ // SPDX-License-Identifier: AGPL-3.0-only
[ // Please see the LICENSE file for the Affero GPL 3.0 license details

def{ getc		[
	loop{		[
		0x3f8	[ p // serial port #1
		5	[ p 5 // p+5 is the ready indication
		+	[ r:p+5 (r:ready byte)
		p@	[ ready
		1	[ ready 1 // lowest bit is the ready flag
		&	[ ready&1
	}until{		[ // ready&1==0
	}loop		[ // ready&1==1
	key		[ c
}def
