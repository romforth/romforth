/*
 * emulate.c : "just enough emulation" of x86 to run the generated binary
 *
 * Copyright (c) 2022 Charles Suresh <romforth@proton.me>
 * SPDX-License-Identifier: AGPL-3.0-only
 * Please see the LICENSE file for the Affero GPL 3.0 license details
 */

#include <stdio.h>		// fprintf
#include <sys/types.h>		// open
#include <sys/stat.h>		// open
#include <fcntl.h>		// open
#include <unistd.h>		// close
#include <stdlib.h>		// exit
#include <string.h>		// strlen

typedef unsigned char byte;

// #define DEBUG 1
// #define STACKDEBUG 1

int start=0;

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
		short val;
	};
} x86register;

x86register regs[8];

#ifdef STACKDEBUG
x86register fake;
#endif

int carry;

#define ax regs[0]
#define cx regs[1]
#define dx regs[2]
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

int ds_base, ds_depth, rs_base, rs_depth;

void
emul(byte *mem, int *pip) {
	int ip=*pip;
	if (rep) {
		ip=rep;
	}
	// printf("reading memory at address %d(%x)\n", ip, ip);
	byte o=mem[ip++];
#ifdef DEBUG
	if (start) {
		if (mem[0x1ad] != 0x59) {
			die("add assert failed", 17);
		}
		if (si.val < 0x22a && si.val > 0x236) {
			if (mem[0x1dd] != 0xb2) {
				printf("here byte2 is %x\n", mem[0x1dd]);
				die("here byte1 assert failed", 19);
			}
			if (mem[0x1de] != 0x02) {
				printf("here byte2 is %x\n", mem[0x1de]);
				die("here byte2 assert failed", 20);
			}
		}
		if (di.val != 0x2b2) {
			printf("di is %x\n", di.val);
			die("di assert failed", 18);
		}
	}
#endif
	// printf("opcode: %d(0x%x)\n", o, o);
#ifdef STACKDEBUG
	if (sp.val<0x100) printf("\t[ ");
	for (int i=0x100-2; i>=sp.val; i-=2) {
		fake.s.lsb=mem[i];
		fake.s.msb=mem[i+1];
		printf("%d(0x%x) ", fake.val, fake.val);
	}
	if (sp.val<0x100) {
		printf("%d(0x%x)\n", bx.val, bx.val);
	}
#endif
	switch(o) {
	case 0x01: {
		int n=mem[ip++];
		int d=getreg(n);
		int s=getreg(n>>3);
		regs[d].val += regs[s].val;
		// printf("add %s, %s\n", regnames[d], regnames[s]);
		break;
	}
	case 0x09: {
		int n=mem[ip++];
		int d=getreg(n);
		int s=getreg(n>>3);
		regs[d].val |= regs[s].val;
		// printf("or %s, %s\n", regnames[d], regnames[s]);
		break;
	}
	case 0x11: {
		int n=mem[ip++];
		int d=getreg(n);
		int s=getreg(n>>3);
		// printf("adc %d %d %d\n", regs[d].val, regs[s].val, carry);
		regs[d].val += regs[s].val+carry;
		// printf("adc %s, %s\n", regnames[d], regnames[s]);
		break;
	}
	case 0x19: {
		int n=mem[ip++];
		int d=getreg(n);
		int s=getreg(n>>3);
		int r=(regs[d].val -= (regs[s].val+carry));
		// printf("sbb %s, %s; carry=%d\n", regnames[d], regnames[s], carry);
		break;
	}
	case 0x21: {
		int n=mem[ip++];
		int d=getreg(n);
		int s=getreg(n>>3);
		regs[d].val &= regs[s].val;
		// printf("and %s, %s\n", regnames[d], regnames[s]);
		break;
	}
	case 0x29: {
		int n=mem[ip++];
		int d=getreg(n);
		int s=getreg(n>>3);
		// printf("sub %d %d\n", regs[d].val, regs[s].val);
		int r=(regs[d].val -= regs[s].val);
		carry=(r<0 ? 1 : 0);
		// printf("sub %s, %s; carry=%d\n", regnames[d], regnames[s], carry);
		break;
	}
	case 0x30: {
		int n=mem[ip++];
		if (n==0xFF) {
			bx.s.msb ^= bx.s.msb;
			// printf("xor bh, bh (%d, %x)\n", bx.s.msb, bx.val);
		} else {
			unimpl("opcode 30+", n, 13);
		}
		break;
	}
	case 0x31: {
		int n=mem[ip++];
		int d=getreg(n);
		int s=getreg(n>>3);
		regs[d].val ^= regs[s].val;
		// printf("xor %s, %s\n", regnames[d], regnames[s]);
		break;
	}
	case 0x40:
	case 0x41:
	case 0x42:
	case 0x43:
	case 0x44:
	case 0x45:
	case 0x46:
	case 0x47: {
		int r=getreg(o);
		regs[r].val++;
		break;
	}
	case 0x48:
	case 0x49:
	case 0x4A:
	case 0x4B:
	case 0x4C:
	case 0x4D:
	case 0x4E:
	case 0x4F: {
		int r=getreg(o);
		regs[r].val--;
		break;
	}
	case 0x50:
	case 0x51:
	case 0x52:
	case 0x53:
	case 0x54:
	case 0x55:
	case 0x56:
	case 0x57: {
		int r=getreg(o);
		if (sp.val<=0) {
			die("stack overflow", 8);
		}
		x86register *x=&regs[r];
		mem[--sp.val]=x->s.msb;
		mem[--sp.val]=x->s.lsb;
		break;
	}
	case 0x58:
	case 0x59:
	case 0x5A:
	case 0x5B:
	case 0x5C:
	case 0x5D:
	case 0x5E:
	case 0x5F: {
		int r=getreg(o);
		if (sp.val>=0x100) {
			die("stack underflow", 9);
		}
		x86register *x=&regs[r];
		x->s.lsb=mem[sp.val++];
		x->s.msb=mem[sp.val++];
		break;
	}
	case 0x6C: {
		byte c=getchar();
		mem[df ? di.val-- : di.val++]=c;
		// printf("got character: %x\n", c);
		if (--cx.val) break;
		rep=0;
		start=1;
		rs_base=di.val;
		rs_depth=di.val;
		break;
	}
	case 0x72: {
		int n=mem[ip];
		if (carry) {
			*pip=(n>=128) ? ip-(255-n&0x7f) : ip+n+1;
		} else {
			*pip=ip+1;
		}
		// printf("jc 0x%x ; to %x\n", n, *pip);
		return;
	}
	case 0x73: {
		int n=mem[ip];
		if (carry) {
			*pip=ip+1;
		} else {
			*pip=(n>=128) ? ip-(255-n&0x7f) : ip+n+1;
		}
		// printf("jnc 0x%x ; to %x\n", n, *pip);
		return;
	}
	case 0x87: {
		int n=mem[ip++];
		int d=getreg(n);
		int s=getreg(n>>3);
		int t=regs[d].val;
		regs[d].val=regs[s].val;
		regs[s].val=t;
		// printf("xchg %s(%d), %s(%d)\n", regnames[d], regs[d].val,  regnames[s], t);
		break;
	}
	case 0x88: {
		byte n=mem[ip++];
		int d=getreg(n);
		int s=getreg(n>>3);
		if (n&0xC0) {
			regs[d].s.lsb=regs[s].s.lsb;
			// printf("mov %s.l <- %s.l\n", regnames[d], regnames[s]);
		} else if (n&7==7) {
			mem[bx.val]=regs[s].s.lsb;
			// printf("mov [bx] <- %s.l (%d)\n", regnames[s], mem[bx.val]);
		} else {
			unimpl("opcode 88+", n, 14);
		}
		break;
	}
	case 0x89: {
		byte n=mem[ip++];
		int d=getreg(n);
		int s=getreg(n>>3);
		if (n&0xC0) {
			regs[d].val=regs[s].val;
			// printf("mov %s <- %s\n", regnames[d], regnames[s]);
		} else if (n==0x1D) {
			// printf("mov [di], bx ([%x] <- %x)\n", di.val, bx.val);
			mem[di.val]=bx.s.lsb;
			mem[di.val+1]=bx.s.msb;
		} else {
			unimpl("opcode 89+", n, 15);
		}
		break;
	}
	case 0x8A: {
		byte n=mem[ip++];
		int s=getreg(n);
		int d=getreg(n>>3);
		if (s==7) {
			bx.s.lsb=mem[bx.val];
			// printf("mov bl <- [%s]\n", regnames[d]);
		} else {
			unimpl("opcode 8A+", n, 12);
		}
		break;
	}
	case 0x8B: {
		byte n=mem[ip++];
		int s=getreg(n);
		int d=getreg(n>>3);
		if (s==7) {
			int t=bx.val;
			regs[d].s.lsb=mem[t];
			regs[d].s.msb=mem[t+1];
			// printf("mov bx <- [%s]\n", regnames[d]);
		} else if (n==0x1D) {
			bx.s.lsb=mem[di.val];
			bx.s.msb=mem[di.val+1];
		} else if (n==0x35) {
			si.s.lsb=mem[di.val];
			si.s.msb=mem[di.val+1];
		} else {
			unimpl("opcode 8B+", n, 11);
		}
		break;
	}
	case 0x8F: {
		byte n=mem[ip++];
		if (n==7) {
			mem[bx.val]=mem[sp.val];
			mem[bx.val+1]=mem[sp.val+1];
			sp.val+=2;
			// printf("pop word [bx]\n");
		} else {
			unimpl("opcode 8F+", n, 11);
		}
		break;
	}
	case 0x91:
	case 0x92:
	case 0x93:
	case 0x94:
	case 0x95:
	case 0x96:
	case 0x97: {
		int s=getreg(o);
		int t=ax.val;
		ax.val=regs[s].val;
		regs[s].val=t;
		// printf("xchg ax(%d), %s(%d)\n", ax.val, regnames[s], t);
		break;
	}
	case 0x98:
		// printf("cbw: 0x%x -> ", ax.val);
		if (ax.s.lsb & 0x80) {		// if msb is set
			ax.val=-(256-ax.s.lsb); // sign extend the lsb
		} else {
			ax.s.msb=0;
		}
		// printf("0x%x\n", ax.val);
		break;
	case 0xAB:
		mem[df ? di.val-- : di.val++]=ax.s.lsb;
		mem[df ? di.val-- : di.val++]=ax.s.msb;
		// printf("stored ax(%d) in [di]++\n", ax.val);
		break;
	case 0xAC:
		ax.s.lsb=mem[df ? si.val-- : si.val++];
		// printf("stored %d in al\n", ax.s.lsb);
		break;
	case 0xAD:
		ax.s.lsb=mem[df ? si.val-- : si.val++];
		ax.s.msb=mem[df ? si.val-- : si.val++];
		// printf("stored %d in ax\n", ax.val);
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
	case 0xD3: {
		int n=mem[ip++];
		int r=getreg(n);
		x86register *x=&regs[r];
		if (n&0x8) {
			x->val >>= cx.val;
		} else {
			x->val <<= cx.val;
		}
		break;
	}
	case 0xEB: {
		int n=mem[ip];
		*pip=(n>=128) ? ip-(255-n&0x7f) : ip+n+1;
		// printf("jmp %d ; to %x\n", n&0x7f, *pip);
		return;
	}
	case 0xEC:
		// printf("port is %d\n", dx.val);
		if (dx.val==0x3f8) {
			ax.s.lsb=getchar();
		} else if (dx.val==0x3fd) {
			ax.s.lsb=1;
		} else {
			die("unknown port", 16);
		}
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
		if (sp.val!=0x100) {
			die("stack is not empty", 10);
		}
		// printf("halt\n");
		fprintf(stderr, "data stack max depth: %d\n", ds_base-ds_depth);
		fprintf(stderr, "return stack max depth: %d\n", rs_depth-rs_base);
		exit(0);
	case 0xF7: {
		int n=mem[ip++];
		int r=getreg(n);
		x86register *x=&regs[r];
		if ((n&0xD8)==0xD8) {
			x->val = -x->val;
			// printf("neg\n");
			carry=(x->val ? 1 : 0);
			// printf("carry=%d\n", carry);
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
	sp.val=0x100;
	ds_base=sp.val;
	ds_depth=sp.val;
#ifdef DEBUG
	int prev=si.val;
#endif
	for(;;) {
		if (sp.val < ds_depth) {
			ds_depth = sp.val;
		}
		if (start) {
			if (di.val > rs_depth) {
				rs_depth = di.val;
			}
		}
		emul(mem, &ip);
#ifdef DEBUG
		if (si.val != prev) {
			printf("\nForth IP: 0x%x\n", si.val);
			prev=si.val;
		}
#endif
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
