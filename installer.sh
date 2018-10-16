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
PRGNAME=${0##*/}		#	script name minus the path
PARENT=/usr/src/LFS-RPM	#	rpm build directory
ARCH=$(umane -m)		#	fetch arch type
REPOPATH="RPMS/${ARCH}"	#	path to the binary rpms
ROOTPATH="/mnt"		#	path to install filesystem
DBPATH="/var/lib/rpm"	#	path to the rpm database rel to ROOTPATH
LIST=""			#	list of rpms from lfs-base.spec
#-----------------------------------------------------------------------------
#	filesystem rpm should be installed first
#-----------------------------------------------------------------------------
die() {
	local _red="\\033[1;31m"
	local _normal="\\033[0;39m"
	[ -n "$*" ] && printf "${_red}$*${_normal}\n"
	exit 1
}
get_list() {
	local i=""
	local spec="${1}"
	if [ -e ${spec} ]; then
		while  read i; do
			i=$(echo ${i} | tr -d '[:cntrl:][:space:]')
			case ${i} in
				Requires:*)	LIST+="${i##Requires:} "	;;
				*)						;;
			esac
		done < ${spec}
		#	remove trailing whitespace
		LIST=${LIST## }
	else
		die "ERROR: get_list: ${spec}: does not exist"
	fi
	return
}
#-----------------------------------------------------------------------------
[ ${EUID} -eq 0 ] || die
if [ ! /usr/bin/mountpoint ${ROOTPATH} > /dev/null 2>&1 ]; then die "Hey ${ROOTPATH} is not mounted"; fi
/usr/bin/install -vdm 755 "${ROOTPATH}/${DBPATH}"
/usr/bin/rpmdb --verbose --initdb --dbpath=${ROOTPATH}/${DBPATH}
cd ${PARENT} || die "Error: Can not change directory to ${PARENT}"
for i in ${LIST}; do
	/bin/rpm --upgrade --nodeps --noscripts --root ${ROOTPATH} --dbpath ${DBPATH} ${REPOPATH}/${i}-[0-9]*-*.*.rpm
	/bin/printf "%s\n" ${i}
done
/bin/cat > ${ROOTPATH}/tmp/script.sh <<- EOF
	/sbin/ldconfig
	/sbin/locale-gen.sh
	/usr/sbin/pwconv
	/usr/sbin/grpconv
	/usr/bin/vim /etc/sysconfig/clock
	/usr/bin/vim /etc/passwd
	/usr/bin/vim /etc/hosts
	/usr/bin/vim /etc/hostname
	/usr/bin/vim /etc/fstab
	/usr/bin/vim /etc/sysconfig/ifconfig.enp5s0 
	/usr/bin/vim /etc/resolv.conf
	/usr/bin/vim /etc/lsb-release
	/usr/bin/vim /etc/sysconfig/rc.site
EOF
/bin/chmod +x ${ROOTPATH}/tmp/script.sh
/usr/sbin/chroot ${ROOTPATH} /usr/bin/env -i \
	HOME=/root \
	TERM="${TERM}" \
	PS1='(intsaller) \u:\w:\$' \
	PATH=/bin:/usr/bin:/sbin:/usr/sbin \
	/bin/bash --login -c 'cd /tmp;./script.sh'
printf "%s\n" "Installation is complete"
