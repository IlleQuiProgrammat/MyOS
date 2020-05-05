PROJECTS = libc kernel


LOOPDEV:=$(shell sudo losetup -f)
P1=p1

.PHONY: gather_sysroot kernel lightrod.img all qemu clean

gather_sysroot:
	@mkdir -p ./sysroot/usr/include
	@mkdir -p ./sysroot/usr/lib
	@mkdir -p ./sysroot/boot
	@cp --preserve=timestamps ./qloader2.cfg ./sysroot/boot/qloader2.cfg
	@cp -R --preserve=timestamps ./libc/include/. ./sysroot/usr/include
	@cp -R --preserve=timestamps ./kernel/include/kernel ./sysroot/usr/include
	-@cp -R --preserve=timestamps ./libc/libk.a ./sysroot/usr/lib

kernel: gather_sysroot
	for PROJECT in $(PROJECTS); do \
		(cd $$PROJECT && make all && make move_sysroot) \
	done
	

lightrod.img: kernel
	# -rm lightrod.img
	# dd if=/dev/zero bs=1M count=0 seek=64 of=lightrod.img
	# TODO: Move partition and move sysroot into it
	# ./format-lightrod.sh
	@sudo losetup -Pf ./lightrod.img
	# format
	@sudo mount $(LOOPDEV)$(P1) ./mnt
	@sudo mkdir -p mnt/boot
	@sudo cp -avr sysroot/* ./mnt/
	@sudo umount ./mnt
	@sudo losetup -d $(LOOPDEV)
	@./qloader2/qloader2-install ./qloader2/qloader2.bin ./lightrod.img

all: lightrod.img

qemu: lightrod.img
	qemu-system-x86_64 lightrod.img

clean:
	for PROJECT in $(PROJECTS); do \
		(cd $$PROJECT && make clean) \
	done

	rm -rf sysroot
	rm -rf mnt/*
	rm -rf isodir
	rm -rf lightrod.iso
	# rm -rf lightrod.img
