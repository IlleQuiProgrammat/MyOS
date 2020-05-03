#!/bin/sh
set -e
. ./build.sh

mkdir -p mnt/boot

cat << EOF >> mnt/boot/qloader2.cfg
TIMEOUT=10
KERNEL_PARTITION=0
KERNEL_PATH=/boot/lightrod.kernel
KERNEL_PROTO=stivale

EOF

cp -avr sysroot/* ./mnt/