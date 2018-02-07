#!/bin/bash
#################################################
#	Title:	3-verify.sh			#
#        Date:	2018-02-02			#
#     Version:	1.0				#
#      Author:	baho-utot@columbus.rr.com	#
#     Options:					#
#################################################
#
set -o errexit					# exit if error...insurance ;)
set -o nounset					# exit if variable not initalized
set +h						# disable hashall
PRGNAME=${0##*/}				# script name minus the path
TOPDIR=${PWD}
LFS=/mnt/lfs
PARENT=/usr/src/Octothorpe
LOGFILE=$(date +%Y-%m-%d).log
#LOGFILE=${TOPDIR}/LOGS/${PRGNAME}		# set log file name
#LOGFILE=/dev/null				# uncomment to disable log file
#
#	Common support functions
#
die() {
	local _red="\\033[1;31m"
	local _normal="\\033[0;39m"
	[ -n "$*" ] && printf "${_red}$*${_normal}\n"
	false
	exit 1
}
msg() {
	printf "%s\n" "${1}"
	return
}
msg_line() {
	printf "%s" "${1}"
	return
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
	return
}
msg_log() {
	printf "\n%s\n\n" "${1}" >> ${_logfile} 2>&1
	return
}
end-run() {
	local _green="\\033[1;32m"
	local _normal="\\033[0;39m"
	printf "${_green}%s${_normal}\n" "Run Complete"
	return
}
#
#	Functions
#
_verify() {
	[ -e ${TOPDIR}/SOURCES/${1} ] || msg "	${1}: Missing"
	#	md5sum ${TOPDIR}/SOURCES/${1} > ${TOPDIR}/SOURCES/md5sum.${1}
	#	sed -i -e 's/\/mnt\/lfs\/usr\/src\/Octothorpe\/SOURCES\///' ${TOPDIR}/OTHER/md5sum.${1}
	#pushd ${TOPDIR}/SOURCES > /dev/null 2>&1
	#msg_line "	"
	#md5sum -c ../SOURCES/md5sum.${1}
	#popd > /dev/null 2>&1
	return
}
#
#	Main line
#
 LIST="XML-Parser acl attr autoconf automake "
LIST+="bash bash-patch bc binutils bison bzip2 bzip2-patch "
LIST+="check coreutils coreutils-patch "
LIST+="db dbus dejagnu diffutils "
LIST+="e2fsprogs elfutils eudev expat expect "
LIST+="file findutils flex "
LIST+="gawk gcc gdbm gettext glibc glibc-patch gmp gperf grep groff grub gzip "
LIST+="iana-etc inetutils intltool iproute2 "
LIST+="kbd kbd-patch kmod "
LIST+="less bootscripts libcap libpipeline libtool linux "
LIST+="m4 make man-db man-pages mpc mpfr ncurses openssl patch perl pkg-config popt procps-ng psmisc "
LIST+="readline rpm "
LIST+="sed shadow sysklogd systemd sysvinit sysvinit-patch tar "
LIST+="tcl-core texinfo tzdata "
LIST+="udev-lfs util-linux "
LIST+="vim "
LIST+="xz "
LIST+="zlib "
#
#	rpm files
#
LIST+="rpm elfutils popt openssl db openssh blfs wget "
for i in ${LIST};do
	case ${i} in
		XML-Parser)	_verify "XML-Parser-2.44.tar.gz"	;;
		acl)		_verify "acl-2.2.52.src.tar.gz"		;;
		attr)		_verify "attr-2.4.47.src.tar.gz"	;;
		autoconf)	_verify "autoconf-2.69.tar.xz"		;;
		automake)	_verify "automake-1.15.1.tar.xz"	;;
		bash)		_verify "bash-4.4-upstream_fixes-1.patch"
				_verify "bash-4.4.tar.gz"		;;
		bc)		_verify "bc-1.07.1.tar.gz"		;;
		binutils)	_verify "binutils-2.29.tar.bz2"		;;
		bison)		_verify "bison-3.0.4.tar.xz"		;;
		bzip2)		_verify "bzip2-1.0.6-install_docs-1.patch"
				_verify "bzip2-1.0.6.tar.gz"		;;
		check)		_verify "check-0.11.0.tar.gz"		;;
		coreutils)	_verify "coreutils-8.27.tar.xz"
				_verify "coreutils-8.27-i18n-1.patch"	;;
		db)		_verify "db-6.0.20.tar.gz"		;;
		dbus)		_verify "dbus-1.10.22.tar.gz"		;;
		dejagnu)	_verify "dejagnu-1.6.tar.gz"		;;
		diffutils)	_verify "diffutils-3.6.tar.xz"		;;
		e2fsprogs)	_verify "e2fsprogs-1.43.5.tar.gz"	;;
		elfutils)	_verify "elfutils-0.170.tar.bz2"	;;
		eudev)		_verify "eudev-3.2.2.tar.gz"		;;
		expat)		_verify "expat-2.2.3.tar.bz2"		;;
		expect)		_verify "expect5.45.tar.gz"		;;
		file)		_verify "file-5.31.tar.gz"		;;
		findutils)	_verify "findutils-4.6.0.tar.gz"	;;
		flex) 		_verify "flex-2.6.4.tar.gz"		;;
		gawk)		_verify "gawk-4.1.4.tar.xz"		;;
		gcc)		_verify "gcc-7.2.0.tar.xz"		;;
		gdbm)		_verify "gdbm-1.13.tar.gz"		;;
		gettext)	_verify "gettext-0.19.8.1.tar.xz"	;;
		glibc)		_verify "glibc-2.26.tar.xz"
				_verify "glibc-2.26-fhs-1.patch"	;;
		gmp)		_verify "gmp-6.1.2.tar.xz"		;;
		gperf)		_verify "gperf-3.1.tar.gz"		;;
		grep)		_verify "grep-3.1.tar.xz"		;;
		groff)		_verify "groff-1.22.3.tar.gz"		;;
		grub)		_verify "grub-2.02.tar.xz"		;;
		gzip)		_verify "gzip-1.8.tar.xz"		;;
		iana-etc)	_verify "iana-etc-2.30.tar.bz2"		;;
		inetutils)	_verify "inetutils-1.9.4.tar.xz"	;;
		intltool)	_verify "intltool-0.51.0.tar.gz"	;;
		iproute2)	_verify "iproute2-4.12.0.tar.xz"	;;
		kbd)		_verify "kbd-2.0.4.tar.xz"
				_verify "kbd-2.0.4-backspace-1.patch"	;;
		kmod)		_verify "kmod-24.tar.xz"		;;
		less)		_verify "less-487.tar.gz"		;;
		bootscripts)	_verify "lfs-bootscripts-20170626.tar.bz2"	;;
		libcap)		_verify "libcap-2.25.tar.xz"		;;
		libpipeline)	_verify "libpipeline-1.4.2.tar.gz"	;;
		libtool)	_verify "libtool-2.4.6.tar.xz"		;;
		linux)		_verify "linux-4.12.7.tar.xz"
				_verify "linux-4.9.67.tar.xz"		;;
		m4)		_verify "m4-1.4.18.tar.xz"		;;
		make)		_verify "make-4.2.1.tar.bz2"		;;
		man-db)		_verify "man-db-2.7.6.1.tar.xz"		;;
		man-pages)	_verify "man-pages-4.12.tar.xz"		;;
		mpc)		_verify "mpc-1.0.3.tar.gz"		;;
		mpfr)		_verify "mpfr-3.1.5.tar.xz"		;;
		ncurses)	_verify "ncurses-6.0.tar.gz"		;;
		openssl)	_verify "openssl-1.1.0f.tar.gz"		;;
		patch)		_verify "patch-2.7.5.tar.xz"		;;
		perl)		_verify "perl-5.26.0.tar.xz"		;;
		pkg-config)	_verify "pkg-config-0.29.2.tar.gz"	;;
		popt)		_verify "popt-1.16.tar.gz"		;;
		procps-ng)	_verify "procps-ng-3.3.12.tar.xz"	;;
		psmisc)		_verify "psmisc-23.1.tar.xz"		;;
		readline)	_verify "readline-7.0.tar.gz"		;;
		rpm)		_verify "rpm-4.14.0.tar.bz2"		;;
		sed)		_verify "sed-4.4.tar.xz"		;;
		shadow)		_verify "shadow-4.5.tar.xz"		;;
		sysklogd)	_verify "sysklogd-1.5.1.tar.gz"		;;
		systemd)	_verify "systemd-234-lfs.tar.xz"	;;
		sysvinit)	_verify "sysvinit-2.88dsf-consolidated-1.patch"
				_verify "sysvinit-2.88dsf.tar.bz2"	;;
		tar)		_verify "tar-1.29.tar.xz"		;;
		tcl-core)	_verify "tcl-core8.6.7-src.tar.gz"	;;
		texinfo)	_verify "texinfo-6.4.tar.xz"		;;
		tzdata)		_verify "tzdata2017b.tar.gz"		;;
		udev-lfs)	_verify "udev-lfs-20140408.tar.bz2"	;;
		util-linux)	_verify "util-linux-2.30.1.tar.xz"	;;
		vim)		_verify "vim-8.0.586.tar.bz2"		;;
		xz)		_verify "xz-5.2.3.tar.xz"		;;
		zlib)		_verify "zlib-1.2.11.tar.xz"		;;
		rpm)		_verify "rpm-4.14.0.tar.bz2"		;;
		elfutils)	_verify "elfutils-0.170.tar.bz2"	;;
		popt)		_verify "popt-1.16.tar.gz"		;;
		openssl)	_verify "openssl-1.1.0f.tar.gz"		;;
		db)		_verify "db-6.0.20.tar.gz"		;;	
		openssh)	_verify "openssh-7.5p1-openssl-1.1.0-1.patch"
				_verify "openssh-7.5p1.tar.gz"		;;
		blfs)		_verify "blfs-bootscripts-20170731.tar.xz"	;;
		wget)		_verify "wget-1.19.1.tar.xz"		;;
		*)	;;
	esac
done
end-run