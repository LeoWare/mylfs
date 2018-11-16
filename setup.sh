#!/bin/bash
set -o errexit
set -o nounset
set +h

source ./config.inc.sh
source ./function.inc.sh

PRGNAME=${0##*/}
LOGFILE="${LOGDIR}/${PRGNAME}-${LOGFILE}"

# This file creates the $LFS/tools directory,
# adds the LFS user, and creates .bash_profile,
# and .bashrc

msg_section "Beginning Setup for ${SYSTEM}"

# We must be root to run this file
msg_line "Are we root? "
check_root
msg_success "Yes"

# Check that the environment variables are set
msg "Checking environment variables:"
check_environment
msg_success "Environment is good."

# 2.7 Mounting the New Partition
# create directory: $LFS
msg_line "Checking for ${LFS}: "
if [ ! -d ${LFS} ]; then
	msg_warning "Not found."
 	build "Creating ${LFS}: " "install -vdm 755 ${LFS}" "${LOGFILE}"
else
	msg_success "Found ${LFS}."
fi

msg_line "Checking for mounted LFS partition: "
if ! mountpoint $LFS >/dev/null 2>&1; then
	msg_warning "not mounted."
	build "Mounting ${DEVICE} to ${LFS}" "mount -v -t ${FILESYSTEM} ${DEVICE} ${LFS} " "${LOGFILE}"
else
	msg_success "${LFS} is mounted."
fi

# create directory: ${LFS}${BOOT}
msg_line "Checking for ${LFS}${BOOT}: "
if [ ! -d ${LFS} ]; then
	msg_warning "Not found."
 	build "Creating ${LFS}${BOOT}: " "install -vdm 755 ${LFS}${BOOT}" "${LOGFILE}"
else
	msg_success "Found ${LFS}"
fi

msg_line "Checking for mounted BOOT partition: "
if ! mountpoint ${LFS}${BOOT} >/dev/null 2>&1; then
	msg_warning "not mounted."
	build "	Mounting ${BOOT_DEVICE} to ${LFS}${BOOT}" "mount -v -t ${BOOT_FS} ${BOOT_DEVICE} ${LFS} " "${LOGFILE}"
else
	msg_success "${LFS}${BOOT} is mounted."
fi

# 3.1 All Packages

# download all packages into SOURCES
msg "Fetching sources: "
build "	Install directory: ${SOURCESDIR}" "install -vdm 755 ${SOURCESDIR}" "${LOGFILE}"
build "	Fetching LFS packages: " "wget --input-file=wget-lfs -4 -nc --continue --directory-prefix=${SOURCESDIR} --no-check-certificate" "${LOGFILE}"
build "	Fetching EFI packages: " "wget --input-file=wget-efi -4 -nc --continue --directory-prefix=${SOURCESDIR} --no-check-certificate" "${LOGFILE}"

# check the md5 sums
pushd ${SOURCESDIR}
md5sum -c ../md5sums-lfs
#md5sum -c ../md5sums-efi
popd

# 4.2 Creating the $LFS/tools Directory
msg_line "Checking for ${LFS}${TOOLS}"
if [ ! -d ${LFS}/tools ]; then
	msg_warning "not found."
	build "	Creating ${LFS}${TOOLS}: " "install -vdm 755 ${LFS}${TOOLS}" "${LOGFILE}"
else
	msg
fi

msg_line "Checking for $TOOLS symlink: "
if [ ! -h ${TOOLS} ]; then
	msg_warning "not found."
	build "	Creating symlink - ${TOOLS}: " "ln -sv ${LFS}${TOOLS} /" "${LOGFILE}"
else
	msg_success "found."
fi

# 4.3 Adding the LFS user
msg_line "Checking for group ${LFS_USER}: "
if [ -z `getent passwd ${LFS_USER}` ]; then
	msg_warning "not found."
	build "	Creating lfs group" "groupadd ${LFS_USER}" "${LOGFILE}"
else
	msg_success "found."
fi
msg_line "Checking for ${LFS_USER}: "
if [ -z `getent passwd ${LFS_USER}` ]; then
	msg_warning "not found."
	msg "	Adding lfs user to host: "
	getent group  ${LFS_USER} > /dev/null 2>&1 || build "	Creating group: ${LFS_USER}" "groupadd ${LFS_USER}" "${LOGFILE}"
	getent passwd ${LFS_USER} > /dev/null 2>&1 || build "	Creating user: ${LFS_USER}" "useradd -c 'LFS user' -g ${LFS_USER} -m -k /dev/null -s /bin/bash ${LFS_USER}" "${LOGFILE}"
else
	msg_success "found."
fi

# 4.4 Setting Up the Environment
msg "Checking for .bash_profile and .bashrc"
if [ ! -f /home/${LFS_USER}/.bash_profile ]; then
	# create .bash_profile for the lfs user
	msg_line "	Creating /home/${LFS_USER}/.bash_profile: "
	cat > /home/${LFS_USER}/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
	msg_success
fi

if [ ! -f /home/${LFS_USER}/.bashrc ]; then
	# create .bashrc for the lfs user
	msg_line "	Creating /home/${LFS_USER}/.bashrc: "
	cat > /home/${LFS_USER}/.bashrc <<- EOF
set +h
umask 022
LFS=${LFS}
PARENT=${PARENT}
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PARENT PATH
alias ls='ls -C --color=auto'
EOF
	msg_success
fi

build "	Changing ownership /home/${LFS_USER}" "chown -Rv ${LFS_USER}:${LFS_USER} /home/${LFS_USER}" "${LOGFILE}"

#
#	Set ownership of build directory to $LFS
#
build "Set ownership of ${PARENT} to ${LFS_USER}" "chown -R ${LFS_USER}:${LFS_USER} ${PARENT}" "${LOGFILE}"

#
#	Copy build system to $LFS
#
LIST="book build logs scripts sources "				# directories
LIST+="README.MD "									# docs
LIST+="config.inc.sh function.inc.sh "				# build system config files
LIST+="config-4.15.3-lfs.x86_64 "					# kernel config
LIST+="locale-gen.conf locale-gen.sh "				# locale definition files
LIST+="md5sums-lfs md5sums-efi wget-lfs wget-efi "	# source package data
LIST+="locale-gen.sh version-check.sh "				# lfs scripts
LIST+="toolchain.sh build.sh go-chroot.sh"			# build system scripts

msg "Install build system: "
build "	Installing directories: " "install -vdm 755 ${LFS}${PARENT}/{book,build,logs,scripts,sources}" "${LOGFILE}"
build "	Copying files: " "cp -var ${LIST} ${LFS}${PARENT}" "${LOGFILE}"
build "	Setting ownership to user ${LFS_USER}" "chown -R ${LFS_USER}:${LFS_USER} ${LFS}" "${LOGFILE}"

msg_section "Setup Complete"

msg "Change directory to ${LFS}${PARENT} and execute ./build.sh"

exit 0 
