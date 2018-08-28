#!/bin/bash -e
mount -v --bind /dev /mnt/dev
mount -vt devpts devpts /mnt/dev/pts -o gid=5,mode=620
mount -vt proc proc /mnt/proc
mount -vt sysfs sysfs /mnt/sys
mount -vt tmpfs tmpfs /mnt/run

chroot /mnt /usr/bin/env -i            \
    HOME=/root TERM=$TERM              \
    PS1='(lfs builder) \u:\w\$ '       \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login

umount /mnt/run
umount /mnt/sys
umount /mnt/proc
umount /mnt/dev/pts
umount /mnt/dev
