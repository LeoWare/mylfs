#!/bin/bash -e
#-----------------------------------------------------------------------------
#	Title: chroot-lfs.sh
#	Date: 2018-08-27
#	Version: 1.0
#	Author: baho-utot@columbus.rr.com
#	Options:
#-----------------------------------------------------------------------------
#	This allows me to run LFS-8.2 under Fedora 28
#
MOUNTPOINT=/mnt
MOUNTPARTITION=/dev/sda5
mount "${MOUNTPARTITION}" "${MOUNTPOINT}"
#
#	Mount Virtual Kernel File Systems
#
mount -v --bind /dev /mnt/dev
mount -vt devpts devpts /mnt/dev/pts -o gid=5,mode=620
mount -vt proc proc /mnt/proc
mount -vt sysfs sysfs /mnt/sys
mount -vt tmpfs tmpfs /mnt/run
#-----------------------------------------------------------------------------
#	Git it did
chroot /mnt /usr/bin/env -i HOME=/root TERM=$TERM PS1='(blfs builder) \u:\w\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash --login
#-----------------------------------------------------------------------------
#	Cleanup
umount /mnt/run
umount /mnt/sys
umount /mnt/proc
umount /mnt/dev/pts
umount /mnt/dev
umount /mnt
#-----------------------------------------------------------------------------
#	See it is clean
mount
