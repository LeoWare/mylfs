#!/bin/bash
#################################################
#	Title:	builder				#
#        Date:	2014-05-31			#
#     Version:	1.0				#
#      Author:	baho-utot@columbus.rr.com	#
#     Options:					#
#################################################
set -o errexit		# exit if error...insurance ;)
set -o nounset		# exit if variable not initalized
set +h			# disable hashall
PRGNAME=${0##*/}	# script name minus the path
#	Editable variables follow
LFS=/mnt/lfs		# where to build this animal
LFS_TGT=$(uname -m)-lfs-linux-gnu
PARENT="/usr/src/Octothorpe"
MKFLAGS="-j $(getconf _NPROCESSORS_ONLN)"
#	Edit partition and mnt_point for the correct values for your system
#	Failing to do so will cause you grief as in overwriting your system
#	You have been warned
#	the partition line is above the mount point ie sdb6 mounted at /
PARTITION=(	'sdb3'	'sdxx'		) #sdxx	sdxx	sdxx	sdxx	sdxx	sdxx	)
MNT_POINT=(	'lfs'	'lfs/boot'	) #home	opt	tmp	usr	swap	usr/src	)
FILSYSTEM=(	'ext4'	'ext4'		) #ext4	ext4	ext4	ext4	swap	ext4	)
#
#	Common support functions
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
msg_log() {
	printf "\n%s\n\n" "${1}" >> ${_logfile} 2>&1
}
usage()	{
	msg	"Usage: ${PRGNAME} <options>"
	msg	"	-c - create filesystem(s)"
	msg	"	-m - mount filesystem(s)"
	msg	"	-u - unmount filesystem(s)"
	msg	"	-f - fetch source packages using wget"
	msg	"	-i - install build system to /mnt/lfs"
	msg 	"	-l - creates lfs user and sets environment"
	msg 	"	-r - removes lfs user"
	msg	"	-t - build toolchain"
	msg	"	-s - build system"
	msg 	"	-h - this info"
	exit 1
}
#
#	Support functions
#
build() {	# $1 = message 
		# $2 = command
		# $3 = log file
	local _msg="${1}"
	local _cmd="${2}"
	local _logfile="${3}"
	if [ "/dev/null" == "${_logfile}" ]; then
		#	Discard output no log file
		eval ${_cmd} >> ${_logfile} 2>&1
	else
		msg_line "       ${_msg}: "
		printf "\n%s\n\n" "###       ${_msg}       ###" >> ${_logfile} 2>&1
		eval ${_cmd} >> ${_logfile} 2>&1 && msg_success || msg_failure 
	fi
	return 0
}
unpack() {	# $1 = directory
		# $2 = source package name I'll find the suffix thank you
	local _dir=${1%%/BUILD*} # remove BUILD from path
	local i=${2}
	local p=$(echo ${_dir}/SOURCES/${i}*.tar.*)
	msg_line "       Unpacking: ${i}: "
	[ -e ${p} ] || die " File not found: FAILURE"
	tar xf ${p} && msg_success || msg_failure
	return 0
}
mount_filesystems() {
	local _logfile="/dev/null"
	if ! mountpoint ${LFS}/dev	>/dev/null 2>&1; then mount --bind /dev ${LFS}/dev; fi
	if ! mountpoint ${LFS}/dev/pts	>/dev/null 2>&1; then mount -t devpts devpts ${LFS}/dev/pts -o gid=5,mode=620; fi
	if ! mountpoint ${LFS}/proc	>/dev/null 2>&1; then mount -t proc proc ${LFS}/proc; fi
	if ! mountpoint ${LFS}/sys 	>/dev/null 2>&1; then mount -t sysfs sysfs ${LFS}/sys; fi
	if ! mountpoint ${LFS}/run	>/dev/null 2>&1; then mount -t tmpfs tmpfs ${LFS}/run; fi
	if [ -h ${LFS}/dev/shm ];			 then mkdir -pv ${LFS}/$(readlink ${LFS}/dev/shm); fi
	return 0
}
unmount_filesystems() {
	local _logfile="/dev/null"
	if mountpoint ${LFS}/run	>/dev/null 2>&1; then umount ${LFS}/run; fi
	if mountpoint ${LFS}/sys	>/dev/null 2>&1; then umount ${LFS}/sys; fi
	if mountpoint ${LFS}/proc	>/dev/null 2>&1; then umount ${LFS}/proc; fi
	if mountpoint ${LFS}/dev/pts	>/dev/null 2>&1; then umount ${LFS}/dev/pts; fi
	if mountpoint ${LFS}/dev	>/dev/null 2>&1; then umount ${LFS}/dev; fi
	return 0
}
#
#	Build toolchain functions
#
chapter-5-04() {
	local	_pkgname="binutils"
	local	_pkgver="2.24"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Create work directory" "install -vdm 755 ../build" ${_logfile}
	build "Change directory: ../build" "pushd ../build" ${_logfile}
	build "Configure" "../${_pkgname}-${_pkgver}/configure --prefix=/tools --with-sysroot=${LFS} --with-lib-path=/tools/lib --target=${LFS_TGT} --disable-nls --disable-werror" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	[ "x86_64" == $(uname -m) ] && build "Create symlink for amd64" "install -vdm 755 /tools/lib;ln -vfs lib /tools/lib64" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}

chapter-5-05() {
	local	_pkgname="gcc"
	local	_pkgver="4.8.2"
	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	local	_pwd=${PWD}/BUILD
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	build "Create work directory" "install -vdm 755 build" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	unpack "${PWD}" "mpfr-3.1.2"
	unpack "${PWD}" "gmp-5.1.3"
	unpack "${PWD}" "mpc-1.0.2"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Symlinking gmp" " ln -vs ../gmp-5.1.3  gmp" ${_logfile}
	build "Symlinking mpc" " ln -vs ../mpc-1.0.2  mpc" ${_logfile}
	build "Symlinking mpfr" "ln -vs ../mpfr-3.1.2 mpfr" ${_logfile}
	build "Fixing headers" 'for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h); do cp -uv $file{,.orig};sed -e "s@/lib\(64\)\?\(32\)\?/ld@/tools&@g" -e "s@/usr@/tools@g" $file.orig > $file;printf "\n%s\n%s\n%s\n%s\n\n" "#undef STANDARD_STARTFILE_PREFIX_1" "#undef STANDARD_STARTFILE_PREFIX_2" "#define STANDARD_STARTFILE_PREFIX_1 \"/tools/lib/\"" "#define STANDARD_STARTFILE_PREFIX_2 \"\" ">> $file;touch $file.orig;done' ${_logfile}
	build "sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure" "sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure" ${_logfile}
	build "Change directory: ../build" "pushd ../build" ${_logfile}
	build "Configure" "../${_pkgname}-${_pkgver}/configure --target=${LFS_TGT} --prefix=/tools --with-sysroot=${LFS} --with-newlib --without-headers --with-local-prefix=/tools --with-native-system-header-dir=/tools/include --disable-nls --disable-shared --disable-multilib --disable-decimal-float --disable-threads --disable-libatomic --disable-libgomp --disable-libitm --disable-libmudflap --disable-libquadmath --disable-libsanitizer --disable-libssp --disable-libstdc++-v3 --enable-languages=c,c++ --with-mpfr-include=${_pwd}/${_pkgname}-${_pkgver}/mpfr/src --with-mpfr-lib=${_pwd}/build/mpfr/src/.libs" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Symlinking libgcc_eh.a" 'ln -vs libgcc.a $(${LFS_TGT}-gcc -print-libgcc-file-name | sed "s/libgcc/&_eh/")' ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-06() {
	local	_pkgname="linux"
	local	_pkgver="3.13.3"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "make mrproper" "make mrproper" ${_logfile}
	build "make headers_check" "make headers_check" ${_logfile}
	build "make INSTALL_HDR_PATH=dest headers_install" "make INSTALL_HDR_PATH=dest headers_install" ${_logfile}
	build "cp -rv dest/include/* /tools/include" "cp -rv dest/include/* /tools/include" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-07() {
	local	_pkgname="glibc"
	local	_pkgver="2.19"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	[ ! -r /usr/include/rpc/types.h ] && build "Copying rpc headers to host system" \
		"su -c 'mkdir -pv /usr/include/rpc' && su -c 'cp -v sunrpc/rpc/*.h /usr/include/rpc'"  ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Create work directory" "install -vdm 755 ../build" ${_logfile}
	build "Change directory: ../build" "pushd ../build" ${_logfile}
	build "Configure" "../${_pkgname}-${_pkgver}/configure --prefix=/tools --host=${LFS_TGT} --build=$(../${_pkgname}-${_pkgver}/scripts/config.guess) --disable-profile --enable-kernel=2.6.32 --with-headers=/tools/include libc_cv_forced_unwind=yes libc_cv_ctors_header=yes libc_cv_c_cleanup=yes" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	msg_line "       Checking glibc for sanity: "
	echo 'main(){}' > dummy.c
	${LFS_TGT}-gcc dummy.c
	retval=$(readelf -l a.out | grep ': /tools')
	rm dummy.c a.out
	#	[Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]
	retval=${retval##*: }	# strip [Requesting program interpreter: 
	retval=${retval%]}	# strip ]
	case "${retval}" in
		"/tools/lib/ld-linux.so.2")		msg_success ;;
		"/tools/lib64/ld-linux-x86-64.so.2")	msg_success ;;
		*)					msg_line "       Glibc is insane: "msg_failure ;;
	esac
	>  ${_complete}
	return 0
}
chapter-5-08() {
	local	_pkgname="gcc"
	local	_pkgver="4.8.2"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Create work directory" "install -vdm 755 ../build" ${_logfile}
	build "Change directory: ../build" "pushd ../build" ${_logfile}
	build "Configure" "../${_pkgname}-${_pkgver}/libstdc++-v3/configure --host=${LFS_TGT} --prefix=/tools --disable-multilib --disable-shared --disable-nls --disable-libstdcxx-threads --disable-libstdcxx-pch --with-gxx-include-dir=/tools/${LFS_TGT}/include/c++/${_pkgver}" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-09() {
	local	_pkgname="binutils"
	local	_pkgver="2.24"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Create work directory" "install -vdm 755 ../build" ${_logfile}
	build "Change directory: ../build" "pushd ../build" ${_logfile}
	build "Configure" "CC=${LFS_TGT}-gcc AR=${LFS_TGT}-ar RANLIB=${LFS_TGT}-ranlib ../${_pkgname}-${_pkgver}/configure --prefix=/tools --disable-nls --with-lib-path=/tools/lib --with-sysroot" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "make -C ld clean" "make -C ld clean" ${_logfile}
	build "make -C ld LIB_PATH=/usr/lib:/lib" "make -C ld LIB_PATH=/usr/lib:/lib" ${_logfile}
	build "cp -v ld/ld-new /tools/bin" "cp -v ld/ld-new /tools/bin" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-10() {
	local	_pkgname="gcc"
	local	_pkgver="4.8.2"
	local	_pwd=${PWD}/BUILD
	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	unpack "${PWD}" "mpfr-3.1.2"
	unpack "${PWD}" "gmp-5.1.3"
	unpack "${PWD}" "mpc-1.0.2"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Symlinking gmp" " ln -vs ../gmp-5.1.3  gmp" ${_logfile}
	build "Symlinking mpc" " ln -vs ../mpc-1.0.2  mpc" ${_logfile}
	build "Symlinking mpfr" "ln -vs ../mpfr-3.1.2 mpfr" ${_logfile}
	build "Fixing limits.h" 'cat gcc/limitx.h gcc/glimits.h gcc/limity.h > $(dirname $( ${LFS_TGT}-gcc -print-libgcc-file-name))/include-fixed/limits.h' ${_logfile}
	[ "x86_64" == $(uname -m) ] || build "Adding -fomit-frame-pointer to CFLAGS" 'sed -i "s/^T_CFLAGS =$/& -fomit-frame-pointer/" gcc/Makefile.in' ${_logfile}
	build "Fixing headers" 'for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h); do cp -uv $file{,.orig};sed -e "s@/lib\(64\)\?\(32\)\?/ld@/tools&@g" -e "s@/usr@/tools@g" $file.orig > $file;printf "\n%s\n%s\n%s\n%s\n\n" "#undef STANDARD_STARTFILE_PREFIX_1" "#undef STANDARD_STARTFILE_PREFIX_2" "#define STANDARD_STARTFILE_PREFIX_1 \"/tools/lib/\"" "#define STANDARD_STARTFILE_PREFIX_2 \"\" ">> $file;touch $file.orig;done' ${_logfile}			
	build "Create work directory" "install -vdm 755 ../build" ${_logfile}
	build "Change directory: ../build" "pushd ../build" ${_logfile}QM:
	build "Configure" "CC=${LFS_TGT}-gcc CXX=${LFS_TGT}-g++ AR=${LFS_TGT}-ar RANLIB=${LFS_TGT}-ranlib ../${_pkgname}-${_pkgver}/configure --prefix=/tools --with-local-prefix=/tools --with-native-system-header-dir=/tools/include --enable-clocale=gnu --enable-shared --enable-threads=posix --enable-__cxa_atexit --enable-languages=c,c++ --disable-libstdcxx-pch --disable-multilib --disable-bootstrap --disable-libgomp --with-mpfr-include=${_pwd}/${_pkgname}-${_pkgver}/mpfr/src --with-mpfr-lib=${_pwd}/build/mpfr/src/.libs" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "ln -sv gcc /tools/bin/cc" "ln -sv gcc /tools/bin/cc" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	msg_line "       Checking glibc for sanity: "
	echo 'main(){}' > dummy.c
	${LFS_TGT}-gcc dummy.c
	retval=$(readelf -l a.out | grep ': /tools')
	rm dummy.c a.out
	#	[Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]
	retval=${retval##*: }	# strip [Requesting program interpreter: 
	retval=${retval%]}	# strip ]
	case "${retval}" in
		"/tools/lib/ld-linux.so.2")	     msg_success ;;
		"/tools/lib64/ld-linux-x86-64.so.2") msg_success ;;
		*)					msg_line "       GCC is insane: "msg_failure ;;
	esac
	>  ${_complete}
	return 0
}
chapter-5-11() {
	local	_pkgname="tcl"
	local	_pkgver="8.6.1"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}${_pkgver}-src"
	build "Change directory: ${_pkgname}${_pkgver}/unix" "pushd ${_pkgname}${_pkgver}/unix" ${_logfile}
	build "Configure" "./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Installing Headers" "make install-private-headers" ${_logfile}
	build "chmod -v u+w /tools/lib/libtcl8.6.so" "chmod -v u+w /tools/lib/libtcl8.6.so" ${_logfile}
	build "ln -sv tclsh8.6 /tools/bin/tclsh" " ln -sv tclsh8.6 /tools/bin/tclsh" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-12() {
	local	_pkgname="expect"
	local	_pkgver="5.45"
	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}${_pkgver}"
	build "Change directory: ${_pkgname}${_pkgver}" "pushd ${_pkgname}${_pkgver}" ${_logfile}
	build "cp -v configure{,.orig}" "cp -v configure{,.orig}" ${_logfile}
	build "sed 's:/usr/local/bin:/bin:' configure.orig > configure" "sed 's:/usr/local/bin:/bin:' configure.orig > configure" ${_logfile}
	build "Configure" "./configure --prefix=/tools --with-tcl=/tools/lib --with-tclinclude=/tools/include" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" 'make SCRIPTS="" install' ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-13() {
	local	_pkgname="dejagnu"
	local	_pkgver="1.5.1"
	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Configure" "./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-14() {
	local	_pkgname="check"
	local	_pkgver="0.9.12"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Configure" "PKG_CONFIG= ./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-15() {
	local	_pkgname="ncurses"
	local	_pkgver="5.9"
	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Configure" "./configure --prefix=/tools --with-shared --without-debug --without-ada --enable-widec --enable-overwrite" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-16() {
	local	_pkgname="bash"
	local	_pkgver="4.2"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Patch" "patch -Np1 -i ../../SOURCES/bash-4.2-fixes-12.patch" ${_logfile}
	build "Configure" "./configure --prefix=/tools --without-bash-malloc" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "ln -sv bash /tools/bin/sh" "ln -sv bash /tools/bin/sh" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-17() {
local	_pkgname="bzip2"
	local	_pkgver="1.0.6"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Make" "make ${MKFLAGS} CFLAGS='-fPIC -O2 -g -pipe'" ${_logfile}
	build "Install" "make  PREFIX=/tools install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-18() {
	local	_pkgname="coreutils"
	local	_pkgver="8.22"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Configure" "./configure --prefix=/tools --enable-install-program=hostname" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-19() {
	local	_pkgname="diffutils"
	local	_pkgver="3.3"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Configure" "./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-20() {
	local	_pkgname="file"
	local	_pkgver="5.17"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Configure" "./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-21() {
	local	_pkgname="findutils"
	local	_pkgver="4.4.2"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Configure" "./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-22() {
	local	_pkgname="gawk"
	local	_pkgver="4.1.0"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Configure" "./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-23() {
	local	_pkgname="gettext"
	local	_pkgver="0.18.3.2"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}/gettext-tools" "pushd ${_pkgname}-${_pkgver}/gettext-tools" ${_logfile}
	build "Configure" "EMACS="no" ./configure --prefix=/tools --disable-shared" ${_logfile}
	build "make -C gnulib-lib" "make -C gnulib-lib" ${_logfile}
	build "make -C src msgfmt" "make -C src msgfmt" ${_logfile}
	build "make -C src msgmerge" "make -C src msgmerge" ${_logfile}
	build "make -C src xgettext" "make -C src xgettext" ${_logfile}
	build "cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin" "cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-24() {
	local	_pkgname="grep"
	local	_pkgver="2.16"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "Configure" "./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-25() {
	local	_pkgname="gzip"
	local	_pkgver="1.6"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "Configure" "./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-26() {
	local	_pkgname="m4"
	local	_pkgver="1.4.17"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "Configure" "./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-27() {
	local	_pkgname="make"
	local	_pkgver="4.0"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "Configure" "./configure --prefix=/tools --without-guile" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-28() {
	local	_pkgname="patch"
	local	_pkgver="2.7.1"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "Configure" "./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-29() {
	local	_pkgname="perl"
	local	_pkgver="5.18.2"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "Patch" "patch -Np1 -i ../../SOURCES/perl-5.18.2-libc-1.patch" ${_logfile}
	build "Configure" "sh Configure -des -Dprefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile} 
	build "cp -v perl cpan/podlators/pod2man /tools/bin" "cp -v perl cpan/podlators/pod2man /tools/bin" ${_logfile}
	build "mkdir -pv /tools/lib/perl5/5.18.2" "mkdir -pv /tools/lib/perl5/5.18.2" ${_logfile}
	build "cp -Rv lib/* /tools/lib/perl5/5.18.2" "cp -Rv lib/* /tools/lib/perl5/5.18.2" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-30() {
	local	_pkgname="sed"
	local	_pkgver="4.2.2"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "Configure" "./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-31() {
	local	_pkgname="tar"
	local	_pkgver="1.27.1"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "Configure" "./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-32() {
	local	_pkgname="texinfo"
	local	_pkgver="5.2"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "Configure" "./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-33() {
	local	_pkgname="util-linux"
	local	_pkgver="2.24.1"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "Configure" "./configure --prefix=/tools --disable-makeinstall-chown --without-systemdsystemunitdir PKG_CONFIG=''" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-34() {
	local	_pkgname="xz"
	local	_pkgver="5.0.5"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "Configure" "./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-35() {
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build 'strip --strip-debug /tools/lib/*' 'strip --strip-debug /tools/lib/* || true' ${_logfile}
	build '/usr/bin/strip --strip-unneeded /tools/{,s}bin/*' '/usr/bin/strip --strip-unneeded /tools/{,s}bin/* || true' ${_logfile}
	build 'rm -rf /tools/{,share}/{info,man,doc}' 'rm -rf /tools/{,share}/{info,man,doc}' ${_logfile}
	>  ${_complete}
	return 0
}
chapter-5-36() {
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "chown -R root:root $LFS/tools" "su -c 'chown -R root:root /mnt/lfs/tools'" ${_logfile}
	>  ${_complete}
	return 0
}

#
#	Add rpm to tool chain
#

chapter-5-zlib() {
	local	_pkgname="zlib"
	local	_pkgver="1.2.8"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "Configure" "./configure --prefix=/tools" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-nspr() {
	local _pkgname="nspr"
	local _pkgver="4.10.3"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	cd nspr
	sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in  || die "${FUNCNAME}: sed: FAILURE"
	sed -i 's#$(LIBRARY) ##' config/rules.mk  || die "${FUNCNAME}: sed: FAILURE"
	build "Configure" "PKG_CONFIG_PATH="/tools/lib/pkgconfig" ./configure --prefix=/tools --with-mozilla --with-pthreads $([ "$(uname -m)" = "x86_64" ] && echo --enable-64bit)" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-nss() {
	local _pkgname="nss"
	local _pkgver="3.15.4"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Patch" "patch -Np1 -i ../../SOURCES/nss-3.15.4-standalone-1.patch" ${_logfile}
	cd nss
	build "Make" "make BUILD_OPT=1 NSPR_INCLUDE_DIR=/tools/include/nspr USE_SYSTEM_ZLIB=1 ZLIB_LIBS=-lz $([ "$(uname -m)" = "x86_64" ] && echo USE_64=1) -j1" ${_logfile}
	cd ../dist
	build "install -vdm 755 /tools/bin" "install -vdm 755 /tools/bin" ${_logfile}
	build "install -vdm 755 /tools/lib/pkgconfig" "install -vdm 755 /tools/lib/pkgconfig" ${_logfile}
	build "install -vdm 755 /tools/include" "install -vdm 755 /tools/include" ${_logfile}
	build "install -v -m755 Linux*/lib/*.so /tools/lib" "install -v -m755 Linux*/lib/*.so /tools/lib" ${_logfile}
	build "install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /tools/lib" "install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /tools/lib" ${_logfile}
	build "cp -v -RL {public,private}/nss/* /tools/include" "cp -v -RL {public,private}/nss/* /tools/include" ${_logfile}
	build "install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /tools/bin" "install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /tools/bin" ${_logfile}
	build "install -v -m644 Linux*/lib/pkgconfig/nss.pc  /tools/lib/pkgconfig" "install -v -m644 Linux*/lib/pkgconfig/nss.pc  /tools/lib/pkgconfig" ${_logfile}
	build "sed -i 's|usr|tools|' /tools/lib/pkgconfig/nss.pc" "sed -i 's|usr|tools|' /tools/lib/pkgconfig/nss.pc" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-popt() {
	local _pkgname="popt"
	local _pkgver="1.16"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "Configure" "./configure --prefix=/tools --disable-static" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-readline() {
	local _pkgname="readline"
	local _pkgver="6.2"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "sed -i '/MV.*old/d' Makefile.in" "sed -i '/MV.*old/d' Makefile.in" ${_logfile}
	build "sed -i '/{OLDSUFF}/c:' support/shlib-install" "sed -i '/{OLDSUFF}/c:' support/shlib-install" ${_logfile}
	build "Patch" "patch -Np1 -i ../../SOURCES/readline-6.2-fixes-2.patch" ${_logfile}
	build "Configure" "PKG_CONFIG_PATH='/tools/lib/pkgconfig' ./configure --prefix=/tools --libdir=/tools/lib --with-curses=/tools/lib" ${_logfile}
	build "Make" "make ${MKFLAGS} SHLIB_LIBS=-lncursesw" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-elfutils() {
	local _pkgname="elfutils"
	local _pkgver="0.158"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Configure" 'PKG_CONFIG_PATH="/tools/lib/pkgconfig" ./configure --prefix=/tools --program-prefix="eu-" --with-bzlib=no' ${_logfile}
	build "Make" "make ${MKFLAGS} SHLIB_LIBS=-lncursesw" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-lua() {
	local _pkgname="lua"
	local _pkgver="5.2.3"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "Patch" "patch -Np1 -i ../../SOURCES/lua-5.2.3-shared_library-1.patch" ${_logfile}
	build "Make" "make ${MKFLAGS} linux" ${_logfile}
	build "Install" "make INSTALL_TOP=/tools TO_LIB='liblua.so liblua.so.5.2 liblua.so.5.2.3' INSTALL_DATA='cp -d' INSTALL_MAN=/tools/share/man/man1 install" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-5-rpm() {
	local _pkgname="rpm"
	local _pkgver="4.11.2"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build "Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	unpack "${PWD}" "db-6.0.20"
	build "ln -vs db-6.0.20 db" "ln -vs db-6.0.20 db" ${_logfile}
	build "Configure" "PKG_CONFIG_PATH=/tools/lib/pkgconfig CPPFLAGS='-I/tools/include -I/tools/include/nspr' ./configure --prefix=/tools --disable-static --disable-dependency-tracking --without-lua" ${_logfile}
	build "Make" "make ${MKFLAGS}" ${_logfile}
	build "Install" "make install" ${_logfile}
	build "install -dm 755 /tools/etc/rpm" "install -dm 755 /tools/etc/rpm" ${_logfile}
	build "rm -v/tools/bin/{rpmquery,rpmverify}" "rm -v /tools/bin/{rpmquery,rpmverify}" ${_logfile}
	build "ln -vsf rpm /tools/bin/rpmquery" "ln -vsf rpm /tools/bin/rpmquery" ${_logfile}
	build "ln -vsf rpm /tools/bin/rpmverify" "ln -vsf rpm /tools/bin/rpmverify" ${_logfile}
	build "install -vm 755 ${LFS}${PARENT}/macros /tools/etc/rpm" "install -vm 755 ${LFS}${PARENT}/macros /tools/etc/rpm" ${_logfile}
	build "Restore directory" "popd " /dev/null
	build "Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
#
#	Build chapter 6
#
chapter-config(){
	local	_logfile="${PARENT}/LOGS/${FUNCNAME}.log"
	local	_complete="${PARENT}/LOGS/${FUNCNAME}.completed"
	local _list="/etc/sysconfig/clock "
	_list+="/etc/sysconfig/console "
	_list+="/etc/profile "
	_list+="/etc/sysconfig/network "
	_list+="/etc/hosts "
	_list+="/etc/fstab "
	_list+="/etc/sysconfig/ifconfig.eth0 "
	_list+="/etc/resolv.conf "
	_list+="/etc/passwd "
	_list+="/etc/lsb-release "
	_list+="/etc/sysconfig/rc.site"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
	> ${_logfile}
	build '/sbin/locale-gen.sh' '/sbin/locale-gen.sh' ${_logfile}
	build '/sbin/ldconfig' '/sbin/ldconfig' ${_logfile}
	#	enable shadowed passwords and group passwords
	build '/usr/sbin/pwconv' '/usr/sbin/pwconv' ${_logfile}
	build '/usr/sbin/grpconv' '/usr/sbin/grpconv' ${_logfile}
	build '/sbin/udevadm hwdb --update' '/sbin/udevadm hwdb --update' ${_logfile}
	#	Configuration
	for i in ${_list}; do vim "${i}";done
	>  ${_complete}
	return 0
}
#
#	Command line Functions
#
cmd_mount() {
	local i=""
	[ ${EUID} -eq 0 ] || die "${FUNCNAME}: Need to be root user: FAILURE"
	[ -d ${LFS} ] || install -dm 755 ${LFS} || die "${FUNCNAME}: FAILURE"
	chmod 755 ${LFS} || die "${FUNCNAME}: FAILURE"
	for ((i=0;i<${#MNT_POINT[@]};++i)); do
		[ "sdxx" = "${PARTITION[i]}" ] && continue
		mountpoint /mnt/${MNT_POINT[i]} > /dev/null 2>&1 && continue
		msg_line "Mounting: ${PARTITION[i]} --> ${MNT_POINT[i]}: "
		install -dm 755 /mnt/${MNT_POINT[i]} || die "${FUNCNAME}: FAILURE"
		mount -t ${FILSYSTEM[i]} /dev/${PARTITION[i]} /mnt/${MNT_POINT[i]} || die "${FUNCNAME}: FAILURE"
		msg_success
	done
	[ -d ${LFS}/tools ]	|| { install -dm 775 ${LFS}/tools || die "${FUNCNAME}: FAILURE"; }
	[ -h /tools ]		|| { ln -s ${LFS}/tools /         || die "${FUNCNAME}: FAILURE"; }
	return 0
}
cmd_umount() {
	[ ${EUID} -eq 0 ] || die "${FUNCNAME}: Need to be root user: FAILURE"
	msg_line "Unmounting ${LFS} partitions: "
	umount -v -R ${LFS} > /dev/null 2>&1 || die "${FUNCNAME}: FAILURE"
	rm -rf ${LFS} || die "${FUNCNAME}: FAILURE"
	rm -rf /tools || die "${FUNCNAME}: FAILURE"
	msg_success
	return 0
}
cmd_filesystem() {
	local i=""
	local p=""
	[ ${EUID} -eq 0 ] || die "${FUNCNAME}: Need to be root user: FAILURE"
	msg "Create/wipe filesystem(s)"
	for ((i=0;i<${#MNT_POINT[@]};++i)); do
		[ "sdxx" = "${PARTITION[i]}" ] && continue
		msg_line "       Create/wipe filesystem on /dev/${PARTITION[i]} (y/n) "
		read p
		case $p in
			y|Y)	true ;;
			n|N)	die "       Canceling create filesystem, Can not continue" ;;
			*)	die "       Invalid response, Can not continue" ;;
		esac
		msg_line "Creating filesystem: ${PARTITION[i]} on ${MNT_POINT[i]}: "
		mkfs -v -t ${FILSYSTEM[i]} /dev/${PARTITION[i]} > /dev/null 2>&1 || die "${FUNCNAME}: FAILURE"
		msg_success
	done
	return 0
}
cmd_fetch() {
	msg_line "Fetching source packages: "
	[ -d SOURCES ] || install -dm755 SOURCES
	#	fetch and check LFS source packages
	wget -nc -i wget-list -P SOURCES > /dev/null 2>&1 || die "${FUNCNAME}: FAILURE"
	wget -nc -i wget-rpm -P SOURCES > /dev/null 2>&1 || die "${FUNCNAME}: Fetch rpm packages: FAILURE"
	pushd SOURCES > /dev/null 2>&1;
		md5sum -c ../md5sums > /dev/null 2>&1 || die "Check of source packages FAILED"
		md5sum -c ../md5sums-rpm > /dev/null 2>&1 || die "Check of rpm packages FAILED"
	popd > /dev/null 2>&1;
	msg_success
	return 0
}
cmd_install() {
	local 	i=""
	local 	list="BOOK BUILD BUILDROOT SOURCES SPECS builder md5sums wget-list "
		list+="config-3.13.3-x86_64 config-3.10.10-i686 config version-check "
		list+="wget-rpm md5sums-rpm locale-gen.conf locale-gen.sh macros "
	msg "Install build system"
	[ ${EUID} -eq 0 ] || die "${FUNCNAME}: Need to be root user: FAILURE"
	mountpoint ${LFS} > /dev/null 2>&1 || {
		msg_line "       /mnt/lfs is not mounted: continue: (y/n) "
		read i
		case $i in
			y|Y)	msg "       Installing build system to directory"; true ;;
			n|N)	die "       Canceling, Can not continue" ;;
			*)	die "       Invalid response, Can not continue" ;;
		esac
	}
	msg_line "       Installing build system to ${LFS}${PARENT}: "
	install -dm 755 ${LFS}/${PARENT}/{BOOK,BUILD,BUILDROOT,LOGS,RPMS,SOURCES,SPECS} || die "${FUNCNAME}: Can not create directories"
	#	copy file to system under build
	for i in ${list}; do
		cp -ar "${i}" "${LFS}/${PARENT}" || die "${FUNCNAME}: Error trying to copy build system to ${LFS}/${PARENT}"
	done
	chmod 775 ${LFS}/${PARENT}/builder
	unmount_filesystems && chown -R lfs:lfs ${LFS} || die "${FUNCNAME}: FAILURE"
	msg_success
	return 0
}
cmd_rmuser() {
	[ ${EUID} -eq 0 ] || die "${FUNCNAME}: Need to be root user: FAILURE"
	msg_line "Removing lfs user: "
	getent passwd lfs > /dev/null 2>&1 && { userdel  lfs || die "Can not remove lfs user "; }
	getent group  lfs > /dev/null 2>&1 && { groupdel lfs || die "Can not remove lfs group"; }
	[ -d "/home/lfs" ] && { rm -rf "/home/lfs" || die "${FUNCNAME}: FAILURE"; }
	msg_success
	return 0
}
cmd_user() {
	[ ${EUID} -eq 0 ] || die "${FUNCNAME}: Need to be root user: FAILURE"
	msg_line "Creating lfs user: "
	getent group  lfs > /dev/null 2>&1 || { groupadd lfs || die "Can not create lfs group"; }
	getent passwd lfs > /dev/null 2>&1 || { useradd -c 'LFS user' -g lfs -m -k /dev/null -s /bin/bash lfs || die "Can not create lfs user"; }
	passwd -l lfs > /dev/null 2>&1  || die "${FUNCNAME}: FAILURE"
	cat > /home/lfs/.bash_profile <<- "EOF"
		exec env -i HOME=/home/lfs TERM=${TERM} PS1='\u:\w\$ ' /bin/bash
	EOF
	cat > /home/lfs/.bashrc <<- "EOF"
		set +h
		umask 022
		LFS=/mnt/lfs
		LC_ALL=POSIX
		LFS_TGT=$(uname -m)-lfs-linux-gnu
		PATH=/tools/bin:/bin:/usr/bin
		export LFS LC_ALL LFS_TGT PATH
	EOF
	chown -R lfs:lfs /home/lfs	|| die "${FUNCNAME}: FAILURE"
	msg_success
	return 0
}
cmd_tools() {
	[ "lfs" != $(whoami) ] && die "${FUNCNAME}: Not lfs user: FAILURE"
	msg "Building Chapter 5 Tool chain"
	cd ${LFS}${PARENT}
	chapter-5-04	#	5.4.  Binutils-2.24 - Pass 1
	chapter-5-05	#	5.5.  GCC-4.8.2 - Pass 1
	chapter-5-06	#	5.6.  Linux-3.13.3 API Headers
	chapter-5-07	#	5.7.  Glibc-2.19
	chapter-5-08	#	5.8.  Libstdc++-4.8.2
	chapter-5-09	#	5.9.  Binutils-2.24 - Pass 2
	chapter-5-10	#	5.10. GCC-4.8.2 - Pass 2
	chapter-5-11	#	5.11. Tcl-8.6.1
	chapter-5-12	#	5.12. Expect-5.45
	chapter-5-13	#	5.13. DejaGNU-1.5.1
	chapter-5-14	#	5.14. Check-0.9.12
	chapter-5-15	#	5.15. Ncurses-5.9
	chapter-5-16	#	5.16. Bash-4.2
	chapter-5-17	#	5.17. Bzip2-1.0.6
	chapter-5-18	#	5.18. Coreutils-8.22
	chapter-5-19	#	5.19. Diffutils-3.3
	chapter-5-20	#	5.20. File-5.17
	chapter-5-21	#	5.21. Findutils-4.4.2
	chapter-5-22	#	5.22. Gawk-4.1.0
	chapter-5-23	#	5.23. Gettext-0.18.3.2
	chapter-5-24	#	5.24. Grep-2.16
	chapter-5-25	#	5.25. Gzip-1.6
	chapter-5-26	#	5.26. M4-1.4.17
	chapter-5-27	#	5.27. Make-4.0
	chapter-5-28	#	5.28. Patch-2.7.1
	chapter-5-29	#	5.29. Perl-5.18.2
	chapter-5-30	#	5.30. Sed-4.2.2 
	chapter-5-31	#	5.31. Tar-1.27.1
	chapter-5-32	#	5.32. Texinfo-5.2
	chapter-5-33	#	5.33. Util-linux-2.24.1
	chapter-5-34	#	5.34. Xz-5.0.5
#	The following packages comprise the package management system RPM
	chapter-5-zlib		#
	chapter-5-nspr		#
	chapter-5-nss		#
	chapter-5-popt		#
	chapter-5-readline	#
	chapter-5-elfutils	#
#	chapter-5-lua		#	Not needed is optional
	chapter-5-rpm		#
#	The following are not used
#	chapter-5-35	#	5.35. Stripping
#	chapter-5-36	#	5.36. Changing Ownership
	return 0
}
cmd_system() {
	local RPMPKG=""
	local list=""
	local i=""
	[ ${EUID} -eq 0 ] || die "${FUNCNAME}: Need to be root user: FAILURE"
	if [ -d /mnt/lfs/tools ]; then 	#	We are not in chroot so set this up
		cd ${LFS}${PARENT}
		# rm -rf BUILD/* BUILDROOT/*
		#	Setup the default filesystem
		[ -e "LOGS/filesystem.completed" ] || {
			RPMPKG="$(find RPMS -name 'filesystem-[0-9]*.rpm' -print)"
			[ -z ${RPMPKG} ] && PATH="/tools/bin:${PATH}" rpmbuild -ba --nocheck --define "_topdir ${LFS}/${PARENT}" --define "_dbpath ${LFS}/var/lib/rpm" SPECS/filesystem.spec > "LOGS/filesystem.log" 
			RPMPKG="$(find RPMS -name 'filesystem-[0-9]*.rpm' -print)"
			[ -z ${RPMPKG} ] && die "Filesystem rpm package missing: Can not continue"
			PATH="/tools/bin:${PATH}" rpm -Uvh --nodeps --root /mnt/lfs --replacepkgs ${RPMPKG} > "LOGS/filesystem.completed"
			build "Creating symlinks: /tools/bin/{bash,cat,echo,pwd,stty}" \
				"ln -fsv /tools/bin/{bash,cat,echo,pwd,stty} ${LFS}/bin"   "LOGS/filesystem.completed"
			build "Creating symlinks: /tools/bin/perl /usr/bin" \
				"ln -fsv /tools/bin/perl ${LFS}/usr/bin" "LOGS/filesystem.completed"
			build "Creating symlinks: /tools/lib/libgcc_s.so{,.1}" \
				"ln -fsv /tools/lib/libgcc_s.so{,.1} ${LFS}/usr/lib" "LOGS/filesystem.completed"
			build "Creating symlinks: /tools/lib/libstdc++.so{,.6} /usr/lib" \
				"ln -fsv /tools/lib/libstdc++.so{,.6} ${LFS}/usr/lib"	 "LOGS/filesystem.completed"
			build "Sed: /usr/lib/libstdc++.la" \
				"sed 's/tools/usr/' /tools/lib/libstdc++.la > ${LFS}/usr/lib/libstdc++.la" "LOGS/filesystem.completed"
			build "Creating symlinks: bash /bin/sh" "ln -fsv bash ${LFS}/bin/sh" "LOGS/filesystem.completed"
			#	Ommited in the filesystem.spec file - not needed for booting
			[ -e ${LFS}/dev/console ]	|| mknod -m 600 ${LFS}/dev/console c 5 1
			[ -e ${LFS}/dev/null ]		|| mknod -m 666 ${LFS}/dev/null c 1 3
		}
		# the line below umount the kernel filesystems so we can change ownership
		unmount_filesystems && chown -R 0:0 /mnt/lfs/* || die "${FUNCNAME}: FAILURE"
		mount_filesystems	#	Mount kernel fileystems
		#	Goto chroot everthing is ready. get to building
		chroot "${LFS}" \
			/tools/bin/env -i \
			HOME=/root \
			TERM="$TERM" \
			PS1='\u:\w\$ ' \
			PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
			/tools/bin/bash --login +h -c "/usr/src/Octothorpe/builder -s"
		unmount_filesystems			
	else
		msg "Building System"
		cd ${PARENT}
		# add 	--disable-silent-rules to configure for the following
		# e2fsprogs perl sysklogd <-- problem children
		#
		#	Test gcc compile without /lib64
		#	sed doesn't work because [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
		#	Fix that at gcc build stage
		#
		list="linux-api-headers man-pages glibc tzdata adjust-tool-chain zlib file "
		list+="binutils gmp mpfr mpc gcc test-gcc "
		list+="sed bzip2 pkg-config ncurses shadow psmisc procps-ng e2fsprogs "
		list+="coreutils iana-etc m4 flex bison grep readline bash bc libtool "
		list+="gdbm inetutils perl autoconf automake diffutils gawk findutils "
		list+="gettext groff xz grub less gzip iproute2 kbd kmod libpipeline "
		list+="make patch sysklogd sysvinit tar texinfo udev util-linux man-db vim "
		#	eudev - this is for later
		list+="bootscripts linux "
		#	The following packages comprise the package management system RPM
		list+="elfutils nspr nss popt lua rpm chapter-config" 
		#udev
		for i in ${list}; do
			RPMPKG=""
			case ${i} in
				adjust-tool-chain) 
					[ -e LOGS/adjust-tool-chain.log ] || {	> LOGS/adjust-tool-chain.log
						build "mv -v /tools/bin/{ld,ld-old}" "mv -v /tools/bin/{ld,ld-old}" "LOGS/adjust-tool-chain.log"
						build "mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}" "mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}" "LOGS/adjust-tool-chain.log"
						build "mv -v /tools/bin/{ld-new,ld}" "mv -v /tools/bin/{ld-new,ld}" "LOGS/adjust-tool-chain.log"
						build "ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld" "ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld" "LOGS/adjust-tool-chain.log"
						gcc -dumpspecs | sed -e 's@/tools@@g' -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
							-e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' > `dirname $(gcc --print-libgcc-file-name)`/specs
 						build "echo 'main(){}' > dummy.c" "echo 'main(){}' > dummy.c" "LOGS/adjust-tool-chain.log"
						build "cc dummy.c -v -Wl,--verbose &> dummy.log" "cc dummy.c -v -Wl,--verbose &> dummy.log" "LOGS/adjust-tool-chain.log"
						build "readelf -l a.out | grep ': /lib'" "readelf -l a.out | grep ': /lib'" "LOGS/adjust-tool-chain.log"
						build "grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log" "grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log" "LOGS/adjust-tool-chain.log"
						build "grep -B1 '^ /usr/include' dummy.log" "grep -B1 '^ /usr/include' dummy.log" "LOGS/adjust-tool-chain.log"
						build "grep 'SEARCH.*' dummy.log |sed 's|; |\n|g'" "grep 'SEARCH.*' dummy.log |sed 's|; |\n|g'" "LOGS/adjust-tool-chain.log"
						build 'grep "/lib.*/libc.so.6 " dummy.log' 'grep "/lib.*/libc.so.6 " dummy.log' "LOGS/adjust-tool-chain.log"
						build "grep found dummy.log" "grep found dummy.log" "LOGS/adjust-tool-chain.log"
						build "rm -v dummy.c a.out dummy.log" "rm -v dummy.c a.out dummy.log" "LOGS/adjust-tool-chain.log"
					};
				;;
				chapter-config) chapter-config ;;
				test-gcc)	[ -e "LOGS/gcc-test.log" ] || {
							> "LOGS/gcc-test.log"
							build "Testing chapter-06: gcc" "echo 'main(){}' > dummy.c" "LOGS/gcc-test.log"
							build "cc dummy.c -v -Wl,--verbose &> dummy.log" "cc dummy.c -v -Wl,--verbose &> dummy.log" "LOGS/gcc-test.log"
							build "readelf -l a.out | grep ': /lib'" "readelf -l a.out | grep ': /lib'" "LOGS/gcc-test.log"
							build "grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log" "grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log" "LOGS/gcc-test.log"
							build "grep -B4 '^ /usr/include' dummy.log" "grep -B4 '^ /usr/include' dummy.log" "LOGS/gcc-test.log"
							build "grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'" "grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'" "LOGS/gcc-test.log"
							build "grep '/lib.*/libc.so.6 ' dummy.log" "grep '/lib.*/libc.so.6 ' dummy.log" "LOGS/gcc-test.log"
							build "grep found dummy.log" "grep found dummy.log" "LOGS/gcc-test.log"
							build "Clean up test files: gcc" "rm -v dummy.c a.out dummy.log" "LOGS/gcc-test.log"
						}
				;;
				*)	rm -rf BUILD/* BUILDROOT/* > /dev/null 2>&1
					RPMPKG=$(find RPMS -name "${i}-[0-9]*.rpm" -print)
					[ -z $RPMPKG ] || printf "%s\n" "       Skipping: ${i}"
					[ -z $RPMPKG ] && > "LOGS/${i}.log"	# clean log files
					[ -z $RPMPKG ] && build "Building: ${i}" 'rpmbuild -ba --nocheck SPECS/${i}.spec' "LOGS/${i}.log"
					[ -e LOGS/${i}.completed ] && continue;
					RPMPKG=$(find RPMS -name "${i}-[0-9]*.rpm" -print)
					[ -z $RPMPKG ] && die "installation error: rpm package not found\n"
					case ${i} in
						glibc | gmp | gcc | bzip2 | ncurses | util-linux | e2fsprogs | shadow | bison | perl | texinfo | vim | linux | udev | rpm)
							build "Installing: ${i}" "rpm -Uvh --nodeps --replacepkgs ${RPMPKG}" "LOGS/${i}.completed" ;;
						*)	build "Installing: ${i}" "rpm -Uvh --replacepkgs ${RPMPKG}" "LOGS/${i}.completed" ;;
					esac
				;;
			esac
		done
	fi
	return 0
}
#
#	Main line
#
MK_UMOUNT=false
MK_MOUNT=false
MK_FILESYSTEM=false
MK_MOUNT=false
MK_FETCH=false
MK_INSTALL=false
MK_USER=false
MK_RMUSER=false
MK_TOOLS=false
MK_SYSTEM=false
OPTSTRING=cmufirltsh
[ $# -eq 0 ] && usage
while getopts $OPTSTRING opt; do
	case $opt in
		u)	MK_UMOUNT=true		;;
		m)	MK_MOUNT=true 		;;
		c)	MK_FILESYSTEM=true	;;
		f)	MK_FETCH=true		;;
		i)	MK_INSTALL=true		;;
		r)	MK_RMUSER=true		;;
		l)	MK_USER=true		;;
		s)	MK_SYSTEM=true		;;
		t)	MK_TOOLS=true		;;
		h)	usage			;;
		*)	usage			;;
	esac
done
shift $(( $OPTIND - 1 ))	# remove options from command line
[ ${MK_RMUSER} = "true" ]	&& cmd_rmuser
[ ${MK_UMOUNT} = "true" ] 	&& cmd_umount
[ ${MK_FILESYSTEM} = "true" ]	&& cmd_filesystem
[ ${MK_MOUNT} = "true" ]	&& cmd_mount
[ ${MK_USER} = "true" ]		&& cmd_user
[ ${MK_FETCH} = "true" ]	&& cmd_fetch
[ ${MK_INSTALL} = "true" ]	&& cmd_install
[ ${MK_TOOLS} = "true" ]	&& cmd_tools
[ ${MK_SYSTEM} = "true" ]	&& cmd_system
#msg "Run Completed"