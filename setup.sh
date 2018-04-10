#!/bin/bash
##############################################
#	Title:	01-setup.sh				#
#        Date:	2018-03-21				#
#     Version:	1.3						#
#      Author:	baho-utot@columbus.rr.com	#
#     Options:							#
##############################################
#
set -o errexit			# exit if error...insurance ;)
set -o nounset			# exit if variable not initalized
set +h					# disable hashall
PRGNAME=${0##*/}			# script name minus the path
TOPDIR=${PWD}
LFS=/mnt/lfs
PARENT=/usr/src/Octothorpe
LOGFILE=$(date +%Y-%m-%d).log
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
	[ -d ${LFS} ] 	&& rm -rf ${LFS}/*
	[ -d ${LFS} ] 	|| install -dm 755 ${LFS}
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
		http://ftp.gnu.org/gnu/bash/bash-4.4.18.tar.gz
		http://ftp.gnu.org/gnu/bc/bc-1.07.1.tar.gz
		http://ftp.gnu.org/gnu/binutils/binutils-2.30.tar.xz
		http://ftp.gnu.org/gnu/bison/bison-3.0.4.tar.xz
		http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz
		https://github.com/libcheck/check/releases/download/0.12.0/check-0.12.0.tar.gz
		http://ftp.gnu.org/gnu/coreutils/coreutils-8.29.tar.xz
		http://dbus.freedesktop.org/releases/dbus/dbus-1.12.4.tar.gz
		http://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.1.tar.gz
		http://ftp.gnu.org/gnu/diffutils/diffutils-3.6.tar.xz
		http://dev.gentoo.org/~blueness/eudev/eudev-3.2.5.tar.gz
		http://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.43.9/e2fsprogs-1.43.9.tar.gz
		https://sourceware.org/ftp/elfutils/0.170/elfutils-0.170.tar.bz2
		http://prdownloads.sourceforge.net/expat/expat-2.2.5.tar.bz2
		http://prdownloads.sourceforge.net/expect/expect5.45.4.tar.gz
		ftp://ftp.astron.com/pub/file/file-5.32.tar.gz
		http://ftp.gnu.org/gnu/findutils/findutils-4.6.0.tar.gz
		https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz
		http://ftp.gnu.org/gnu/gawk/gawk-4.2.0.tar.xz
		http://ftp.gnu.org/gnu/gcc/gcc-7.3.0/gcc-7.3.0.tar.xz
		http://ftp.gnu.org/gnu/gdbm/gdbm-1.14.1.tar.gz
		http://ftp.gnu.org/gnu/gettext/gettext-0.19.8.1.tar.xz
		http://ftp.gnu.org/gnu/glibc/glibc-2.27.tar.xz
		http://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz
		http://ftp.gnu.org/gnu/gperf/gperf-3.1.tar.gz
		http://ftp.gnu.org/gnu/grep/grep-3.1.tar.xz
		http://ftp.gnu.org/gnu/groff/groff-1.22.3.tar.gz
		http://ftp.gnu.org/gnu/grub/grub-2.02.tar.xz
		http://ftp.gnu.org/gnu/gzip/gzip-1.9.tar.xz
		http://anduin.linuxfromscratch.org/LFS/iana-etc-2.30.tar.bz2
		http://ftp.gnu.org/gnu/inetutils/inetutils-1.9.4.tar.xz
		http://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz
		https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-4.15.0.tar.xz
		https://www.kernel.org/pub/linux/utils/kbd/kbd-2.0.4.tar.xz
		https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-25.tar.xz
		http://www.greenwoodsoftware.com/less/less-530.tar.gz
		http://www.linuxfromscratch.org/lfs/downloads/8.2/lfs-bootscripts-20170626.tar.bz2
		https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.25.tar.xz
		ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz
		http://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.0.tar.gz
		http://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz
		https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.15.3.tar.xz
		http://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz
		http://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2
		http://download.savannah.gnu.org/releases/man-db/man-db-2.8.1.tar.xz
		https://www.kernel.org/pub/linux/docs/man-pages/man-pages-4.15.tar.xz
		https://github.com/mesonbuild/meson/releases/download/0.44.0/meson-0.44.0.tar.gz
		https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz
		http://www.mpfr.org/mpfr-4.0.1/mpfr-4.0.1.tar.xz
		https://github.com/ninja-build/ninja/archive/v1.8.2/ninja-1.8.2.tar.gz
		http://ftp.gnu.org/gnu//ncurses/ncurses-6.1.tar.gz
		https://openssl.org/source/openssl-1.1.0g.tar.gz
		http://ftp.gnu.org/gnu/patch/patch-2.7.6.tar.xz
		http://www.cpan.org/src/5.0/perl-5.26.1.tar.xz
		https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz
		http://sourceforge.net/projects/procps-ng/files/Production/procps-ng-3.3.12.tar.xz
		https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.1.tar.xz
		https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tar.xz
		https://docs.python.org/ftp/python/doc/3.6.4/python-3.6.4-docs-html.tar.bz2
		http://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz
		http://ftp.gnu.org/gnu/sed/sed-4.4.tar.xz
		https://github.com/shadow-maint/shadow/releases/download/4.5/shadow-4.5.tar.xz
		http://www.infodrom.org/projects/sysklogd/download/sysklogd-1.5.1.tar.gz
		https://github.com/systemd/systemd/archive/v237/systemd-237.tar.gz
		http://anduin.linuxfromscratch.org/LFS/systemd-man-pages-237.tar.xz
		http://download.savannah.gnu.org/releases/sysvinit/sysvinit-2.88dsf.tar.bz2
		http://ftp.gnu.org/gnu/tar/tar-1.30.tar.xz
		https://downloads.sourceforge.net/tcl/tcl8.6.8-src.tar.gz
		http://ftp.gnu.org/gnu/texinfo/texinfo-6.5.tar.xz
		http://www.iana.org/time-zones/repository/releases/tzdata2018c.tar.gz
		http://anduin.linuxfromscratch.org/LFS/udev-lfs-20171102.tar.bz2
		https://www.kernel.org/pub/linux/utils/util-linux/v2.31/util-linux-2.31.1.tar.xz
		ftp://ftp.vim.org/pub/vim/unix/vim-8.0.586.tar.bz2
		http://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz
		http://tukaani.org/xz/xz-5.2.3.tar.xz
		http://zlib.net/zlib-1.2.11.tar.xz
		http://www.linuxfromscratch.org/patches/lfs/8.2/bzip2-1.0.6-install_docs-1.patch
		http://www.linuxfromscratch.org/patches/lfs/8.2/coreutils-8.29-i18n-1.patch
		http://www.linuxfromscratch.org/patches/lfs/8.2/glibc-2.27-fhs-1.patch
		http://www.linuxfromscratch.org/patches/lfs/8.2/kbd-2.0.4-backspace-1.patch
		http://www.linuxfromscratch.org/patches/lfs/8.2/ninja-1.8.2-add_NINJAJOBS_var-1.patch
		http://www.linuxfromscratch.org/patches/lfs/8.2/sysvinit-2.88dsf-consolidated-1.patch
	EOF
	#
	#	Add rpm packages and openssh
	#
	cat >> ${LFS}/${PARENT}/SOURCES/wget-list <<- EOF
		http://ftp.rpm.org/releases/rpm-4.14.x/rpm-4.14.1.tar.bz2
		http://rpm5.org/files/popt/popt-1.16.tar.gz
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
	#
	#	Add rpm packages and openssh
	#
	cat >> ${LFS}/${PARENT}/SOURCES/md5sum-list <<- EOF
		a61415312426e9c2212bd7dc7929abda  SOURCES/acl-2.2.52.src.tar.gz
		84f58dec00b60f2dc8fd1c9709291cc7  SOURCES/attr-2.4.47.src.tar.gz
		50f97f4159805e374639a73e2636f22e  SOURCES/autoconf-2.69.tar.xz
		24cd3501b6ad8cd4d7e2546f07e8b4d4  SOURCES/automake-1.15.1.tar.xz
		518e2c187cc11a17040f0915dddce54e  SOURCES/bash-4.4.18.tar.gz
		cda93857418655ea43590736fc3ca9fc  SOURCES/bc-1.07.1.tar.gz
		ffc476dd46c96f932875d1b2e27e929f  SOURCES/binutils-2.30.tar.xz
		c342201de104cc9ce0a21e0ad10d4021  SOURCES/bison-3.0.4.tar.xz
		00b516f4704d4a7cb50a1d97e6e8e15b  SOURCES/bzip2-1.0.6.tar.gz
		31b17c6075820a434119592941186f70  SOURCES/check-0.12.0.tar.gz
		960cfe75a42c9907c71439f8eb436303  SOURCES/coreutils-8.29.tar.xz
		2ac8405a4c7ca8611d004fe852966c6f  SOURCES/dejagnu-1.6.1.tar.gz
		07cf286672ced26fba54cd0313bdc071  SOURCES/diffutils-3.6.tar.xz
		6ca08c0e14380f87df8e8aceac123671  SOURCES/eudev-3.2.5.tar.gz
		8749ba4fbc25d1b13753b79f1f84b69d  SOURCES/e2fsprogs-1.43.9.tar.gz
		03599aee98c9b726c7a732a2dd0245d5  SOURCES/elfutils-0.170.tar.bz2
		789e297f547980fc9ecc036f9a070d49  SOURCES/expat-2.2.5.tar.bz2
		00fce8de158422f5ccd2666512329bd2  SOURCES/expect5.45.4.tar.gz
		4f2503752ff041895090ed6435610435  SOURCES/file-5.32.tar.gz
		9936aa8009438ce185bea2694a997fc1  SOURCES/findutils-4.6.0.tar.gz
		2882e3179748cc9f9c23ec593d6adc8d  SOURCES/flex-2.6.4.tar.gz
		f26c469addc67d88034b01b62ebab284  SOURCES/gawk-4.2.0.tar.xz
		be2da21680f27624f3a87055c4ba5af2  SOURCES/gcc-7.3.0.tar.xz
		c2ddcb3897efa0f57484af2bd4f4f848  SOURCES/gdbm-1.14.1.tar.gz
		df3f5690eaa30fd228537b00cb7b7590  SOURCES/gettext-0.19.8.1.tar.xz
		898cd5656519ffbc3a03fe811dd89e82  SOURCES/glibc-2.27.tar.xz
		f58fa8001d60c4c77595fbbb62b63c1d  SOURCES/gmp-6.1.2.tar.xz
		9e251c0a618ad0824b51117d5d9db87e  SOURCES/gperf-3.1.tar.gz
		feca7b3e7c7f4aab2b42ecbfc513b070  SOURCES/grep-3.1.tar.xz
		cc825fa64bc7306a885f2fb2268d3ec5  SOURCES/groff-1.22.3.tar.gz
		8a4a2a95aac551fb0fba860ceabfa1d3  SOURCES/grub-2.02.tar.xz
		9492c6ccb2239ff679a5475a7bb543ed  SOURCES/gzip-1.9.tar.xz
		3ba3afb1d1b261383d247f46cb135ee8  SOURCES/iana-etc-2.30.tar.bz2
		87fef1fa3f603aef11c41dcc097af75e  SOURCES/inetutils-1.9.4.tar.xz
		12e517cac2b57a0121cda351570f1e63  SOURCES/intltool-0.51.0.tar.gz
		0681bf4664b2649ad4e12551a3a7a1f9  SOURCES/iproute2-4.15.0.tar.xz
		c1635a5a83b63aca7f97a3eab39ebaa6  SOURCES/kbd-2.0.4.tar.xz
		34f325cab568f842fdde4f8b2182f220  SOURCES/kmod-25.tar.xz
		6a39bccf420c946b0fd7ffc64961315b  SOURCES/less-530.tar.gz
		8a9f3d5aab3f77a70fef0773e8bc7b2b  SOURCES/lfs-bootscripts-20170626.tar.bz2
		6666b839e5d46c2ad33fc8aa2ceb5f77  SOURCES/libcap-2.25.tar.xz
		83b89587607e3eb65c70d361f13bab43  SOURCES/libffi-3.2.1.tar.gz
		b7437a5020190cfa84f09c412db38902  SOURCES/libpipeline-1.5.0.tar.gz
		1bfb9b923f2c1339b4d2ce1807064aa5  SOURCES/libtool-2.4.6.tar.xz
		c74d30ec13491aeb24c237d703eace3e  SOURCES/linux-4.15.3.tar.xz
		730bb15d96fffe47e148d1e09235af82  SOURCES/m4-1.4.18.tar.xz
		15b012617e7c44c0ed482721629577ac  SOURCES/make-4.2.1.tar.bz2
		51842978e06686286421f9498d1009b7  SOURCES/man-db-2.8.1.tar.xz
		4298feb3d5feffad8ff46bb87b061a07  SOURCES/man-pages-4.15.tar.xz
		26a7ca93ec9cea5facb365664261f9c6  SOURCES/meson-0.44.0.tar.gz
		4125404e41e482ec68282a2e687f6c73  SOURCES/mpc-1.1.0.tar.gz
		b8dd19bd9bb1ec8831a6a582a7308073  SOURCES/mpfr-4.0.1.tar.xz
		5fdb04461cc7f5d02536b3bfc0300166  SOURCES/ninja-1.8.2.tar.gz
		98c889aaf8d23910d2b92d65be2e737a  SOURCES/ncurses-6.1.tar.gz
		ba5f1b8b835b88cadbce9b35ed9531a6  SOURCES/openssl-1.1.0g.tar.gz
		78ad9937e4caadcba1526ef1853730d5  SOURCES/patch-2.7.6.tar.xz
		70e988b4318739b0cf3ad5e120bfde88  SOURCES/perl-5.26.1.tar.xz
		f6e931e319531b736fadc017f470e68a  SOURCES/pkg-config-0.29.2.tar.gz
		957e42e8b193490b2111252e4a2b443c  SOURCES/procps-ng-3.3.12.tar.xz
		bbba1f701c02fb50d59540d1ff90d8d1  SOURCES/psmisc-23.1.tar.xz
		1325134dd525b4a2c3272a1a0214dd54  SOURCES/Python-3.6.4.tar.xz
		205aba4b06fd5e44598d1638a2ff81d8  SOURCES/python-3.6.4-docs-html.tar.bz2
		205b03a87fc83dab653b628c59b9fc91  SOURCES/readline-7.0.tar.gz
		e0c583d4c380059abd818cd540fe6938  SOURCES/sed-4.4.tar.xz
		c350da50c2120de6bb29177699d89fe3  SOURCES/shadow-4.5.tar.xz
		c70599ab0d037fde724f7210c2c8d7f8  SOURCES/sysklogd-1.5.1.tar.gz
		6eda8a97b86e0a6f59dabbf25202aa6f  SOURCES/sysvinit-2.88dsf.tar.bz2
		2d01c6cd1387be98f57a0ec4e6e35826  SOURCES/tar-1.30.tar.xz
		81656d3367af032e0ae6157eff134f89  SOURCES/tcl8.6.8-src.tar.gz
		3715197e62e0e07f85860b3d7aab55ed  SOURCES/texinfo-6.5.tar.xz
		c412b1531adef1be7a645ab734f86acc  SOURCES/tzdata2018c.tar.gz
		d92afb0c6e8e616792068ee4737b0d24  SOURCES/udev-lfs-20171102.tar.bz2
		7733b583dcb51518944d42aa62ef19ea  SOURCES/util-linux-2.31.1.tar.xz
		b35e794140c196ff59b492b56c1e73db  SOURCES/vim-8.0.586.tar.bz2
		af4813fe3952362451201ced6fbce379  SOURCES/XML-Parser-2.44.tar.gz
		60fb79cab777e3f71ca43d298adacbd5  SOURCES/xz-5.2.3.tar.xz
		85adef240c5f370b308da8c938951a68  SOURCES/zlib-1.2.11.tar.xz
		6a5ac7e89b791aae556de0f745916f7f  SOURCES/bzip2-1.0.6-install_docs-1.patch
		a9404fb575dfd5514f3c8f4120f9ca7d  SOURCES/coreutils-8.29-i18n-1.patch
		9a5997c3452909b1769918c759eff8a2  SOURCES/glibc-2.27-fhs-1.patch
		f75cca16a38da6caa7d52151f7136895  SOURCES/kbd-2.0.4-backspace-1.patch
		f537a633532492e805aa342fa869ca45  SOURCES/ninja-1.8.2-add_NINJAJOBS_var-1.patch
		0b7b5ea568a878fdcc4057b2bf36e5cb  SOURCES/sysvinit-2.88dsf-consolidated-1.patch
	EOF
	return
}
_copy_source() {
	#	Copy build system to $LFS
	#	Directories to copy
	msg_line "	Installing build system: "
	[ ${EUID} -eq 0 ] || die "Need to be root user"
	install -dm 755 ${LFS}/${PARENT}
	install -dm 755 ${LFS}/${PARENT}/INFO
	install -dm 755 ${LFS}/${PARENT}/LOGS
	install -dm 755 ${LFS}/${PARENT}/PROVIDES
	install -dm 755 ${LFS}/${PARENT}/REQUIRES
	install -dm 755 ${LFS}/${PARENT}/SOURCES
	cp -ar * ${LFS}${PARENT}
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
	cat > /home/lfs/.rpmmacros <<- EOF
		#
		#	System settings
		#
		%_lfsdir		/mnt/lfs
		%_lfs_tgt		x86_64-lfs-linux-gnu
		%_topdir		%{_lfsdir}/usr/src/Octothorpe
		%_dbpath		%{_lfsdir}/var/lib/rpm
		%_prefix		/tools
		%_docdir		%{_prefix}/share/doc
		%_lib			%{_prefix}/lib
		%_bindir		%{_prefix}/bin
		%_libdir		%{_prefix}/lib
		%_lib64		%{_prefix}/lib64
		%_var			%{_prefix}/var
		%_sharedstatedir	%{_prefix}/var/lib
		%_localstatedir	%{_prefix}/var
		%_tmppath		%{_prefix}/var/tmp
		%_build_id_links	none
	EOF
	echo "%LFS_TGT		$(uname -m)-lfs-linux-gnu" >> /home/lfs/.rpmmacros
	[ -d ${LFS} ]			|| install -dm 755 ${LFS}
	[ -d ${LFS}/tools ]		|| install -dm 755 ${LFS}/tools
	[ -h /tools ]			|| ln -s ${LFS}/tools /
	chown -R lfs:lfs /home/lfs	|| die "${FUNCNAME}: FAILURE"
	chown -R lfs:lfs ${LFS}	|| die "${FUNCNAME}: FAILURE"
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
