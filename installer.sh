#!/bin/bash
#-----------------------------------------------------------------------------
#	Title: installer.sh
#	Date: 2018-09-09
#	Version: 1.0
#	Author: baho-utot@columbus.rr.com
#	Options:
#-----------------------------------------------------------------------------
#	This script installs LFS base rpms to a partition mounted at /mnt
#	the partition should be a new/clean partition as it will be overwritten
#-----------------------------------------------------------------------------
set -o errexit	# exit if error...insurance ;)
set -o nounset	# exit if variable not initalized
set +h			# disable hashall
#-----------------------------------------------------------------------------
PRGNAME=${0##*/}			#	script name minus the path
ARCH=$(uname -m)			#	fetch arch type
PARENT=/usr/src/LFS-RPM		#	rpm build directory
REPOPATH=RPMS/${ARCH}		#	path to the binary rpms
DBPATH=/var/lib/rpm			#	path to the rpm database rel to ROOTPATH
SPEC=SPECS/lfs-base.spec		#	lfs-base meta package
LIST=""				#	list of rpms from lfs-base.spec
CMD=""					#	List of Main line prcoesses
#-----------------------------------------------------------------------------
#	filesystem rpm should be installed first
#-----------------------------------------------------------------------------
die() {
	local _red="\\033[1;31m"
	local _normal="\\033[0;39m"
	[ -n "$*" ] && printf "${_red}$*${_normal}\n"
	exit 1
}
_get_list() {
	local i=""
	if [ -e ${SPEC} ]; then
		while  read i; do
			i=$(echo ${i} | tr -d '[:cntrl:][:space:]')
			case ${i} in
				Requires:*)	LIST+="${i##Requires:} "	;;
				*)						;;
			esac
		done < ${SPEC}
		LIST=${LIST## }
	else
		die "ERROR: get_list: ${SPEC}: does not exist"
	fi
	return
}
_install(){
	local i=""
	local target="/mnt/usr/src/LFS-RPM/${REPOPATH}"
	install -vdm 755 /mnt/${DBPATH}
	install -vdm 755 ${target}
	rpmdb --verbose --initdb --dbpath=/mnt/${DBPATH}
	for i in ${LIST}; do
		rpm --upgrade --verbose --hash --nodeps --noscripts --root /mnt --dbpath ${DBPATH} ${REPOPATH}/${i}-[0-9]*-*.*.rpm
		cp ${REPOPATH}/${i}-[0-9]*-*.*.rpm ${target}
	done
	rpm --upgrade --verbose --hash --replacepkgs --root /mnt --dbpath ${DBPATH} ${REPOPATH}/linux-[0-9]*-*.*.rpm
	return
}
_config() {
	local i=""
	local list=""
		/sbin/ldconfig
		list="/etc/sysconfig/clock "
		list+="/etc/passwd "
		list+="/etc/hosts "
		list+="/etc/hostname "
		list+="/etc/fstab "
		list+="/etc/sysconfig/ifconfig.eth0 "
		list+="/etc/resolv.conf "
		list+="/etc/lsb-release "
		list+="/etc/sysconfig/rc.site"
		for i in ${list}; do vim "/mnt${i}"; done
	return
}
_copy_rpms() {
	local source="${REPOPATH}/*"
	local target="/mnt/usr/src/LFS-RPM/${REPOPATH}"
	install -vdm 755 ${target}
	cp -va ${source} ${target}
	return
}
#-----------------------------------------------------------------------------
#	Main line
[ ${EUID} -eq 0 ]	|| die "${PRGNAME}: Need to be root user: FAILURE"
pushd ${PARENT}	|| die "Error: Can not change directory to ${PARENT}"
mountpoint -q /mnt	|| die "Hey /mnt is not mounted"
CMD="_get_list _install _config "
for i in ${CMD};do ${i};done
popd
exit
