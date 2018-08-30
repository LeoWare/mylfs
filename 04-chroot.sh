#!/bin/bash
set -o errexit
set -o nounset
set +h
source config.inc
source function.inc

# 6.2 Preparing Virtual Kernel File Systems
if ! [[ -d "${LFS}/dev" ]]; then
	mkdir -pv ${LFS}/{dev,proc,sys,run}
	mknod -m 600 ${LFS}/dev/console c 5 1
	mknod -m 666 ${LFS}/dev/null c 1 3
fi

if ! mountpoint ${LFS}/dev	>/dev/null 2>&1; then mount --bind /dev ${LFS}/dev; fi
if ! mountpoint ${LFS}/dev/pts	>/dev/null 2>&1; then mount -t devpts devpts ${LFS}/dev/pts -o gid=5,mode=620; fi
if ! mountpoint ${LFS}/proc	>/dev/null 2>&1; then mount -t proc proc ${LFS}/proc; fi
if ! mountpoint ${LFS}/sys 	>/dev/null 2>&1; then mount -t sysfs sysfs ${LFS}/sys; fi
if ! mountpoint ${LFS}/run	>/dev/null 2>&1; then mount -t tmpfs tmpfs ${LFS}/run; fi
if [ -h ${LFS}/dev/shm ];			 then mkdir -pv ${LFS}/$(readlink ${LFS}/dev/shm); fi

# 6.4 Entering the Chroot Environment
msg "Entering chroot environment."
chroot "$LFS" /tools/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h

if mountpoint ${LFS}/run	>/dev/null 2>&1; then umount ${LFS}/run; fi
	if mountpoint ${LFS}/sys	>/dev/null 2>&1; then umount ${LFS}/sys; fi
	if mountpoint ${LFS}/proc	>/dev/null 2>&1; then umount ${LFS}/proc; fi
	if mountpoint ${LFS}/dev/pts	>/dev/null 2>&1; then umount ${LFS}/dev/pts; fi
	if mountpoint ${LFS}/dev	>/dev/null 2>&1; then umount ${LFS}/dev; fi
