#!/bin/bash
set -o errexit	# exit if error...insurance ;)
set -o nounset	# exit if variable not initalized
set +h			# disable hashall
#-----------------------------------------------------------------------------
#	Title: builder.sh
#	Date: 2018-04-04
#	Version: 1.0
#	Author: baho-utot@columbus.rr.com
#	Options:
#-----------------------------------------------------------------------------
#	Master variables
PRGNAME=${0##*/}			# script name minus the path
TOPDIR=${PWD}				# parent directory
PARENT=/usr/src/LFS-RPM		# rpm build directory
LOGS=LOGS				# build logs directory
INFOS=INFO				# rpm info log directory
SPECS=SPECS				# rpm spec file directory
PROVIDES=PROVIDES			# rpm provides log directory
REQUIRES=REQUIRES			# rpm requires log directory
RPMS=RPMS				# rpm binary package directory
LOGPATH=${TOPDIR}/LOGS		# path to log directory
#-----------------------------------------------------------------------------
#	GLOBALS
RPM_NAME=""
RPM_VERSION=""
RPM_RELEASE=""
RPM_REQUIRES=""
RPM_SPEC=""
RPM_INSTALLED=""
RPM_ARCH=""
RPM_BINARY=""
RPM_PACKAGE=""
RPM_EXISTS=""
RPM_TARBALLS=""
RPM_MD5SUMS=""
#-----------------------------------------------------------------------------
#	Common support functions
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
end_run() {
	local _green="\\033[1;32m"
	local _normal="\\033[0;39m"
	printf "${_green}%s${_normal}\n" "Run Complete - ${RPM_NAME}"
	return
}
#-----------------------------------------------------------------------------
#	Functions
_rpm_params() {
	local i=""
	RPM_ARCH=$(uname -m)
	if [ -e ${RPM_SPEC} ]; then
		while  read i; do
			i=$(echo ${i} | tr -d '[:cntrl:][:space:]')
			case ${i} in
				Name:*)		RPM_NAME=${i##Name:}				;;
				Version:*)		RPM_VERSION=${i##Version:}			;;
				Release:*)		RPM_RELEASE=${i##Release:}			;;
				Requires:*)		RPM_REQUIRES+="${i##Requires:} "		;;
				?TARBALL:*)		RPM_TARBALLS+="${i##?TARBALL:} "		;;
				?MD5SUM:*)		RPM_MD5SUMS+="${i##?MD5SUM:} "		;;
				*)									;;
			esac
		done < ${RPM_SPEC}
		#	remove trailing whitespace
		RPM_REQUIRES=${RPM_REQUIRES## }
		RPM_TARBALLS=${RPM_TARBALLS## }
		RPM_MD5SUMS=${RPM_MD5SUMS## }
	else
		die "ERROR: ${RPM_SPEC}: does not exist"
	fi
	RPM_BINARY="${RPM_NAME}-${RPM_VERSION}-${RPM_RELEASE}.${RPM_ARCH}.rpm"
	RPM_PACKAGE=${RPM_BINARY%.*}
	_rpm_status
	_rpm_exists
	return
}
_rpm_build() {
	local i=""
	local _log="${LOGS}/${RPM_NAME}"
	> ${_log}
	> ${INFOS}/${RPM_NAME}
	> ${PROVIDES}/${RPM_NAME}
	> ${REQUIRES}/${RPM_NAME}
	printf "%s\n" "Status for ${RPM_BINARY}"
	msg "Spec-------->	${RPM_SPEC}"
	msg "Name-------->	${RPM_NAME}"
	msg "Version----->	${RPM_VERSION}"
	msg "Release----->	${RPM_RELEASE}"
	msg "Arch-------->	${RPM_ARCH}"
	for i in ${RPM_REQUIRES};do msg "Requires---->	${i}";done
	msg "Package----->	${RPM_PACKAGE}"
	msg "Binary------>	${RPM_BINARY}"
	msg "Exists------>	${RPM_EXISTS}"
	msg "Installed--->	${RPM_INSTALLED}"
	for i in ${RPM_TARBALLS}; do msg "Tarball----->	${i}";done
	for i in ${RPM_MD5SUMS};  do msg "MD5SUM------>	${i}";done
	rm -rf BUILD BUILDROOT
	#
	#	These fixes are for chapter 5 and chapter 6
	#	Due to the way LFS builds the system
	#
	case ${RPM_NAME} in
		"adjust-tool-chain")	_adjust-tool-chain	;;
		"glibc")		_glibc			;;
		"locales")		_locales		;;
		"bc")			_bc			;;
		"cleanup")		_cleanup		;;
		"config")		_config		;;
		"gcc-test")		_gcc-test		;;
		"prepare")		_prepare		;;
		"tools-post")		_tools-post		;;
		*)	;;
	esac
	_rpm_fetch	#	fetch packages
	msg_line "Building: ${RPM_NAME}: "
	rpmbuild -ba ${RPM_SPEC} >> ${_log} 2>&1	 && msg_success || die "ERROR: ${RPM_BINARY}"
	_rpm_exists
	[ "F" == ${RPM_EXISTS} ] && die "ERROR: Binary Missing: ${RPM_BINARY}"
	rpm -qilp		${RPMS}/${RPM_ARCH}/${RPM_BINARY} > ${INFOS}/${RPM_NAME}	2>&1 || true
	rpm -qp --provides	${RPMS}/${RPM_ARCH}/${RPM_BINARY} > ${PROVIDES}/${RPM_NAME}	2>&1 || true
	rpm -qp --requires	${RPMS}/${RPM_ARCH}/${RPM_BINARY} > ${REQUIRES}/${RPM_NAME}	2>&1 || true
	return
}
_rpm_install() {
	local _log="${LOGS}/${RPM_NAME}"
	msg_line "Installing: ${RPM_BINARY}: "
	rpm -Uvh --nodeps "${RPMS}/${RPM_ARCH}/${RPM_BINARY}" >> "${_log}" 2>&1  && msg_success || msg_failure
	return
}
_rpm_exists(){
	[ -e "${RPMS}/${RPM_ARCH}/${RPM_BINARY}" ] && RPM_EXISTS="T" || RPM_EXISTS="F"
	return
}
_rpm_depends() {
	local i=""
	for i in ${RPM_REQUIRES}; do ${TOPDIR}/builder.sh ${i} || die "ERROR: _rpm_depends: ${RPM_SPEC}";done
	return
}
_rpm_status() {
	[ "${RPM_PACKAGE}" == "$(rpm -q "$RPM_PACKAGE")" ] && RPM_INSTALLED="T" || RPM_INSTALLED="F"
	return
}
_rpm_fetch() {
	local i=""
	local filespec=""
	[ -z "${RPM_TARBALLS}" ] && return
	for i in ${RPM_TARBALLS}; do
		filespec=${i##*/}
		if [ ! -e "SOURCES/${filespec}" ]; then
			msg_line "Fetching source tarball: ${i}: "
				wget --no-clobber --no-check-certificate --directory-prefix=SOURCES ${i} > /dev/null 2>&1 || die "Error: wget: ${i}"
#				wget --no-clobber --no-check-certificate --directory-prefix=SOURCES ${i} || die "Error: wget: ${i}"
			msg_success
		fi
	done
	> SOURCES/"MD5SUM"
	for i in ${RPM_MD5SUMS}; do printf "%s\n" "$(echo ${i} | tr ";" " ")" >> SOURCES/"MD5SUM";done
	# do md5sum check
	msg_line "Checking source: "
	md5sum -c SOURCES/"MD5SUM" || msg_failure
	return
}
#-----------------------------------------------------------------------------
#	Chapter 5 fixes
_tools-post() {
	local list="tools-zlib tools-popt tools-openssl tools-libelf tools-rpm"
	#	remove all un-needed files only leaving
	#	what is needed to run rpm
	msg "	Post processing:"
	#	This preserves all the libraries that are needed
	#	and removes evertything else so that only the static built
	#	rpm and its libraries that are needed are left.
	#	Keeps the LFS build clean of external packages.
	#	rpm was placed into /usr/bin and /usr/lib
	#	The chapter 6 rpm files will over write these files
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
	for i in ${list}; do
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
	return
}
#-----------------------------------------------------------------------------
#	Chapter 6 fixes
#-----------------------------------------------------------------------------
_adjust-tool-chain() {		# adjust and test tools chain
	local _log="${LOGS}/${RPM_NAME}"
	mv -v /tools/bin/{ld,ld-old} >> ${_log} 2>&1
	mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old} >> ${_log} 2>&1
	mv -v /tools/bin/{ld-new,ld} >> ${_log} 2>&1
	ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld >> ${_log} 2>&1
	gcc -dumpspecs | sed -e 's@/tools@@g' \
		-e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
		-e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' > \
		`dirname $(gcc --print-libgcc-file-name)`/specs
	msg "Running Check: " >> ${_log} 2>&1
	echo 'int main(){}' > dummy.c
	cc dummy.c -v -Wl,--verbose &> dummy.log
	msg "Output: [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]" >> ${_log} 2>&1
	readelf -l a.out | grep ': /lib' >> ${_log} 2>&1
	echo"" >> ${_log} 2>&1
	msg "Output: /usr/lib/../lib/crt1.o succeeded" >> ${_log} 2>&1
	msg "Output: /usr/lib/../lib/crti.o succeeded" >> ${_log} 2>&1
	msg "Output: /usr/lib/../lib/crtn.o succeeded" >> ${_log} 2>&1
	grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log >> ${_log} 2>&1
	echo"" >> ${_log} 2>&1
	msg "Output: #include <...> search starts here:" >> ${_log} 2>&1
	msg "Output: /usr/include" >> ${_log} 2>&1
	grep -B1 '^ /usr/include' dummy.log >> ${_log} 2>&1
	echo"" >> ${_log} 2>&1
	msg "References to paths that have components with -linux-gnu should be ignored" >> ${_log} 2>&1
	msg "Output: SEARCH_DIR("/usr/lib")" >> ${_log} 2>&1
	msg "Output: SEARCH_DIR("/lib")" >> ${_log} 2>&1
	grep 'SEARCH.*/usr/lib' dummy.log | sed 's|; |\n|g' >> ${_log} 2>&1
	echo"" >> ${_log} 2>&1
	msg "Output: attempt to open /lib/libc.so.6 succeeded" >> ${_log} 2>&1
	grep "/lib.*/libc.so.6 " dummy.log >> ${_log} 2>&1
	echo"" >> ${_log} 2>&1
	msg "Output: found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2" >> ${_log} 2>&1
	grep found dummy.log >> ${_log} 2>&1
	rm -v dummy.c a.out dummy.log >> ${_log} 2>&1
	return
}
_bc() {
	[ -h /usr/lib/libncursesw.so.6 ] || ln -s /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
	[ -h /usr/lib/libncurses.so ] || ln -sf libncurses.so.6 /usr/lib/libncurses.so
	return
}
_cleanup() {
	local list="$(rpm -qa | grep tools)"
	local i=""
	msg "	Cleanup processing:"
	msg_line "	Removing tool chain rpms: "
		for i in ${list};do rpm -e --nodeps ${i} > /dev/null 2>&1 || true;done
	msg_success
	msg_line "	Removing Builder helper rpms: "
		list+="prepare adjust-tool-chain locales gcc-test lfs"
		for i in ${list};do rpm -e --nodeps ${i} > /dev/null 2>&1 || true;done
	msg_success
	msg_line "	Removing /tools directory: "; rm -rf /tools;msg_success
#	msg_line "	Removing lfs user: ";userdel -r lfs;msg_success
	return
}
_config() {
	local i=""
	local list=""
	msg "	Edit Configuration:"
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
		for i in ${list}; do vim "${i}"; done
	msg_success
	return
}
_gcc-test() {
	local _log="${LOGS}/${RPM_NAME}"
	msg "Building: ${RPM_NAME}: "
	echo 'int main(){}' > dummy.c
	cc dummy.c -v -Wl,--verbose &> dummy.log
	msg "Output: [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]" >> ${_log} 2>&1
	readelf -l a.out | grep ': /lib' >> ${_log} 2>&1
	echo"" >> ${_log} 2>&1
	msg "Output: /usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/../../../../lib/crt1.o succeeded" >> ${_log} 2>&1
	msg "Output: /usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/../../../../lib/crti.o succeeded" >> ${_log} 2>&1
	msg "Output: /usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/../../../../lib/crtn.o succeeded" >> ${_log} 2>&1
	grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log >> ${_log} 2>&1
	echo"" >> ${_log} 2>&1
	msg "Output: #include <...> search starts here:" >> ${_log} 2>&1
	msg "Output: /usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/include" >> ${_log} 2>&1
	msg "Output: /usr/local/include" >> ${_log} 2>&1
	msg "Output: /usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/include-fixed" >> ${_log} 2>&1
	msg "Output:  /usr/include" >> ${_log} 2>&1
	grep -B4 '^ /usr/include' dummy.log >> ${_log} 2>&1
	echo"" >> ${_log} 2>&1
	msg "Output: SEARCH_DIR(/usr/x86_64-pc-linux-gnu/lib64)" >> ${_log} 2>&1
	msg "Output: SEARCH_DIR(/usr/local/lib64)" >> ${_log} 2>&1
	msg "Output: SEARCH_DIR(/lib64)" >> ${_log} 2>&1
	msg "Output: SEARCH_DIR(/usr/lib64)" >> ${_log} 2>&1
	msg "Output: SEARCH_DIR(/usr/x86_64-pc-linux-gnu/lib)" >> ${_log} 2>&1
	msg "Output: SEARCH_DIR(/usr/local/lib)" >> ${_log} 2>&1
	msg "Output: SEARCH_DIR(/lib)" >> ${_log} 2>&1
	msg "Output: SEARCH_DIR(/usr/lib);" >> ${_log} 2>&1
	grep 'SEARCH.*/usr/lib' dummy.log | sed 's|; |\n|g' >> ${_log} 2>&1
	echo"" >> ${_log} 2>&1
	msg "Output: attempt to open /lib/libc.so.6 succeeded" >> ${_log} 2>&1
	grep "/lib.*/libc.so.6 " dummy.log >> ${_log} 2>&1
	echo"" >> ${_log} 2>&1
	msg "Output: found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2" >> ${_log} 2>&1
	grep found dummy.log >> ${_log} 2>&1
	echo"" >> ${_log} 2>&1
	rm -v dummy.c a.out dummy.log >> ${_log} 2>&1
	return
}
glibc() {
	[ -e /usr/lib/gcc ]			|| ln -sf /tools/lib/gcc /usr/lib
	[ -e /usr/include/limits.h ]	&& rm -f /usr/include/limits.h
	[ -h /lib64/ld-linux-x86-64.so.2 ]	|| ln -sf ../lib/ld-linux-x86-64.so.2 /lib64
	[ -h /lib64/ld-lsb-x86-64.so.3 ]	|| ln -sf ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
	return
}
_locales() {
	local _log="${LOGS}/${RPM_NAME}"
#	msg "Building: ${RPM_NAME}: "
	/sbin/locale-gen.sh >> ${_log} 2>&1
	return
}
_prepare() {
	msg_line "Installing macros file: "
		cat > /etc/rpm/macros <<- EOF
			#
			#	System settings
			#
			%_topdir		/usr/src/LFS-RPM
			%_prefix		/usr
			%_lib			/lib
			%_libdir		/usr/lib
			%_lib64		/lib64
			%_libdir64		/usr/lib64
			%_var			/var
			%_sharedstatedir	/var/lib
			%_localstatedir	/var
			%_docdir		%{_prefix}/share/doc
			#
			#	Build flags
			#
			#	%%optflags	-march=x86-64 -mtune=generic -O2 -pipe -fPIC -fstack-protector-strong -fno-plt -fpie -pie
			#	%%_ldflags	-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now,--build-id
			%_tmppath	/var/tmp
			%_dbpath	/var/lib/rpm
			#
			#	Do not compress man or info files - breaks file list
			%_build_id_links	none
		EOF
	msg_success
	msg_line "Creating Filesystem: "
		install -vdm 755 /bin /etc /usr/bin /usr/lib
		install -d -m 1777 /tmp /var/tmp
	msg_success
	msg_line "Creating Symlinks: "
		ln -sf /tools/bin/{bash,cat,dd,echo,ln,pwd,rm,stty} /bin
		ln -sf /tools/bin/{install,perl} /usr/bin
		ln -sf /tools/lib/libgcc_s.so{,.1} /usr/lib
		ln -sf /tools/lib/libstdc++.{a,so{,.6}} /usr/lib
		ln -sf bash /bin/sh
		ln -sf /proc/self/mounts /etc/mtab
		ln -sf /tools/bin/getconf /usr/bin/getconf
	msg_success
	return
}
#-----------------------------------------------------------------------------
#	Main line
if [ -z "$1" ]; then
  echo "Usage: builder.sh <filespec.spec>"
  exit -1
fi
#
#	Create directories if needed
#
[ -e "${LOGS}" ]	||	install -vdm 755 "${LOGS}"
[ -e "${INFOS}" ]	||	install -vdm 755 "${INFOS}"
[ -e "${SPECS}" ]	||	install -vdm 755 "${SPECS}"
[ -e "${PROVIDES}" ]	||	install -vdm 755 "${PROVIDES}"
[ -e "${REQUIRES}" ]	||	install -vdm 755 "${REQUIRES}"
[ -e "${RPMS}" ]	||	install -vdm 755 "${RPMS}"
RPM_SPEC=${SPECS}/${1}.spec	#	rpm spec file to build
_rpm_params	#	get parameters/status
_rpm_depends	#	Build dependencies
if [ "F" == "${RPM_EXISTS}" ]; then
	_rpm_build || die " FAILURE: _rpm_build "
fi
if [ "F" == "${RPM_INSTALLED}" ]; then
	###	Modified 2018-08-07
	if [ "tools-gcc-pass-2" == ${RPM_NAME} ]; then
		rpm -e tools-gcc-pass-1 tools-libstdc
	fi
	###
	_rpm_install		#	Install rpm
fi
end_run
