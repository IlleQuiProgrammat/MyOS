#!/bin/sh
set -e
. ./build.sh

mkdir -p isodir
mkdir -p isodir/boot
mkdir -p isodir/boot/grub

cp sysroot/boot/lightrod.kernel isodir/boot/lightrod.kernel
cat > isodir/boot/grub/grub.cfg << EOF
menuentry "lightrod" {
	multiboot /boot/lightrod.kernel
}
EOF
grub-mkrescue -o lightrod.iso isodir
