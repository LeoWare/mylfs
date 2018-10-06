#!/bin/bash -e
#
#   Partition to mount @ /mnt
#
PARTITION=/dev/sda5
LFS=/dev/sdb3
[ mountpoint '/mnt' > /dev/null 2>&1 ]		|| /bin/mount ${PARTITION} /mnt
[ mountpoint '/mnt/mnt/lfs' > /dev/null 2>&1 ]	|| /bin/mount ${LFS} /mnt/mnt/lfs
#
#   Mount kernel filesystems
#
/bin/mount -v --bind /dev /mnt/dev
/bin/mount -vt devpts devpts /mnt/dev/pts -o gid=5,mode=620
/bin/mount -vt proc proc /mnt/proc
/bin/mount -vt sysfs sysfs /mnt/sys
/bin/mount -vt tmpfs tmpfs /mnt/run
#
#   chroot
#
/usr/sbin/chroot /mnt /usr/bin/env -i  \
    HOME=/root TERM=$TERM              \
    PS1='(lfs builder) \u:\w\$ '       \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login
#
#   Cleanup
#
/bin/umount /mnt/run
/bin/umount /mnt/sys
/bin/umount /mnt/proc
/bin/umount /mnt/dev/pts
/bin/umount /mnt/dev
/bin/umount /mnt/mnt/lfs
/bin/umount /mnt
