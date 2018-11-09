# config.inc

# Define environment variables

# Mount point to build into
# This should be the root of the new partition
LFS=/mnt/lfs

# Where to build the tool chain
TOOLS=/tools

# Where the build system is installed
# This directory is appended to $LFS
PARENT=/usr/src/mylfs

# LFS user name
# System will build with this user
LFS_USER="lfs"
USER=$LFS_USER

# Compilation target
LFS_TGT="$(uname -m)-lfs-linux-gnu"

# Make flags
MKFLAGS="-j $(getconf _NPROCESSORS_ONLN)"

# Device to install GRUB
DEVICE=/dev/sdb3

# partition to mount to $LFS/boot
BOOT_DEVICE=/dev/sdb2

# Filesystem type
FILESYSTEM=ext4

# Name of the log file
LOGFILE="$(date +%Y-%m-%d).log"

# Directories
SOURCESDIR="SOURCES"
BUILDDIR="BUILD"
BUILDROOTDIR="BUILDROOT"
RPMSDIR="RPMS"
SRPMSDIR="SRPMS"
LOGDIR="LOGS"

# vim: syntax=sh:ts=4:sw=4:
