include make.config
sysroot:
	for PROJECT in $(PROJECTS); do \
		(cd $$PROJECT && make install) \
	done

lightrod.img: sysroot
	rm lightrod.img
	dd if=/dev/zero bs=1M count=0 seek=64 of=lightrod.img
	LOOPDEV=$(losetup -f)
	losetup -Pf ./lightrod.img
	# format
	P1=p1
	mkdir -p mnt/boot
	mount $(LOOPDEV)$(P1) ./mnt
	cp -avr sysroot/* ./mnt/
	umount ./mnt
	losetup -d $(LOOPDEV)
	./qloader2/qloader2-install ./qloader2/qloader2.bin ./lightrod.img

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
	rm -rf lightrod.img
