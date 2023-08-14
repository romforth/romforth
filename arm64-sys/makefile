AS=aarch64-unknown-elf-as
LD=aarch64-unknown-elf-ld

all : forth
	qemu-aarch64 forth
forth: forth.o
	$(LD) -o $@ $<
forth.o: forth.S
	$(AS) -o $@ $<
clean:
	rm forth forth.o
