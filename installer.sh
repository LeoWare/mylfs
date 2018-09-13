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
set +h		# disable hashall
#-----------------------------------------------------------------------------
PRGNAME=${0##*/}	#	script name minus the path
REPOPATH="RPMS/x86_64"	#	path to the binary rpms
ROOTPATH="/mnt"		#	path to install filesystem
DBPATH="/var/lib/rpm"	#	path to the rpm database rel to ROOTPATH
#-----------------------------------------------------------------------------
#	filesystem rpm should be installed first
LIST="filesystem "
LIST+="acl attr autoconf automake "
LIST+="bash bc binutils bison bzip2 "
LIST+="check coreutils cpio "
LIST+="diffutils "
LIST+="e2fsprogs eudev expat "
LIST+="file findutils firmware-radeon firmware-realtek flex "
LIST+="gawk gcc gdbm gettext glibc gmp gperf grep groff grub gzip "
LIST+="iana-etc inetutils intltool iproute2 "
LIST+="kbd kmod "
LIST+="less lfs-bootscripts libcap libelf libffi libpipeline libtool "
LIST+="mkinitramfs linux linux-api-headers "
LIST+="m4 make man-db man-pages meson mpc mpfr "
LIST+="ncurses ninja "
LIST+="openssl "
LIST+="patch perl pkg-config popt procps-ng psmisc python3 "
LIST+="readline rpm "
LIST+="sed shadow sysklogd sysvinit "
LIST+="tar texinfo tzdata "
LIST+="util-linux "
LIST+="vim "
LIST+="wget "
LIST+="XML-Parser xz "
LIST+="zlib "
#-----------------------------------------------------------------------------
die() {
	local _red="\\033[1;31m"
	local _normal="\\033[0;39m"
	[ -n "$*" ] && printf "${_red}$*${_normal}\n"
	exit 1
}
#-----------------------------------------------------------------------------
[ ${EUID} -eq 0 ] || die
if [ ! mountpoint ${ROOTPATH} > /dev/null 2>&1 ]; then die "Hey ${ROOTPATH} is not mounted"; fi
install -vdm 755 "${ROOTPATH}/${DBPATH}"
rpmdb --verbose --initdb --dbpath=${ROOTPATH}/${DBPATH}
for i in ${LIST}; do
	rpm --upgrade --nodeps --noscripts --root ${ROOTPATH} --dbpath ${DBPATH} ${REPOPATH}/${i}-[0-9]*-*.*.rpm
	echo ${i}
done
cat > ${ROOTPATH}/tmp/script.sh <<- EOF
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
chmod +x ${ROOTPATH}/tmp/script.sh
chroot ${ROOTPATH} /usr/bin/env -i \
	HOME=/root \
	TERM="${TERM}" \
	PS1='(intsaller) \u:\w:\$' \
	PATH=/bin:/usr/bin:/sbin:/usr/sbin \
	/bin/bash --login -c 'cd /tmp;./script.sh'
printf "%s\n" "Installation is complete"
