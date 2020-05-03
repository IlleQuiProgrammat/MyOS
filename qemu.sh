#!/bin/sh
set -e
. ./img.sh

qemu-system-$(./target-triplet-to-arch.sh $HOST) lightrod.img
