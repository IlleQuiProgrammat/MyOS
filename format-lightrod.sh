set -e 

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ./lightrod.img
	o # clear the in memory partition table \
	n # new partition \
	p # primary partition \
	1 # partition number 1 \
		# default - start at beginning of disk \ 
		# 100 MB boot parttion \
	a # make a partition bootable \
	w # write the partition table \
	q # and we're done \
EOF