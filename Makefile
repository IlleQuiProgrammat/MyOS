CXXPARAMS = -Wall -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore
ASMPARAMS = -f elf64
LDPARAMS = 
CXXC = g++
ASMC = nasm
OBJECTS = src/kernel.o src/loader.o

%.o: %.cpp
	$(CXXC) $(GCCPARAMS) -c -o $@ $<

%.o: %.asm
	$(ASMC) $(ASMPARAMS) -o $@ $<

mykernel.bin: src/linker.ld $(OBJECTS)
	ld $(LDPARAMS) -T $< -o $@ src/*.o

mykernel.iso: mykernel.bin
	cp mykernel.bin iso/boot/mykernel.bin
	grub-mkrescue --output=mykernel.iso iso

clean:
	rm mykernel.bin
	rm mykernel.iso
	rm ./**/*.o
	rm ./**/*.bin
