#!/bin/bash
set -o errexit
set -o nounset
set +h

source config.inc.sh
source function.inc.sh

_red="\\033[1;31m"
_green="\\033[1;32m"
_normal="\\033[1;39m"

PRGNAME=${0##*/}	# script name minus the path
LOGFILE="${LOGDIR}/${PRGNAME}-${LOGFILE}"	# set log file name

msg_section "Beginning Build: ${SYSTEM}"

# We must be root to run this file
msg_line "Are we root? "
check_root
msg_success "Yes"

# Check that the environment variables are set
msg "Checking environment variables:"
check_environment
msg_success "Environment is good. Continue."

umount_kernel_vfs

# Have we already built the toolchain?
msg_line "Is the toolchain built? "
if [ -e "${LOGDIR}/toolchain.completed" ]; then
	msg_success "Yes"
else
	msg_warning "No"
	msg_section "Building Toolchain"
	build_toolchain
	msg_section "Toolchain Complete"
fi

# Has the file system been installed?
msg_line "Is the filesystm installed? "
if [ -e "${LOGDIR}/filesystem.completed" ]; then
	msg_success "Yes"
else
	msg_warning "No"
	msg_section "Building Filesystem"
	#build_filesystem
	build_shell_filesystem
#	msg_line "Installing Filesystem: "
#	install_filesystem
	msg_success
fi

# Change ownership of $LFS to root
if [ ! -e "${LOGDIR}/change_ownership.completed" ]; then
	msg_line "Change ownership of ${LFS} to root: "
	build "chown -R 0:0 ${LFS}/*" "chown -R 0:0 ${LFS}/*" "${LOGDIR}/change_ownership.completed"
	msg_success
fi

# Mount kernel filesystems
msg_line "Mounting kernel virtual filesystems: "
mount_kernel_vfs
msg_success

# Enter chroot and start the build
#msg_section "Starting RPM Build"
#build_rpms
#msg_section "RPM Build Complete"

# Enter chroot and start the build
msg_section "Starting Shell Script Build"

for script in scripts/*.sh ; do
	if [ -r $script ] ; then
		. $script
	fi
done

msg_section "Shell Script Build Complete"

# Unmount kernel filesystems
msg_line "Unmounting kernel virtual filesystems: "
umount_kernel_vfs
msg_success

msg_section "Build Complete"