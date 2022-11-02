OUTPUT_FORMAT(binary);
SECTIONS {		/* output sections declaration of the linker script */
	.text 0x100 : {	/* declare load location of the start of ROM */
		*(*)	/* all sections in all files in one big flat segment */
	}
}
