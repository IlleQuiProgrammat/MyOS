#!/bin/sh
set -e
. ./build.sh


LOOPDEV=`losetup -f`
losetup -Pf ./test.img
P1="p1"
mount "$LOOPDEV$P1" ./mnt

rm -rf mnt/*

mkdir -p mnt/boot

cat << EOF >> mnt/boot/qloader2.cfg
TIMEOUT=10

:Lightrod

KERNEL_PARTITION=1
KERNEL_PATH=/boot/lightrod.ker
KERNEL_PROTO=stivale

EOF

cp -avr sysroot/* ./mnt/

umount ./mnt
losetup -d $LOOPDEV

./qloader2/qloader2-install ./qloader2/qloader2.bin ./test.img