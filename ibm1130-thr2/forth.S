	* forth.S : initialization and glue code
	*
	* Copyright (c) 2025 Charles Suresh <romforth@proton.me>
	* SPDX-License-Identifier: AGPL-3.0-only
	* Please see the LICENSE file for the Affero GPL 3.0 license details

	org		0

	b		*-*

	* The next 3 addresses are reserved for XR[123] as per the docs

	dc		rom-1	Reserved to store register XR1
	dc		0	Reserved to store register XR2
	dc		0	Reserved to store register XR3

start	bsi		inner
	wait
	nop

inner	dc		*-*
next	mdx	1	1
	b	i	1

rom

include(`rom.s')

	end		start
