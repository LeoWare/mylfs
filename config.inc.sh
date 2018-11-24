# config.inc.sh

# Define environment variables

# Where the build system is installed
#
# This variable is used both to find
# the installer system on the host system
# (${PARENT}),
# and to find the build system within the
# build environment
# (${LFS}${PARENT}).
# in the chroot environment, the build
# system is accessed with ${PARENT}
PARENT=/usr/src/lfs

# LFS user name
# System will build with this user
LFS_USER="lfs"

# LFS Partition
DEVICE=/dev/loop1

# Filesystem type
FILESYSTEM=ext4

# Mount point for DEVICE
# This should be the root of the new partition
LFS=/mnt/lfs

# Boot Partition
BOOT_DEVICE=/dev/loop0

# Boot partition filesystem type
BOOT_FS=vfat

# Mount point for $BOOT_DEVICE
BOOT=/boot/efi

### STOP EDITING HERE ###
#
# The rest of this file shouldn't need editing
# If you need to edit it, please send me a note
# through github as to why.

# Pretty system title
SYSTEM="Linux from Scratch 8.2-systemd"

# Directories

# Where to build the tool chain
TOOLS=/tools

SCRIPTSDIR="${PARENT}/scripts"
SOURCESDIR="${PARENT}/sources"
BUILDDIR="${PARENT}/build"
LOGDIR="${PARENT}/logs"

# Compilation target
LFS_TGT="$(uname -m)-lfs-linux-gnu"

# Make flags
MKFLAGS="-j $(getconf _NPROCESSORS_ONLN)"

# Name of the log file
LOGFILE="$(date +%Y-%m-%d).log"


# vim modeline
# vim: syntax=sh:ts=4:sw=4:
