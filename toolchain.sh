#!/bin/bash
set -o errexit		# exit if error...insurance ;)
set -o nounset		# exit if variable not initalized
set +h			# disable hashall
source config.inc.sh
source function.inc.sh
PRGNAME=${0##*/}	# script name minus the path

chapter-05-04() {
	local	_pkgname="binutils"
	local	_pkgver="2.30"
	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Create work directory" "install -vdm 755 ../build" ${_logfile}
	build "	Change directory: ../build" "pushd ../build" ${_logfile}
	build "	Configure" "../${_pkgname}-${_pkgver}/configure --prefix=/tools --with-sysroot=${LFS} --with-lib-path=/tools/lib --target=${LFS_TGT} --disable-nls --disable-werror" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	[ "x86_64" == $(uname -m) ] && build "	Create symlink for 64-bit" "install -vdm 755 /tools/lib;ln -vfs lib /tools/lib64" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}

chapter-05-05() {
	local	_pkgname="gcc"
	local	_pkgver="7.3.0"
	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	local	_pwd=${PWD}/BUILD
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	build "	Create work directory" "install -vdm 755 build" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	unpack "${PWD}" "mpfr-4.0.1"
	unpack "${PWD}" "gmp-6.1.2"
	unpack "${PWD}" "mpc-1.1.0"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Symlinking gmp" " ln -vs ../gmp-6.1.2  gmp" ${_logfile}
	build "	Symlinking mpc" " ln -vs ../mpc-1.1.0  mpc" ${_logfile}
	build "	Symlinking mpfr" "ln -vs ../mpfr-4.0.1 mpfr" ${_logfile}
	build "	Fixing headers" 'for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h); do cp -uv $file{,.orig};sed -e "s@/lib\(64\)\?\(32\)\?/ld@/tools&@g" -e "s@/usr@/tools@g" $file.orig > $file;printf "\n%s\n%s\n%s\n%s\n\n" "#undef STANDARD_STARTFILE_PREFIX_1" "#undef STANDARD_STARTFILE_PREFIX_2" "#define STANDARD_STARTFILE_PREFIX_1 \"/tools/lib/\"" "#define STANDARD_STARTFILE_PREFIX_2 \"\" ">> $file;touch $file.orig;done' ${_logfile}
	#build "	sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure" "sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure" ${_logfile}
	[ "x86_64" == $(uname -m) ] && build "	Set lib directory" "sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64" "${_logfile}"
	build "	Change directory: ../build" "pushd ../build" ${_logfile}
	build "	Configure" "../${_pkgname}-${_pkgver}/configure --target=${LFS_TGT} --prefix=/tools --with-glibc-version=2.11 --with-sysroot=${LFS} --with-newlib --without-headers --with-local-prefix=/tools --with-native-system-header-dir=/tools/include --disable-nls --disable-shared --disable-multilib --disable-decimal-float --disable-threads --disable-libatomic --disable-libgomp --disable-libmpx --disable-libquadmath --disable-libssp --disable-libvtv --disable-libstdcxx --enable-languages=c,c++ " ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	#build "	Symlinking libgcc_eh.a" 'ln -vs libgcc.a $(${LFS_TGT}-gcc -print-libgcc-file-name | sed "s/libgcc/&_eh/")' ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-06() {
	local	_pkgname="linux"
	local	_pkgver="4.15.3"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	make mrproper" "make mrproper" ${_logfile}
	#build "	make headers_check" "make headers_check" ${_logfile}
	build "	make INSTALL_HDR_PATH=dest headers_install" "make INSTALL_HDR_PATH=dest headers_install" ${_logfile}
	build "	cp -rv dest/include/* /tools/include" "cp -rv dest/include/* /tools/include" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-07() {
	local	_pkgname="glibc"
	local	_pkgver="2.27"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Create work directory" "install -vdm 755 ../build" ${_logfile}
	build "	Change directory: ../build" "pushd ../build" ${_logfile}
	build "	Configure" "../${_pkgname}-${_pkgver}/configure --prefix=/tools --host=${LFS_TGT} --build=$(../${_pkgname}-${_pkgver}/scripts/config.guess) --enable-kernel=3.2 --with-headers=/tools/include libc_cv_forced_unwind=yes libc_cv_c_cleanup=yes" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	msg_line "       Checking glibc for sanity: "
	echo 'int main(){}' > dummy.c
	${LFS_TGT}-gcc dummy.c
	retval=$(readelf -l a.out | grep ': /tools')
	rm dummy.c a.out
	retval=${retval##*: }	# strip [Requesting program interpreter: 
	retval=${retval%]}	# strip ]
	case "${retval}" in
		"/tools/lib/ld-linux.so.2")		msg_success ;;
		"/tools/lib64/ld-linux-x86-64.so.2")	msg_success ;;
		*)	msg_line "       Glibc is insane: "msg_failure ;;
	esac
	>  ${_complete}
	return 0
}
chapter-05-08() {
	local	_pkgname="gcc"
	local	_pkgver="7.3.0"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Create work directory" "install -vdm 755 ../build" ${_logfile}
	build "	Change directory: ../build" "pushd ../build" ${_logfile}
	build "	Configure" "../${_pkgname}-${_pkgver}/libstdc++-v3/configure --host=$LFS_TGT --prefix=/tools --disable-multilib --disable-nls --disable-libstdcxx-threads --disable-libstdcxx-pch --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/${_pkgver}" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-09() {
	local	_pkgname="binutils"
	local	_pkgver="2.30"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Create work directory" "install -vdm 755 ../build" ${_logfile}
	build "	Change directory: ../build" "pushd ../build" ${_logfile}
	build "	Configure" "CC=${LFS_TGT}-gcc AR=${LFS_TGT}-ar RANLIB=${LFS_TGT}-ranlib ../${_pkgname}-${_pkgver}/configure --prefix=/tools --disable-nls --disable-werror --with-lib-path=/tools/lib --with-sysroot" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	make -C ld clean" "make -C ld clean" ${_logfile}
	build "	make -C ld LIB_PATH=/usr/lib:/lib" "make -C ld LIB_PATH=/usr/lib:/lib" ${_logfile}
	build "	cp -v ld/ld-new /tools/bin" "cp -v ld/ld-new /tools/bin" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-10() {
	local	_pkgname="gcc"
	local	_pkgver="7.3.0"
	local	_pwd=${PWD}/BUILD
	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	unpack "${PWD}" "mpfr-4.0.1"
	unpack "${PWD}" "gmp-6.1.2"
	unpack "${PWD}" "mpc-1.1.0"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Symlinking gmp" " ln -vs ../gmp-6.1.2  gmp" ${_logfile}
	build "	Symlinking mpc" " ln -vs ../mpc-1.1.0  mpc" ${_logfile}
	build "	Symlinking mpfr" "ln -vs ../mpfr-4.0.1 mpfr" ${_logfile}
	build "	Fixing limits.h" 'cat gcc/limitx.h gcc/glimits.h gcc/limity.h > $(dirname $( ${LFS_TGT}-gcc -print-libgcc-file-name))/include-fixed/limits.h' ${_logfile}
	build "	Fixing headers" 'for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h); do cp -uv $file{,.orig};sed -e "s@/lib\(64\)\?\(32\)\?/ld@/tools&@g" -e "s@/usr@/tools@g" $file.orig > $file;printf "\n%s\n%s\n%s\n%s\n\n" "#undef STANDARD_STARTFILE_PREFIX_1" "#undef STANDARD_STARTFILE_PREFIX_2" "#define STANDARD_STARTFILE_PREFIX_1 \"/tools/lib/\"" "#define STANDARD_STARTFILE_PREFIX_2 \"\" ">> $file;touch $file.orig;done' ${_logfile}
	[ "x86_64" == $(uname -m) ] && build "	Set lib directory" "sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64" "${_logfile}"
	build "	Create work directory" "install -vdm 755 ../build" ${_logfile}
	build "	Change directory: ../build" "pushd ../build" ${_logfile}
	build "	Configure" "CC=${LFS_TGT}-gcc CXX=${LFS_TGT}-g++ AR=${LFS_TGT}-ar RANLIB=${LFS_TGT}-ranlib ../${_pkgname}-${_pkgver}/configure --prefix=/tools --with-local-prefix=/tools --with-native-system-header-dir=/tools/include --enable-languages=c,c++ --disable-libstdcxx-pch --disable-multilib --disable-bootstrap --disable-libgomp" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	ln -sv gcc /tools/bin/cc" "ln -sv gcc /tools/bin/cc" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	msg_line "       Checking glibc for sanity: "
	echo 'int main(){}' > dummy.c
	${LFS_TGT}-gcc dummy.c
	retval=$(readelf -l a.out | grep ': /tools')
	rm dummy.c a.out
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
chapter-05-11() {
	local	_pkgname="tcl"
	local	_pkgver="8.6.8"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}${_pkgver}-src"
	build "	Change directory: ${_pkgname}${_pkgver}/unix" "pushd ${_pkgname}${_pkgver}/unix" ${_logfile}
	build "	Configure" "./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	chmod -v u+w /tools/lib/libtcl8.6.so" "chmod -v u+w /tools/lib/libtcl8.6.so" ${_logfile}
	build "	Installing Headers" "make install-private-headers" ${_logfile}
	build "	ln -sv tclsh8.6 /tools/bin/tclsh" " ln -sv tclsh8.6 /tools/bin/tclsh" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-12() {
	local	_pkgname="expect"
	local	_pkgver="5.45.4"
	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}${_pkgver}"
	build "	Change directory: ${_pkgname}${_pkgver}" "pushd ${_pkgname}${_pkgver}" ${_logfile}
	build "	cp -v configure{,.orig}" "cp -v configure{,.orig}" ${_logfile}
	build "	sed 's:/usr/local/bin:/bin:' configure.orig > configure" "sed 's:/usr/local/bin:/bin:' configure.orig > configure" ${_logfile}
	build "	Configure" "./configure --prefix=/tools --with-tcl=/tools/lib --with-tclinclude=/tools/include" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" 'make SCRIPTS="" install' ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-13() {
	local	_pkgname="dejagnu"
	local	_pkgver="1.6.1"
	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Configure" "./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-14() {
	local	_pkgname="m4"
	local	_pkgver="1.4.18"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Configure" "PKG_CONFIG= ./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-15() {
	local	_pkgname="ncurses"
	local	_pkgver="6.1"
	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build " sed -i s/mawk// configure" "sed -i s/mawk// configure" ${_logfile}
	build "	Configure" "./configure --prefix=/tools --with-shared --without-debug --without-ada --enable-widec --enable-overwrite" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-16() {
	local	_pkgname="bash"
	local	_pkgver="4.4.18"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Configure" "./configure --prefix=/tools --without-bash-malloc" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	ln -sv bash /tools/bin/sh" "ln -sv bash /tools/bin/sh" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-17 () {
	local	_pkgname="bison"
	local	_pkgver="3.0.4"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Configure" "./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make  PREFIX=/tools install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-18() {
	local	_pkgname="bzip2"
	local	_pkgver="1.0.6"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Make" "make ${MKFLAGS} CFLAGS='-fPIC -O2 -g -pipe'" ${_logfile}
	build "	Install" "make  PREFIX=/tools install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-19() {
	local	_pkgname="coreutils"
	local	_pkgver="8.29"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Configure" "./configure --prefix=/tools --enable-install-program=hostname" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-20() {
	local	_pkgname="diffutils"
	local	_pkgver="3.6"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Configure" "./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-21() {
	local	_pkgname="file"
	local	_pkgver="5.32"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Configure" "./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-22() {
	local	_pkgname="findutils"
	local	_pkgver="4.6.0"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Configure" "./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-23() {
	local	_pkgname="gawk"
	local	_pkgver="4.2.0"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Configure" "./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-24() {
	local	_pkgname="gettext"
	local	_pkgver="0.19.8.1"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}/gettext-tools" "pushd ${_pkgname}-${_pkgver}/gettext-tools" ${_logfile}
	build "	Configure" "EMACS="no" ./configure --prefix=/tools --disable-shared" ${_logfile}
	build "	make -C gnulib-lib" "make -C gnulib-lib" ${_logfile}
	build "	make -C intl pluralx.c" "make -C intl pluralx.c" ${_logfile}
	build "	make -C src msgfmt" "make -C src msgfmt" ${_logfile}
	build "	make -C src msgmerge" "make -C src msgmerge" ${_logfile}
	build "	make -C src xgettext" "make -C src xgettext" ${_logfile}
	build "	cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin" "cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-25() {
	local	_pkgname="grep"
	local	_pkgver="3.1"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "	Configure" "./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-26() {
	local	_pkgname="gzip"
	local	_pkgver="1.9"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "	Configure" "./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-27() {
	local	_pkgname="make"
	local	_pkgver="4.2.1"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "	sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c" "sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c" ${_logfile}
	build "	Configure" "./configure --prefix=/tools --without-guile" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-28() {
	local	_pkgname="patch"
	local	_pkgver="2.7.6"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "	Configure" "./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-29() {
	local	_pkgname="perl"
	local	_pkgver="5.26.1"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "	Configure" "sh Configure -des -Dprefix=/tools -Dlibs=-lm" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile} 
	build "	cp -v perl cpan/podlators/scripts/pod2man /tools/bin" "cp -v perl cpan/podlators/scripts/pod2man /tools/bin" ${_logfile}
	build "	mkdir -pv /tools/lib/perl5/${_pkgver}" "mkdir -pv /tools/lib/perl5/${_pkgver}" ${_logfile}
	build "	cp -Rv lib/* /tools/lib/perl5/${_pkgver}" "cp -Rv lib/* /tools/lib/perl5/${_pkgver}" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-30() {
	local	_pkgname="sed"
	local	_pkgver="4.4"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "	Configure" "./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-31() {
	local	_pkgname="tar"
	local	_pkgver="1.30"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "	Configure" "./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-32() {
	local	_pkgname="texinfo"
	local	_pkgver="6.5"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "	Configure" "./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-33() {
	local	_pkgname="util-linux"
	local	_pkgver="2.31.1"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "	Configure" "./configure --prefix=/tools --without-python --disable-makeinstall-chown --without-systemdsystemunitdir --without-ncurses PKG_CONFIG=''" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-34() {
	local	_pkgname="xz"
	local	_pkgver="5.2.3"
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "	Configure" "./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-35() {
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build 'strip --strip-debug /tools/lib/*' 'strip --strip-debug /tools/lib/* || true' ${_logfile}
	build '/usr/bin/strip --strip-unneeded /tools/{,s}bin/*' '/usr/bin/strip --strip-unneeded /tools/{,s}bin/* || true' ${_logfile}
	build 'rm -rf /tools/{,share}/{info,man,doc}' 'rm -rf /tools/{,share}/{info,man,doc}' ${_logfile}
	>  ${_complete}
	return 0
}
chapter-05-36() {
    local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	chown -R root:root $LFS/tools" "su -c 'chown -R root:root /mnt/lfs/tools'" ${_logfile}
	>  ${_complete}
	return 0
}
#
#	Add rpm to tool chain
#
chapter-05-zlib() {
	local	_pkgname="zlib"
	local	_pkgver="1.2.11"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "	Configure" "./configure --prefix=/tools" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-nspr() {
	local _pkgname="nspr"
	local _pkgver="4.10.3"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	cd nspr
	sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in  || die "${FUNCNAME}: sed: FAILURE"
	sed -i 's#$(LIBRARY) ##' config/rules.mk  || die "${FUNCNAME}: sed: FAILURE"
	build "	Configure" "PKG_CONFIG_PATH="/tools/lib/pkgconfig" ./configure --prefix=/tools --with-mozilla --with-pthreads $([ "$(uname -m)" = "x86_64" ] && echo --enable-64bit)" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-nss() {
	local _pkgname="nss"
	local _pkgver="3.15.4"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Patch" "patch -Np1 -i ../../SOURCES/nss-3.15.4-standalone-1.patch" ${_logfile}
	cd nss
	build "	Make" "make BUILD_OPT=1 NSPR_INCLUDE_DIR=/tools/include/nspr USE_SYSTEM_ZLIB=1 ZLIB_LIBS=-lz $([ "$(uname -m)" = "x86_64" ] && echo USE_64=1) -j1" ${_logfile}
	cd ../dist
	build "	install -vdm 755 /tools/bin" "install -vdm 755 /tools/bin" ${_logfile}
	build "	install -vdm 755 /tools/lib/pkgconfig" "install -vdm 755 /tools/lib/pkgconfig" ${_logfile}
	build "	install -vdm 755 /tools/include" "install -vdm 755 /tools/include" ${_logfile}
	build "	install -v -m755 Linux*/lib/*.so /tools/lib" "install -v -m755 Linux*/lib/*.so /tools/lib" ${_logfile}
	build "	install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /tools/lib" "install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /tools/lib" ${_logfile}
	build "	cp -v -RL {public,private}/nss/* /tools/include" "cp -v -RL {public,private}/nss/* /tools/include" ${_logfile}
	build "	install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /tools/bin" "install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /tools/bin" ${_logfile}
	build "	install -v -m644 Linux*/lib/pkgconfig/nss.pc  /tools/lib/pkgconfig" "install -v -m644 Linux*/lib/pkgconfig/nss.pc  /tools/lib/pkgconfig" ${_logfile}
	build "	sed -i 's|usr|tools|' /tools/lib/pkgconfig/nss.pc" "sed -i 's|usr|tools|' /tools/lib/pkgconfig/nss.pc" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-popt() {
	local _pkgname="popt"
	local _pkgver="1.16"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}	
	build "	Configure" "./configure --prefix=/tools --disable-static" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-readline() {
	local _pkgname="readline"
	local _pkgver="6.2"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	sed -i '/MV.*old/d' Makefile.in" "sed -i '/MV.*old/d' Makefile.in" ${_logfile}
	build "	sed -i '/{OLDSUFF}/c:' support/shlib-install" "sed -i '/{OLDSUFF}/c:' support/shlib-install" ${_logfile}
	build "	Patch" "patch -Np1 -i ../../SOURCES/readline-6.2-fixes-2.patch" ${_logfile}
	build "	Configure" "PKG_CONFIG_PATH='/tools/lib/pkgconfig' ./configure --prefix=/tools --libdir=/tools/lib --with-curses=/tools/lib" ${_logfile}
	build "	Make" "make ${MKFLAGS} SHLIB_LIBS=-lncursesw" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-elfutils() {
	local _pkgname="elfutils"
	local _pkgver="0.158"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	build "	Configure" 'PKG_CONFIG_PATH="/tools/lib/pkgconfig" ./configure --prefix=/tools --program-prefix="eu-" --with-bzlib=no' ${_logfile}
	build "	Make" "make ${MKFLAGS} SHLIB_LIBS=-lncursesw CFLAGS='-Wno-all -Wno-format-truncation -Wno-implicit-fallthrough -Wno-misleading-indentation'" ${_logfile}
	build "	Install" "make install CFLAGS='-Wno-implicit-fallthrough'" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
chapter-05-rpm() {
	local _pkgname="rpm"
	local _pkgver="4.11.2"
      	local	_complete="${PWD}/LOGS/${FUNCNAME}.completed"
	local	_logfile="${PWD}/LOGS/${FUNCNAME}.log"
	[ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${_pkgname}: Building"
	> ${_logfile}
	build "	Clean build directory" 'rm -rf BUILD/*' ${_logfile}
	build "	Change directory: BUILD" "pushd BUILD" ${_logfile}
	unpack "${PWD}" "${_pkgname}-${_pkgver}"
	build "	Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
	unpack "${PWD}" "db-6.0.20"
	build "	ln -vs db-6.0.20 db" "ln -vs db-6.0.20 db" ${_logfile}
	build "	Configure" "PKG_CONFIG_PATH=/tools/lib/pkgconfig CPPFLAGS='-I/tools/include -I/tools/include/nspr' ./configure --prefix=/tools --disable-static --disable-dependency-tracking --without-lua" ${_logfile}
	build "	Make" "make ${MKFLAGS}" ${_logfile}
	build "	Install" "make install" ${_logfile}
	build "	install -dm 755 /tools/etc/rpm" "install -dm 755 /tools/etc/rpm" ${_logfile}
	build "	rm -v/tools/bin/{rpmquery,rpmverify}" "rm -v /tools/bin/{rpmquery,rpmverify}" ${_logfile}
	build "	ln -vsf rpm /tools/bin/rpmquery" "ln -vsf rpm /tools/bin/rpmquery" ${_logfile}
	build "	ln -vsf rpm /tools/bin/rpmverify" "ln -vsf rpm /tools/bin/rpmverify" ${_logfile}
	build "	install -vm 755 ${LFS}${PARENT}/macros /tools/etc/rpm" "install -vm 755 ${LFS}${PARENT}/macros /tools/etc/rpm" ${_logfile}
	build "	Restore directory" "popd " /dev/null
	build "	Restore directory" "popd " /dev/null
	>  ${_complete}
	return 0
}
#
#	Main line	
#
#msg "Building Chapter 5 Tool chain"
[ "${LFS_USER}" != $(whoami) ] && die "Not lfs user: FAILURE"
[ -z "${LFS_TGT}" ]  && die "Environment not set: FAILURE"
[ ${PATH} = "/tools/bin:/bin:/usr/bin" ] || die "Path not set: FAILURE"
[ "${LFS}${PARENT}" = $(pwd) ] && build "Changing to ${LFS}${PARENT}" "cd ${LFS}${PARENT}" "${LOGDIR}/toolchain.log"
chapter-05-04	#	5.4.  Binutils-2.29 - Pass 1
chapter-05-05	#	5.5.  GCC-7.2.0 - Pass 1
chapter-05-06	#	5.6.  Linux-3.13.3 API Headers
chapter-05-07	#	5.7.  Glibc-2.19
chapter-05-08	#	5.8.  Libstdc++-4.8.2
chapter-05-09	#	5.9.  Binutils-2.24 - Pass 2
chapter-05-10	#	5.10. GCC-4.8.2 - Pass 2
chapter-05-11	#	5.11. Tcl-8.6.1
chapter-05-12	#	5.12. Expect-5.45
chapter-05-13	#	5.13. DejaGNU-1.5.1
chapter-05-14	#	5.14. Check-0.9.12
chapter-05-15	#	5.15. Ncurses-5.9
chapter-05-16	#	5.16. Bash-4.2
chapter-05-17	#	5.17. Bzip2-1.0.6
chapter-05-18	#	5.18. Coreutils-8.22
chapter-05-19	#	5.19. Diffutils-3.3
chapter-05-20	#	5.20. File-5.17
chapter-05-21	#	5.21. Findutils-4.4.2
chapter-05-22	#	5.22. Gawk-4.1.0
chapter-05-23	#	5.23. Gettext-0.18.3.2
chapter-05-24	#	5.24. Grep-2.16
chapter-05-25	#	5.25. Gzip-1.6
chapter-05-26	#	5.26. M4-1.4.17
chapter-05-27	#	5.27. Make-4.0
chapter-05-28	#	5.28. Patch-2.7.1
chapter-05-29	#	5.29. Perl-5.18.2
chapter-05-30	#	5.30. Sed-4.2.2 
chapter-05-31	#	5.31. Tar-1.27.1
chapter-05-32	#	5.32. Texinfo-5.2
chapter-05-33	#	5.33. Util-linux-2.24.1
chapter-05-34	#	5.34. Xz-5.0.5
#	The following packages comprise the package management system RPM
chapter-05-zlib		#
chapter-05-nspr		#
chapter-05-nss		#
chapter-05-popt		#
chapter-05-readline	#
chapter-05-elfutils	#
chapter-05-rpm		#
#	The following are not used
#chapter-05-35	#	5.35. Stripping
#chapter-05-36	#	5.36. Changing Ownership
touch "$LOGDIR/toolchain.completed"
exit 0
