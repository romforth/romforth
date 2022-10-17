#include <stdio.h>		// fprintf
#include <sys/types.h>		// open
#include <sys/stat.h>		// open
#include <fcntl.h>		// open
#include <unistd.h>		// close
#include <stdlib.h>		// exit

typedef unsigned char byte;

void
usage(char *s, int n) {
	fprintf(stderr, "usage: %s binary\n",s);
	exit(n);
}

void
_die(char *s, int n, char *f, int l) {
	fprintf(stderr, "%s in file %s at line %d\n", s, f, l);
	exit(n);
}
#define die(s, n) _die(s, n, __FILE__, __LINE__);

#define MAX16 (1<<16)

void
emul(byte *mem, int ip) {
	// printf("reading memory at address %d(%x)\n", ip, ip);
	byte o=mem[ip++];
	// printf("opcode: %d\n", o);
	switch(o) {
	case 0xF4:
		// printf("halt\n");
		exit(0);
	default:
		die("unimplemented opcode", o);
	}
}

int
main(int argc, char **argv) {
	byte mem[MAX16];
	struct stat sb;
	int bios=0x100;		// this needs to match origin in rom.s

	if (argc!=2) {
		usage(argv[0], 1);
	}
	int fd=open(argv[1], O_RDONLY);
	if (fd == -1) {
		die("open failed", 2);
	}
	if (fstat(fd, &sb) == -1) {
		die("fstat failed", 2);
	}
	// printf("file length is %ld\n", sb.st_size);
	read(fd, &mem[bios], sb.st_size);
	emul(mem, bios);
	close(fd);
}
