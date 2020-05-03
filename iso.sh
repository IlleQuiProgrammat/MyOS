#!/bin/sh
set -e
. ./build.sh

mkdir -p isodir
mkdir -p isodir/boot
mkdir -p isodir/boot/grub

cp sysroot/boot/lightrod.ker isodir/boot/lightrod.ker
cat > isodir/boot/grub/grub.cfg << EOF
menuentry "lightrod" {
	multiboot /boot/lightrod.ker
}
EOF
grub-mkrescue -o lightrod.iso isodir
