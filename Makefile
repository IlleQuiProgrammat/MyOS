CPARAMS = -ffreestanding -O2 -Wall -Wextra
ASMPARAMS =
LDPARAMS = -m elf_i386
CC = i686-elf-gcc
ASMC = i686-elf-as
OBJECTS = src/kernel.o src/loader.o

%.o: %.c
	$(CC) $(CPARAMS) -c $< -o $@

%.o: %.s
	$(ASMC) $(ASMPARAMS) -o $@ $<

mykernel.bin: src/linker.ld $(OBJECTS)
	i686-elf-ld $(LDPARAMS) -T $< -o $@ src/*.o

mykernel.iso: mykernel.bin
	cp mykernel.bin iso/boot/mykernel.bin
	grub-mkrescue --output=mykernel.iso iso

clean:
	rm mykernel.bin
	rm mykernel.iso
	rm ./**/*.o
	rm ./**/*.bin
