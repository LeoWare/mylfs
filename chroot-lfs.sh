#!/bin/bash -e
set -o errexit	# exit if error...insurance ;)
set -o nounset	# exit if variable not initalized
set +h			# disable hashall
#
#   Partition to mount @ /mnt
#
HOST=/dev/sda5
LFS=/dev/sdb3
MASTER=/home/scrat/Desktop/LFS-RPM
ROOT=/mnt
PARENT=/usr/src/LFS-RPM
#-----------------------------------------------------------------------------
#	Functions
_mount_partitions() {
	[ mountpoint '/mnt' > /dev/null 2>&1 ]		|| /bin/mount ${HOST} /mnt
#	[ mountpoint '/mnt/mnt/lfs' > /dev/null 2>&1 ]	|| /bin/mount ${LFS} /mnt/mnt/lfs
	return
}
_mount_kernel_filesystems () {
	#   Mount kernel filesystems
	/bin/mount -v --bind /dev /mnt/dev
	/bin/mount -vt devpts devpts /mnt/dev/pts -o gid=5,mode=620
	/bin/mount -vt proc proc /mnt/proc
	/bin/mount -vt sysfs sysfs /mnt/sys
	/bin/mount -vt tmpfs tmpfs /mnt/run
#	/bin/mount -v --bind ${MASTER} ${ROOT}${PARENT}
	return
}
_chroot() {
	#   chroot
/usr/sbin/chroot /mnt /usr/bin/env -i  \
    HOME=/root TERM=$TERM              \
    PS1='(lfs builder) \u:\w\$ '       \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login
    return
}
_cleanup() {
	#   Cleanup
	/bin/umount /mnt/run
	/bin/umount /mnt/sys
	/bin/umount /mnt/proc
	/bin/umount /mnt/dev/pts
	/bin/umount /mnt/dev
#	/bin/umount /mnt/mnt/lfs
#	/bin/umount ${ROOT}${PARENT}
	/bin/umount /mnt
	return
}
#-----------------------------------------------------------------------------
#	Main line
LIST="_mount_partitions _mount_kernel_filesystems _chroot _cleanup"
for i in ${LIST};do ${i};done
