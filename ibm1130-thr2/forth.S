	* forth.S : initialization and glue code
	*
	* Copyright (c) 2025 Charles Suresh <romforth@proton.me>
	* SPDX-License-Identifier: AGPL-3.0-only
	* Please see the LICENSE file for the Affero GPL 3.0 license details

	org		0

	b		*-*

	* The next 3 addresses are reserved for XR[123] as per the docs

	dc		rom-1	Reserved to store register XR1 (used as W)
	dc		/0100	Reserved to store register XR2 (used as SP)
	dc		0	Reserved to store register XR3

	* Addresses 0x8-0xD are reserved for the interrupt vectors per the docs

	org		/0008

	dc		iv	Interrupt Vector 1 - set dummy interrupt handler
	dc		iv	Interrupt Vector 2 - set dummy interrupt handler
	dc		iv	Interrupt Vector 3 - set dummy interrupt handler
	dc		iv	Interrupt Vector 4 - set dummy interrupt handler
	dc		iv	Interrupt Vector 5 - set dummy interrupt handler
	dc		iv	Interrupt Vector 6 - set dummy interrupt handler

	* Leave some empty space here in case other reserved locations are used

	* If this space is truly unused, the data stack could grow upward here

	org		/0100

	* xio addresses must be on an even boundary and this address is even
	* but it doesn't hurt to add an assertion
	bss	e	0	Enforce an even address for the xio address

write	dc		prbuf	First IOCC word points to the character
	dc		/1900	Second IOCC word : write to paper tape punch

readc	dc		rdbuf	First IOCC word points to the character
	dc		/1A00	Second IOCC word : read from paper tape reader

enptr	dc		rdbuf	First IOCC word points to the character
	dc		/1C00	Second IOCC word : control paper tape reader

sense	dc		rdbuf	First IOCC word points to the character
	dc		/1F00	Second IOCC word : sense paper tape reader

reset	dc		rdbuf	First IOCC word points to the character
	dc		/1F01	Second IOCC word : reset paper tape reader/punch

prbuf	dc		0

rdbuf	dc		0

rresp	dc		/4000

wresp	dc		/0200

rwrsp	dc		/5000	(rresp:4000|1000)

savac	dc		0	Temp location to save the accumulator

iv	dc		*-*

	sto		savac	Save the accumulator, just in case it was live
	xio		sense	Issue a sense on the Paper Tape Reader
	bsc		+-	if (acc==0) {
	b		sprus		this was just a spurious interrupt }
	and		rwrsp	then check if it was a (read | write) response
	bsc		+-	if (acc==0) {
	b		sprus	not read/write, something else, ignore? }
	and		rresp	Check if the read response bit is set
	bsc		+-	if (acc==0) {
	b		punch		not read - so it must be a write }
	xio		readc	Read the character which is now available
	ld		rdbuf	Load the character into the accumulator
	sra		8	Extract the high bits since it is big-endian
	sto		tos	... and save it in the TOS
punch				# nothing to do in case of a write interrupt
	xio		reset	just clear out the interrupts ...
sprus	ld		savac	restore the accumulator and ...
	bosc	i	iv	return from the interrupt (while clearing it)

start	bsi		inner
	wait
	nop

rread	xio		enptr	Enable reads on the IBM 1134 Paper Tape Reader
	wait			Let the interrupt handler take care of the rest
	b		innnr

rrite	dc		*-*

	ld		tos	Load the character to be printed
	sla		8	Turn it into big-endian format
	sto		prbuf	Save it into the print buffer
	xio		write	... and write the character
	wait			Let the interrupt handler take care of the rest
	b	i	rrite

inner	dc		*-*

innnr	mdx	1	1
deepr	ld	i	1	read the contents of the address pointed by XR1
	sto		*+1	and store it two bytes below here
	b	l	*-*	... to patch this placeholder

mnus1	dc		-1	Constant used by the inv'ert operation

tos	dc		0	Used as Forth's TOS (top of stack)
nos	dc		0	Used as Forth's NOS (next on stack)
ofs	dc		0	save location for the jump offset
tmp	dc		0	temp location to hold TOS for jz/jnz

litrl
	mdx	1	1
	ld	i	1
	sto	l	tos
	b		innnr

bz	mdx	1	1
	ld	i	1
	sto	l	ofs
	ld	l	tos
	sto	l	tmp
	ld	i	2
	sto	l	tos
	mdx	2	1
	ld	l	tmp
	bsc		+-
	b		bzero
	b	l	innnr

bnz	mdx	1	1
	ld	i	1
	sto	l	ofs
	ld	l	tos
	sto	l	tmp
	ld	i	2
	sto	l	tos
	mdx	2	1
	ld	l	tmp
	bsc		z
	b		bzero
	b	l	innnr

bzero	ld	l	ofs
	a	l	1
	sto	l	1
	b	l	innnr

ifdef(`USEDICT',`sinclude(`dict.s')')

ifdef(`USEDICT',`sinclude(`defs_dict.s')',`sinclude(`defs.s')')

include(`rom.s')

here	dc		mem
stat	dc		1	# state
late				# latest
sinclude(`latest.s')
mem

	end		start
