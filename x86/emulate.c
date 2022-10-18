#include <stdio.h>		// fprintf
#include <sys/types.h>		// open
#include <sys/stat.h>		// open
#include <fcntl.h>		// open
#include <unistd.h>		// close
#include <stdlib.h>		// exit
#include <string.h>		// strlen

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

void
_unimpl(char *s, byte op, int n, char *f, int l) {
	char buf[100];
	if (strlen(s) > 50) { // ensure enough space
		die("string doesn't fit in buffer", 4);
	}
	sprintf(buf, "unimplemented %s %d(0x%x)", s, op, op); // ~24 bytes + s
	_die(buf, n, f, l);
}
#define unimpl(s, op, n) _unimpl(s, op, n, __FILE__, __LINE__)

#define MAX16 (1<<16)

typedef struct x86splitreg {
	byte lsb;
	byte msb;
} x86splitreg;

typedef struct x86register {
	union {
		x86splitreg s;
		int val;
	};
} x86register;

x86register regs[8];

#define ax regs[0]
#define si regs[6]

char *regnames[]={"ax","cx","dx","bx","sp","bp","si","di"};

int
getreg(int n) {
	int r = n&0x7;
	if (r>7) {
		unimpl("register", n, 6);
	}
	// printf("register %s\n", regnames[r]);
	return r;
}

void
emul(byte *mem, int *pip) {
	int ip=*pip;
	// printf("reading memory at address %d(%x)\n", ip, ip);
	byte o=mem[ip++];
	// printf("opcode: %d(0x%x)\n", o, o);
	switch(o) {
	case 0xAC:
		ax.s.lsb=mem[si.val++];
		// printf("stored %d in al\n", ax.s.lsb);
		break;
	case 0xB8:
	case 0xB9:
	case 0xBA:
	case 0xBB:
	case 0xBC:
	case 0xBD:
	case 0xBE:
	case 0xBF: {
		int r=getreg(o);
		x86register *x=&regs[r];
		x->s.lsb=mem[ip++];
		x->s.msb=mem[ip++];
		// printf("mov %s, %x\n", regnames[r], x->val);
		break;
	}
	case 0xF4:
		// printf("halt\n");
		exit(0);
	default:
		unimpl("opcode", o, 5);
	}
	*pip=ip;
}

void
emulate(byte *mem, int ip) {
	for(;;) {
		emul(mem, &ip);
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
		die("fstat failed", 3);
	}
	// printf("file length is %ld\n", sb.st_size);
	read(fd, &mem[bios], sb.st_size);
	emulate(mem, bios);
	close(fd);
}
