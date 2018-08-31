#!/bin/bash
set -o errexit
set -o nounset
set +h

source ./config.inc
source ./function.inc

PRGNAME=${0##*/}
LOGFILE="${LOGDIR}/${PRGNAME}-${LOGFILE}"

# This file creates the $LFS/tools directory,
# adds the LFS user, and creates .bash_profile,
# and .bashrc

# 4.2 Creating the $LFS/tools Directory

if [[ $EUID -ne 0 ]]; then
	echo "This must be run as root!"
	exit 1
fi

msg_section "LFS RPM BUILD SYSTEM SETUP"

# create directory: $LFS
[ -d ${LFS} ] || {
 build "Creating ${LFS}: " "install -vdm 755 ${LFS}" "${LOGFILE}"
 build "Mounting ${DEVICE} to ${LFS}" "mount -v ${DEVICE} -t ${FILESYSTEM} ${LFS} " "${LOGFILE}"
}

# create $LFS/tools
[ -d ${LFS}/tools ] || build "Creating ${LFS}/tools: " "install -vdm 755 ${LFS}/tools" "${LOGFILE}"
[ -h ${TOOLS} ] || build "Creating symlink - ${TOOLS}: " "ln -sv $LFS/tools /" "${LOGFILE}"

# 4.3 Adding the LFS user

[ -d /home/${LFS_USER} ] || {
	msg "Adding lfs user to host: "
	getent group  ${LFS_USER} > /dev/null 2>&1 || build "	Creating lfs group" "groupadd ${LFS_USER}" "${LOGFILE}"
	getent passwd ${LFS_USER} > /dev/null 2>&1 || build "	Creating lfs user" "useradd -c 'LFS user' -g ${LFS_USER} -m -k /dev/null -s /bin/bash ${LFS_USER}" "${LOGFILE}"
	# create .bashrc for the lfs user
	msg_line "    Creating /home/${LFS_USER}/.bashrc: "
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

	# create .bash_profile for the lfs user
	msg_line "Creating /home/${LFS_USER}/.bash_profile: "
	cat > /home/$LFS_USER/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
	msg_success

build "	Changing ownership /home/${LFS_USER}" "chown -R ${LFS_USER}:${LFS_USER} /home/${LFS_USER}" "${LOGFILE}"
}

# 3.1 All Packages

# download all packages into SOURCES
[ -d SOURCES ] || {
	msg "Fetching sources: "
	build " Create SOURCES directory" "install -vdm 755 SOURCES" "${LOGFILE}"
    build " Fetching LFS packages: " "wget --input-file=wget-lfs -4 -nc --continue --directory-prefix=SOURCES --no-check-certificate" "${LOGFILE}"
    build " Fetching RPM packages: " "wget --input-file=wget-rpm -4 -nc --continue --directory-prefix=SOURCES --no-check-certificate" "${LOGFILE}"

}
# check the md5 sums
pushd SOURCES
md5sum -c ../md5sums-lfs
md5sum -c ../md5sums-rpm
popd

#
#	Set ownership of build directory to $LFS
#
build "Set ownership of build directory to ${LFS_USER}" "chown -R ${LFS_USER}:${LFS_USER} ${PARENT}" "${LOGFILE}"

#
#	Copy build system to $LFS
#
LIST="BOOK LOGS SOURCES SPECS "				# directories
#LIST+="README README.MD "							# docs
#LIST+="config config-3.10.10-i686 config-3.13.3-x86_64 "			# configuration files
LIST+="locale-gen.conf "
LIST+="macros "									# configuration files
LIST+="md5sums-lfs md5sums-rpm wget-lfs wget-rpm "				# source package data
LIST+="locale-gen.sh version-check.sh "						# lfs scripts
LIST+="config.inc function.inc "						# build system includes
LIST+="toolchain.sh build-lfs.sh build-rpms.sh build-shell.sh"							# build system scripts
msg "Install build system: "
build "	Installing directories" "install -vdm 755 ${LFS}${PARENT}/{BOOK,BUILD,BUILDROOT,LOGS,RPMS,SOURCES,SPECS,SRPMS}" "${LOGFILE}"
build "	Copying files" "cp -var ${LIST} ${LFS}${PARENT}" "${LOGFILE}"
build "	Setting ownership to lfs user" "chown -R ${LFS_USER}:${LFS_USER} ${LFS}" "${LOGFILE}"

#build " Changing directory - ${LFS}${PARENT}:" "cd ${LFS}${PARENT}" "${LOGFILE}"

exit 0 
