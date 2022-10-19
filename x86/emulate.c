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
#define cx regs[1]
#define bx regs[3]
#define sp regs[4]
#define si regs[6]
#define di regs[7]

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

int df=1;
int rep=0;

void
emul(byte *mem, int *pip) {
	int ip=*pip;
	if (rep) {
		ip=rep;
	}
	// printf("reading memory at address %d(%x)\n", ip, ip);
	byte o=mem[ip++];
	// printf("opcode: %d(0x%x)\n", o, o);
	switch(o) {
	case 0x53:
		if (sp.val<=0) {
			die("stack overflow", 8);
		}
		mem[--sp.val]=bx.s.msb;
		mem[--sp.val]=bx.s.lsb;
		break;
	case 0x5B:
		if (sp.val>=0x100) {
			die("stack underflow", 9);
		}
		bx.s.lsb=mem[sp.val++];
		bx.s.msb=mem[sp.val++];
		break;
	case 0x6C: {
		byte c=getchar();
		mem[df ? di.val-- : di.val++]=c;
		// printf("got character: %x\n", c);
		if (--cx.val) break;
		rep=0;
		break;
	}
	case 0x88: {
		byte n=mem[ip++];
		int d=getreg(n);
		int s=getreg(n>>3);
		regs[d].s.lsb=regs[s].s.lsb;
		// printf("mov %s.l <- %s.l\n", regnames[d], regnames[s]);
		break;
	}
	case 0xAC:
		ax.s.lsb=mem[df ? si.val-- : si.val++];
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
	case 0xEC:
		ax.s.lsb=getchar();
		// printf("got character: %c\n", ax.s.lsb);
		break;
	case 0xEE:
		// printf("put character: %c\n", ax.s.lsb);
		putchar(ax.s.lsb);
		break;
	case 0xF3:
		// printf("rep ");
		rep=ip;
		break;
	case 0xF4:
		// printf("halt\n");
		exit(0);
	case 0xF7: {
		int n=mem[ip++];
		int r=getreg(n);
		x86register *x=&regs[r];
		if ((n&0xD8)==0xD8) {
			x->val = -x->val;
			// printf("neg\n");
		} else if ((n&0xD0)==0xD0) {
			x->val = ~x->val;
			// printf("inv\n");
		} else {
			unimpl("opcode F7+", n, 9);
		}
		break;
	}
	case 0xFC:
		df=0;
		// printf("clear direction flag\n");
		break;
	case 0xFF: {
		int n=mem[ip++];
		switch (n&0xF0) {
		case 0xE0: {
			int r=getreg(n);
			*pip=regs[r].val;
			// printf("jmp %s\n", regnames[r]);
			return;
		}
		default:
			unimpl("jmp?", n, 7);
		}
		break;
	}
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
	read(fd, &mem[bios], 12);
	emulate(mem, bios);
	close(fd);
}
