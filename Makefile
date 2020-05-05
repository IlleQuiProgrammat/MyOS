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
	rm -rf lightrod.img lightrod_img
	mkdir -p ./lightrod_img/
	dd if=/dev/zero bs=1M count=0 seek=64 of=lightrod.img
	parted -s lightrod.img mklabel gpt
	parted -s lightrod.img mkpart primary 2048s 6143s
	parted -s lightrod.img mkpart primary 6144s 131038s
	sudo losetup -Pf --show lightrod.img > loopback_dev
	sudo partprobe `cat loopback_dev`
	sudo mkfs.ext2 `cat loopback_dev`p2
	sudo mount `cat loopback_dev`p2 lightrod_img
	sudo mkdir lightrod_img/boot
	sudo cp -avr sysroot/* lightrod_img/
	sync
	sudo umount lightrod_img/
	sudo losetup -d `cat loopback_dev`
	rm -rf lightrod_img loopback_dev
	./qloader2/qloader2-install ./qloader2/qloader2.bin lightrod.img 2048

all: lightrod.img

qemu: lightrod.img
	qemu-system-x86_64 -hda lightrod.img -debugcon stdio

clean:
	for PROJECT in $(PROJECTS); do \
		(cd $$PROJECT && make clean) \
	done

	rm -rf sysroot
	rm -rf mnt/*
	rm -rf isodir
	rm -rf lightrod.iso
	# rm -rf lightrod.img
