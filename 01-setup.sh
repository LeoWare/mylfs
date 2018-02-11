#!/bin/bash
#################################################
#	Title:	1-setup.sh			#
#        Date:	2017-11-22			#
#     Version:	1.1				#
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
_setup_directories() {
	#	Setup base directories
	msg_line "	Creating base directories: "
	[ -d ${LFS} ] 		&& rm -rf ${LFS}/*
	[ -d ${LFS} ] 		|| install -dm 755 ${LFS}
	[ -d ${LFS}/tools ]	|| install -dm 755 ${LFS}/tools
	[ -h /tools ]		|| ln -vs ${LFS}/tools /
	msg_success
	return
}
_wget_list() {
	msg_line "	Creating wget-list: "
	cat > ${LFS}/${PARENT}/SOURCES/wget-list <<- EOF
		http://download.savannah.gnu.org/releases/acl/acl-2.2.52.src.tar.gz
		http://download.savannah.gnu.org/releases/attr/attr-2.4.47.src.tar.gz
		http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz
		http://ftp.gnu.org/gnu/automake/automake-1.15.1.tar.xz
		http://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz
		http://ftp.gnu.org/gnu/bc/bc-1.07.1.tar.gz
		http://ftp.gnu.org/gnu/binutils/binutils-2.29.tar.bz2
		http://ftp.gnu.org/gnu/bison/bison-3.0.4.tar.xz
		http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz
		https://github.com/libcheck/check/releases/download/0.11.0/check-0.11.0.tar.gz
		http://ftp.gnu.org/gnu/coreutils/coreutils-8.27.tar.xz
		http://dbus.freedesktop.org/releases/dbus/dbus-1.10.22.tar.gz
		http://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.tar.gz
		http://ftp.gnu.org/gnu/diffutils/diffutils-3.6.tar.xz
		http://dev.gentoo.org/~blueness/eudev/eudev-3.2.2.tar.gz
		http://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.43.5/e2fsprogs-1.43.5.tar.gz
		http://prdownloads.sourceforge.net/expat/expat-2.2.3.tar.bz2
		http://prdownloads.sourceforge.net/expect/expect5.45.tar.gz
		ftp://ftp.astron.com/pub/file/file-5.31.tar.gz
		http://ftp.gnu.org/gnu/findutils/findutils-4.6.0.tar.gz
		https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz
		http://ftp.gnu.org/gnu/gawk/gawk-4.1.4.tar.xz
		http://ftp.gnu.org/gnu/gcc/gcc-7.2.0/gcc-7.2.0.tar.xz
		http://ftp.gnu.org/gnu/gdbm/gdbm-1.13.tar.gz
		http://ftp.gnu.org/gnu/gettext/gettext-0.19.8.1.tar.xz
		http://ftp.osuosl.org/pub/lfs/lfs-packages/8.1/glibc-2.26.tar.xz
		http://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz
		http://ftp.gnu.org/gnu/gperf/gperf-3.1.tar.gz
		http://ftp.gnu.org/gnu/grep/grep-3.1.tar.xz
		http://ftp.gnu.org/gnu/groff/groff-1.22.3.tar.gz
		http://ftp.gnu.org/gnu/grub/grub-2.02.tar.xz
		http://ftp.gnu.org/gnu/gzip/gzip-1.8.tar.xz
		http://ftp.osuosl.org/pub/lfs/lfs-packages/8.1/iana-etc-2.30.tar.bz2
		http://ftp.gnu.org/gnu/inetutils/inetutils-1.9.4.tar.xz
		http://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz
		https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-4.12.0.tar.xz
		https://www.kernel.org/pub/linux/utils/kbd/kbd-2.0.4.tar.xz
		https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-24.tar.xz
		http://www.greenwoodsoftware.com/less/less-487.tar.gz
		http://www.linuxfromscratch.org/lfs/downloads/development/lfs-bootscripts-20170626.tar.bz2
		https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.25.tar.xz
		http://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.4.2.tar.gz
		http://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz
		https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.12.7.tar.xz
		https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.9.67.tar.xz
		http://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz
		http://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2
		http://download.savannah.gnu.org/releases/man-db/man-db-2.7.6.1.tar.xz
		https://www.kernel.org/pub/linux/docs/man-pages/man-pages-4.12.tar.xz
		http://ftp.osuosl.org/pub/lfs/lfs-packages/8.1/mpc-1.0.3.tar.gz
		http://www.mpfr.org/mpfr-3.1.5/mpfr-3.1.5.tar.xz
		http://ftp.gnu.org/gnu//ncurses/ncurses-6.0.tar.gz
		http://ftp.gnu.org/gnu/patch/patch-2.7.5.tar.xz
		http://www.cpan.org/src/5.0/perl-5.26.0.tar.xz
		https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz
		http://sourceforge.net/projects/procps-ng/files/Production/procps-ng-3.3.12.tar.xz
		https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.1.tar.xz
		http://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz
		http://ftp.gnu.org/gnu/sed/sed-4.4.tar.xz
		https://github.com/shadow-maint/shadow/releases/download/4.5/shadow-4.5.tar.xz
		http://www.infodrom.org/projects/sysklogd/download/sysklogd-1.5.1.tar.gz
		http://ftp.osuosl.org/pub/lfs/lfs-packages/8.1/systemd-234-lfs.tar.xz
		http://download.savannah.gnu.org/releases/sysvinit/sysvinit-2.88dsf.tar.bz2
		http://ftp.gnu.org/gnu/tar/tar-1.29.tar.xz
		http://sourceforge.net/projects/tcl/files/Tcl/8.6.7/tcl-core8.6.7-src.tar.gz
		http://ftp.gnu.org/gnu/texinfo/texinfo-6.4.tar.xz
		http://www.iana.org/time-zones/repository/releases/tzdata2017b.tar.gz
		http://ftp.osuosl.org/pub/lfs/lfs-packages/8.1/udev-lfs-20140408.tar.bz2
		https://www.kernel.org/pub/linux/utils/util-linux/v2.30/util-linux-2.30.1.tar.xz
		ftp://ftp.vim.org/pub/vim/unix/vim-8.0.586.tar.bz2
		http://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz
		http://tukaani.org/xz/xz-5.2.3.tar.xz
		http://zlib.net/zlib-1.2.11.tar.xz
		http://ftp.osuosl.org/pub/lfs/lfs-packages/8.1/bash-4.4-upstream_fixes-1.patch
		http://ftp.osuosl.org/pub/lfs/lfs-packages/8.1/bzip2-1.0.6-install_docs-1.patch
		http://ftp.osuosl.org/pub/lfs/lfs-packages/8.1/coreutils-8.27-i18n-1.patch
		http://ftp.osuosl.org/pub/lfs/lfs-packages/8.1/glibc-2.26-fhs-1.patch
		http://ftp.osuosl.org/pub/lfs/lfs-packages/8.1/kbd-2.0.4-backspace-1.patch
		http://ftp.osuosl.org/pub/lfs/lfs-packages/8.1/sysvinit-2.88dsf-consolidated-1.patch
	EOF
	#
	#	Add rpm packages and openssh
	#
	cat >> ${LFS}/${PARENT}/SOURCES/wget-list <<- EOF
		http://ftp.rpm.org/releases/rpm-4.14.x/rpm-4.14.0.tar.bz2
		https://sourceware.org/ftp/elfutils/0.170/elfutils-0.170.tar.bz2
		http://rpm5.org/files/popt/popt-1.16.tar.gz
		https://openssl.org/source/openssl-1.1.0f.tar.gz
		http://download.oracle.com/berkeley-db/db-6.0.20.tar.gz
		http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.5p1.tar.gz
		http://www.linuxfromscratch.org/patches/blfs/8.1/openssh-7.5p1-openssl-1.1.0-1.patch
		http://anduin.linuxfromscratch.org/BLFS/blfs-bootscripts/blfs-bootscripts-20170731.tar.xz
		https://ftp.gnu.org/gnu/wget/wget-1.19.1.tar.xz
	EOF
	msg_success
	return
}
_md5sum_list(){
	cat > ${LFS}/${PARENT}/SOURCES/md5sum-list <<- EOF

	EOF
	#
	#	Add rpm packages and openssh
	#
	cat >> ${LFS}/${PARENT}/SOURCES/md5sum-list <<- EOF
		a61415312426e9c2212bd7dc7929abda  SOURCES/acl-2.2.52.src.tar.gz
		84f58dec00b60f2dc8fd1c9709291cc7  SOURCES/attr-2.4.47.src.tar.gz
		50f97f4159805e374639a73e2636f22e  SOURCES/autoconf-2.69.tar.xz
		24cd3501b6ad8cd4d7e2546f07e8b4d4  SOURCES/automake-1.15.1.tar.xz
		148888a7c95ac23705559b6f477dfe25  SOURCES/bash-4.4.tar.gz
		e3d5bf23a4e5628680893d46e6ff286e  SOURCES/bash-4.4-upstream_fixes-1.patch
		cda93857418655ea43590736fc3ca9fc  SOURCES/bc-1.07.1.tar.gz
		23733a26c8276edbb1168c9bee60e40e  SOURCES/binutils-2.29.tar.bz2
		c342201de104cc9ce0a21e0ad10d4021  SOURCES/bison-3.0.4.tar.xz
		feeffb543c42d3a9790d4e77437b57db  SOURCES/blfs-bootscripts-20170731.tar.xz
		6a5ac7e89b791aae556de0f745916f7f  SOURCES/bzip2-1.0.6-install_docs-1.patch
		00b516f4704d4a7cb50a1d97e6e8e15b  SOURCES/bzip2-1.0.6.tar.gz
		9b90522b31f5628c2e0f55dda348e558  SOURCES/check-0.11.0.tar.gz
		a9404fb575dfd5514f3c8f4120f9ca7d  SOURCES/coreutils-8.27-i18n-1.patch
		502795792c212932365e077946d353ae  SOURCES/coreutils-8.27.tar.xz
		f73afcb308aefde7e6ece4caa87b22a9  SOURCES/db-6.0.20.tar.gz
		baaa10b7cb49086ad91179a8decfadc5  SOURCES/dbus-1.10.22.tar.gz
		1fdc2eb0d592c4f89d82d24dfdf02f0b  SOURCES/dejagnu-1.6.tar.gz
		07cf286672ced26fba54cd0313bdc071  SOURCES/diffutils-3.6.tar.xz
		40aa1b7d7d6bd9c71db0fbf325a7c199  SOURCES/e2fsprogs-1.43.5.tar.gz
		03599aee98c9b726c7a732a2dd0245d5  SOURCES/elfutils-0.170.tar.bz2
		41e19b70462692fefd072a3f38818b6e  SOURCES/eudev-3.2.2.tar.gz
		f053af63ef5f39bd9b78d01fbc203334  SOURCES/expat-2.2.3.tar.bz2
		44e1a4f4c877e9ddc5a542dfa7ecc92b  SOURCES/expect5.45.tar.gz
		319627d20c9658eae85b056115b8c90a  SOURCES/file-5.31.tar.gz
		9936aa8009438ce185bea2694a997fc1  SOURCES/findutils-4.6.0.tar.gz
		2882e3179748cc9f9c23ec593d6adc8d  SOURCES/flex-2.6.4.tar.gz
		4e7dbc81163e60fd4f0b52496e7542c9  SOURCES/gawk-4.1.4.tar.xz
		ff370482573133a7fcdd96cd2f552292  SOURCES/gcc-7.2.0.tar.xz
		8929dcda2a8de3fd2367bdbf66769376  SOURCES/gdbm-1.13.tar.gz
		df3f5690eaa30fd228537b00cb7b7590  SOURCES/gettext-0.19.8.1.tar.xz
		9a5997c3452909b1769918c759eff8a2  SOURCES/glibc-2.26-fhs-1.patch
		102f637c3812f81111f48f2427611be1  SOURCES/glibc-2.26.tar.xz
		f58fa8001d60c4c77595fbbb62b63c1d  SOURCES/gmp-6.1.2.tar.xz
		9e251c0a618ad0824b51117d5d9db87e  SOURCES/gperf-3.1.tar.gz
		feca7b3e7c7f4aab2b42ecbfc513b070  SOURCES/grep-3.1.tar.xz
		cc825fa64bc7306a885f2fb2268d3ec5  SOURCES/groff-1.22.3.tar.gz
		8a4a2a95aac551fb0fba860ceabfa1d3  SOURCES/grub-2.02.tar.xz
		f7caabb65cddc1a4165b398009bd05b9  SOURCES/gzip-1.8.tar.xz
		3ba3afb1d1b261383d247f46cb135ee8  SOURCES/iana-etc-2.30.tar.bz2
		87fef1fa3f603aef11c41dcc097af75e  SOURCES/inetutils-1.9.4.tar.xz
		12e517cac2b57a0121cda351570f1e63  SOURCES/intltool-0.51.0.tar.gz
		e6fecdf46a1542a26044e756fbbabe3b  SOURCES/iproute2-4.12.0.tar.xz
		f75cca16a38da6caa7d52151f7136895  SOURCES/kbd-2.0.4-backspace-1.patch
		c1635a5a83b63aca7f97a3eab39ebaa6  SOURCES/kbd-2.0.4.tar.xz
		08297dfb6f2b3f625f928ca3278528af  SOURCES/kmod-24.tar.xz
		dcc8bf183a83b362d37fe9ef8df1fb60  SOURCES/less-487.tar.gz
		1a9ddbe946583bc385d0d4f786796086  SOURCES/lfs-bootscripts-20170626.tar.bz2
		6666b839e5d46c2ad33fc8aa2ceb5f77  SOURCES/libcap-2.25.tar.xz
		d5c80387eb9c9e5d089da2a06e8a6b12  SOURCES/libpipeline-1.4.2.tar.gz
		1bfb9b923f2c1339b4d2ce1807064aa5  SOURCES/libtool-2.4.6.tar.xz
		245d1b4dc6e82669aac2c9e6a2dd82fe  SOURCES/linux-4.12.7.tar.xz
		4464a1a44ea6a032e28f862f793cfa60  SOURCES/linux-4.9.67.tar.xz
		730bb15d96fffe47e148d1e09235af82  SOURCES/m4-1.4.18.tar.xz
		15b012617e7c44c0ed482721629577ac  SOURCES/make-4.2.1.tar.bz2
		2948d49d0ed7265f60f83aa4a9ac9268  SOURCES/man-db-2.7.6.1.tar.xz
		a87cdf43ddc1844e7edc8950a28a51f0  SOURCES/man-pages-4.12.tar.xz
		d6a1d5f8ddea3abd2cc3e98f58352d26  SOURCES/mpc-1.0.3.tar.gz
		c4ac246cf9795a4491e7766002cd528f  SOURCES/mpfr-3.1.5.tar.xz
		ee13d052e1ead260d7c28071f46eefb1  SOURCES/ncurses-6.0.tar.gz
		f5aa210fd557cac83508ec3a71cfafa1  SOURCES/openssh-7.5p1-openssl-1.1.0-1.patch
		652fdc7d8392f112bef11cacf7e69e23  SOURCES/openssh-7.5p1.tar.gz
		7b521dea79ab159e8ec879d2333369fa  SOURCES/openssl-1.1.0f.tar.gz
		e3da7940431633fb65a01b91d3b7a27a  SOURCES/patch-2.7.5.tar.xz
		8c6995718e4cb62188f0d5e3488cd91f  SOURCES/perl-5.26.0.tar.xz
		f6e931e319531b736fadc017f470e68a  SOURCES/pkg-config-0.29.2.tar.gz
		3743beefa3dd6247a73f8f7a32c14c33  SOURCES/popt-1.16.tar.gz
		957e42e8b193490b2111252e4a2b443c  SOURCES/procps-ng-3.3.12.tar.xz
		bbba1f701c02fb50d59540d1ff90d8d1  SOURCES/psmisc-23.1.tar.xz
		205b03a87fc83dab653b628c59b9fc91  SOURCES/readline-7.0.tar.gz
		0214665617f41954d69c7ff550ae8956  SOURCES/rpm-4.14.0.tar.bz2
		e0c583d4c380059abd818cd540fe6938  SOURCES/sed-4.4.tar.xz
		c350da50c2120de6bb29177699d89fe3  SOURCES/shadow-4.5.tar.xz
		c70599ab0d037fde724f7210c2c8d7f8  SOURCES/sysklogd-1.5.1.tar.gz
		be1338f2775713dc33da74ac0146e37b  SOURCES/systemd-234-lfs.tar.xz
		0b7b5ea568a878fdcc4057b2bf36e5cb  SOURCES/sysvinit-2.88dsf-consolidated-1.patch
		6eda8a97b86e0a6f59dabbf25202aa6f  SOURCES/sysvinit-2.88dsf.tar.bz2
		a1802fec550baaeecff6c381629653ef  SOURCES/tar-1.29.tar.xz
		3f723d62c2e074bdbb2ddf330b5a71e1  SOURCES/tcl-core8.6.7-src.tar.gz
		2a676c8339efe6ddea0f1cb52e626d15  SOURCES/texinfo-6.4.tar.xz
		50dc0dc50c68644c1f70804f2e7a1625  SOURCES/tzdata2017b.tar.gz
		c2d6b127f89261513b23b6d458484099  SOURCES/udev-lfs-20140408.tar.bz2
		5e5ec141e775efe36f640e62f3f8cd0d  SOURCES/util-linux-2.30.1.tar.xz
		b35e794140c196ff59b492b56c1e73db  SOURCES/vim-8.0.586.tar.bz2
		d30d82186b93fcabb4116ff513bfa9bd  SOURCES/wget-1.19.1.tar.xz
		af4813fe3952362451201ced6fbce379  SOURCES/XML-Parser-2.44.tar.gz
		60fb79cab777e3f71ca43d298adacbd5  SOURCES/xz-5.2.3.tar.xz
		85adef240c5f370b308da8c938951a68  SOURCES/zlib-1.2.11.tar.xz
	EOF
	return
}
_copy_source() {
	#	Copy build system to $LFS
	#	Directories to copy
	msg_line "	Installing build system: "
	[ ${EUID} -eq 0 ] || die "Need to be root user"
	install -dm 755 ${LFS}/${PARENT}
	install -dm 755 ${LFS}/${PARENT}/INFO/BASE
	install -dm 755 ${LFS}/${PARENT}/INFO/TOOLS
	install -dm 755 ${LFS}/${PARENT}/LOGS/BASE
	install -dm 755 ${LFS}/${PARENT}/LOGS/TOOLS
	install -dm 755 ${LFS}/${PARENT}/PROVIDES/BASE
	install -dm 755 ${LFS}/${PARENT}/PROVIDES/TOOLS
	install -dm 755 ${LFS}/${PARENT}/REQUIRES/BASE
	install -dm 755 ${LFS}/${PARENT}/REQUIRES/TOOLS
	install -dm 755 ${LFS}/${PARENT}/SOURCES
	cp -ar * ${LFS}${PARENT}
	#	cp -a SOURCES/* ${LFS}${PARENT}/SOURCES
	chmod 777 ${LFS}${PARENT}/*.sh
	msg_success
	return
}
_setup_user() {
	#	Create lfs user
	[ ${EUID} -eq 0 ] || die "Need to be root user"
	msg_line "	Creating lfs user: "
	/usr/bin/getent group  lfs > /dev/null 2>&1 || /usr/sbin/groupadd lfs
	/usr/bin/getent passwd lfs > /dev/null 2>&1 || /usr/sbin/useradd  -c 'LFS user' -g lfs -m -k /dev/null -s /bin/bash lfs
	/usr/bin/getent passwd lfs > /dev/null 2>&1 && passwd --delete lfs > /dev/null 2>&1
	[ -d /home/lfs ] || install -dm 755 /home/lfs
	cat > /home/lfs/.bash_profile <<- EOF
		exec env -i HOME=/home/lfs TERM=${TERM} PS1='\u:\w\$ ' /bin/bash
	EOF
	cat > /home/lfs/.bashrc <<- EOF
		set +h
		umask 022
		LFS=/mnt/lfs
		LC_ALL=POSIX
		LFS_TGT=$(uname -m)-lfs-linux-gnu
		PATH=/tools/bin:/bin:/usr/bin
		export LFS LC_ALL LFS_TGT PATH
	EOF
	[ -d ${LFS} ]			|| install -dm 755 ${LFS}
	[ -d ${LFS}/tools ]		|| install -dm 755 ${LFS}/tools
	[ -h /tools ]			|| ln -s ${LFS}/tools /
	chown -R lfs:lfs /home/lfs	|| die "${FUNCNAME}: FAILURE"
	chown -R lfs:lfs ${LFS}		|| die "${FUNCNAME}: FAILURE"
	msg_success
	return
}

#
#	Main line
#
[ ${EUID} -eq 0 ]		|| { echo "${PRGNAME}: Need to be root user";exit 1; }
[ -z ${LFS} ]			&& { echo "${PRGNAME}: LFS: not set";exit 1; }
[ -z ${PARENT} ]		&& { echo "${PRGNAME}: PARENT: not set";exit 1; }
[ -z ${LOGFILE} ]		&& { echo "${PRGNAME}: LOGFILE: not set";exit 1; }
[ -x /usr/bin/getent ]		|| { echo "${PRGNAME}: getent: missing: can not continue";exit 1; }
_setup_directories		#	Setup directories
_copy_source			#	Copy build system to $LFS
_wget_list			#	Create wget list
_md5sum_list			#	Create md5sum list
_setup_user			#	Create lfs user
end-run