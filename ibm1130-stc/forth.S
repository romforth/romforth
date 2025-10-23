	* forth.S : initialization and glue code
	*
	* Copyright (c) 2025 Charles Suresh <romforth@proton.me>
	* SPDX-License-Identifier: AGPL-3.0-only
	* Please see the LICENSE file for the Affero GPL 3.0 license details

	org		0

	b		*-*

	* The next 3 addresses are reserved for XR[123] as per the docs

	dc		0	Reserved to store register XR1
	dc		0	Reserved to store register XR2
	dc		0	Reserved to store register XR3

	* Addresses 0x8-0xD are reserved for the interrupt vectors as per the docs

	org		/0008

	dc		iv	Interrupt Vector 1 - set dummy interrupt handler
	dc		iv	Interrupt Vector 2 - set dummy interrupt handler
	dc		iv	Interrupt Vector 3 - set dummy interrupt handler
	dc		iv	Interrupt Vector 4 - set dummy interrupt handler
	dc		iv	Interrupt Vector 5 - set dummy interrupt handler
	dc		iv	Interrupt Vector 6 - set dummy interrupt handler

	* Addresses 0x20-0x27 are reserved for "Printer Scan Field" as per the docs

	org		/0020

	dc		0	Reserved to store the Printer Scan Field
	dc		0	Reserved to store the Printer Scan Field
	dc		0	Reserved to store the Printer Scan Field
	dc		0	Reserved to store the Printer Scan Field
	dc		0	Reserved to store the Printer Scan Field
	dc		0	Reserved to store the Printer Scan Field
	dc		0	Reserved to store the Printer Scan Field
	dc		0	Reserved to store the Printer Scan Field

	* Leave some empty space here in case other reserved locations are used

	* If this space is truly unused, the data stack could grow upward here

	org		/0100

	* xio addresses must be on an even boundary and this address is even
	* but it doesn't hurt to add an assertion
	bss	e	0	Enforce an even address for the xio address

write	dc		prbuf	First IOCC word points to the character
	dc		/1900	Second IOCC word : write to paper tape punch

prbuf	dc		0

rdbuf	dc		/6600	ASCII 'f', big endian

iv	dc		*-*
	wait

start	bsi		rom
	wait

rom	dc		*-*

include(`rom.s')

	end		start
