#!/bin/bash
#############################################
#       Title: tools.sh                     #
#        Date: 2018-03-23                   #
#     Version: 1.0                          #
#      Author: baho-utot@columbus.rr.com	#
#     Options:                              #
#############################################
set -o errexit		# exit if error...insurance ;)
set -o nounset		# exit if variable not initalized
set +h				# disable hashall
PRGNAME=${0##*/}	# script name minus the path
TOPDIR=${PWD}		# script lives here
#		Build variables
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
#
PARENT=/usr/src/Octothorpe
LOGPATH=${TOPDIR}/LOGS
INFOPATH=${TOPDIR}/INFO
SPECPATH=${TOPDIR}/SPECS
PROVIDESPATH=${TOPDIR}/PROVIDES
REQUIRESPATH=${TOPDIR}/REQUIRES
RPMPATH=${TOPDIR}/RPMS
#
#	Build functions
#
die() {
	local _red="\\033[1;31m"
	local _normal="\\033[0;39m"
	[ -n "$*" ] && printf "${_red}$*${_normal}\n"
	exit 1
}
msg() {
	printf "%s\n" "${1}"
}
msg_line() {
	printf "%s" "${1}"
}
msg_failure() {
	local _red="\\033[1;31m"
	local _normal="\\033[0;39m"
	printf "${_red}%s${_normal}\n" "FAILURE"
	exit 2
}
msg_success() {
	local _green="\\033[1;32m"
	local _normal="\\033[0;39m"
	printf "${_green}%s${_normal}\n" "SUCCESS"
	return 0
}
end-run() {
	local _green="\\033[1;32m"
	local _normal="\\033[0;39m"
	printf "${_green}%s${_normal}\n" "Run Complete"
	return
}
#
#	Build tool chain
#
./builder.sh tools-rpm
#
#	remove all un-needed files only leaving
#	what is needed to run rpm
msg "	Post processing:"
#	This preserves all the libraries that are needed
#	and removees evertything else so that only the static built
#	rpm and its libraries that are needed are left.
#	Keeps the LFS build clean of external packages.
#	rpm was placed into /usr/bin and /usr/lib
#	The chapter 6 iles will over write these files
if [ ! -e ${LOGPATH}/${PRGNAME} ]; then
	LIST="tools-zlib tools-popt tools-openssl tools-libelf tools-rpm"
	rm -rf ${TOPDIR}/BUILDROOT/* || true
	msg_line "	Saving libraries: "
	install -dm 755 ${TOPDIR}/BUILDROOT/tools/lib
	cp -a /tools/lib/libelf-0.170.so ${TOPDIR}/BUILDROOT/tools/lib
	cp -a /tools/lib/libelf.so ${TOPDIR}/BUILDROOT/tools/lib
	cp -a /tools/lib/libelf.so.1 ${TOPDIR}/BUILDROOT/tools/lib
	#	Saving rpm
	install -dm 755 ${TOPDIR}/BUILDROOT${LFS}/usr/bin
	install -dm 755 ${TOPDIR}/BUILDROOT${LFS}/usr/lib
	cp -ar ${LFS}/usr/bin/* ${TOPDIR}/BUILDROOT${LFS}/usr/bin
	cp -ar ${LFS}/usr/lib/* ${TOPDIR}/BUILDROOT${LFS}/usr/lib
	msg_success
	for i in ${LIST}; do
		msg_line "	Removing: ${i}: "
		rpm -e --nodeps ${i} > /dev/null 2>&1 || true
		msg_success
	done
	msg_line "	Moving libraries: "
	mv ${TOPDIR}/BUILDROOT/tools/lib/* /tools/lib
	install -dm 755 ${LFS}/usr/bin
	install -dm 755 ${LFS}/usr/lib
	cp -ar ${TOPDIR}/BUILDROOT${LFS}/usr/bin/* ${LFS}/usr/bin
	cp -ar ${TOPDIR}/BUILDROOT${LFS}/usr/lib/* ${LFS}/usr/lib
	msg_success
	msg_line "	Creating directories: "
	install -dm 755 ${LFS}/var/tmp
	chmod 1777 ${LFS}/var/tmp
	install -dm 755 ${LFS}/etc/rpm
	install -dm 755 ${LFS}/bin
	ln -s /tools/bin/bash ${LFS}/bin
	ln -s /tools/bin/sh ${LFS}/bin
	msg_success
	touch ${LOGPATH}/${PRGNAME}
else
		msg "	Post processing: Skipping"
fi
