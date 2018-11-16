#!/bin/bash

source ./function.inc.sh

msg_line "Mounting kernel virtual filesystems: "
mount_kernel_vfs
msg_success

chroot "$LFS" /usr/bin/env -i          \
    HOME=/root                         \
    TERM="$TERM"                       \
    PS1='(lfs chroot) \u:\w\$ '        \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login

msg_line "Unmounting kernel virtual filesystems: "
umount_kernel_vfs
msg_success