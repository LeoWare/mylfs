#!/bin/bash
#-----------------------------------------------------------------------------
#	Title: installer.sh
#	Date: 2018-09-09
#	Version: 1.0
#	Author: baho-utot@columbus.rr.com
#	Options:
#-----------------------------------------------------------------------------
#	This script installs rpms to a partition mounted at /mnt
#	the partition should be a new/clean partition as it will be overwritten
#-----------------------------------------------------------------------------
set -o errexit	# exit if error...insurance ;)
set -o nounset	# exit if variable not initalized
set +h			# disable hashall
#-----------------------------------------------------------------------------
REPOPATH="RPMS/x86_64"
ROOTPATH="/mnt"
DBPATH="/var/lib/rpm"
LIST="filesystem "
LIST+="acl attr autoconf automake "
LIST+="bash bc binutils bison bzip2 "
LIST+="check coreutils "
LIST+="diffutils "
LIST+="e2fsprogs eudev expat "
LIST+="file findutils firmware-radeon firmware-realtek flex "
LIST+="gawk gcc gdbm gettext glibc gmp gperf grep groff grub gzip "
LIST+="iana-etc inetutils intltool iproute2 "
LIST+="kbd kmod "
LIST+="less lfs-bootscripts libcap libelf libffi libpipeline libtool "
LIST+="linux linux-api-headers "
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
install -vdm 755 ${ROOTPATH}/${DBPATH}
rpmdb --verbose --initdb --dbpath=${ROOTPATH}/${DBPATH}
for i in ${LIST}; do
		rpm -Uvh --nodeps --noscripts --root ${ROOTPATH} --dbpath ${DBPATH} RPMS/x86_64/${i}-[0-9]*-*.*.rpm
done
_list="${ROOTPATH}/etc/sysconfig/clock "
_list+="${ROOTPATH}/etc/passwd "
_list+="${ROOTPATH}/etc/hosts "
_list+="${ROOTPATH}/etc/hostname "
_list+="${ROOTPATH}/etc/fstab "
_list+="${ROOTPATH}/etc/sysconfig/ifconfig.enp5s0 "
_list+="${ROOTPATH}/etc/resolv.conf "
_list+="${ROOTPATH}/etc/lsb-release "
_list+="${ROOTPATH}/etc/sysconfig/rc.site"
for i in ${_list}; do vim "${i}"; done
printf "\n%s\n" "boot to new system and run: /sbin/ldconfig"
printf "\n%s\n" "boot to new system and run: /sbin/locale-gen.sh"
printf "\n%s\n" "boot to new system and run: /usr/sbin/pwconv"
printf "\n%s\n" "boot to new system and run: /usr/sbin/grpconv"
printf "\n%s\n" "boot to new system and run: /bin/passwd"
