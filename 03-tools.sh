#!/bin/bash
#################################################
#	Title:	03-tools.sh			#
#        Date:	2017-12-12			#
#     Version:	1.1				#
#      Author:	baho-utot@columbus.rr.com	#
#     Options:					#
#################################################
set -o errexit		# exit if error...insurance ;)
set -o nounset		# exit if variable not initalized
set +h			# disable hashall
PRGNAME=${0##*/}	# script name minus the path
TOPDIR=${PWD}		# script lives here
#		Build variables
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
#
PARENT=/usr/src/Octothorpe
LOGPATH=${TOPDIR}/LOGS/TOOLS
INFOPATH=${TOPDIR}/INFO/TOOLS
SPECPATH=${TOPDIR}/SPECS/TOOLS
PROVIDESPATH=${TOPDIR}/PROVIDES/TOOLS
REQUIRESPATH=${TOPDIR}/REQUIRES/TOOLS
RPMPATH=${TOPDIR}/RPMS
#
#	Build functions
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
end-run() {
	local _green="\\033[1;32m"
	local _normal="\\033[0;39m"
	printf "${_green}%s${_normal}\n" "Run Complete"
	return
}
maker(){
	local _name=${1}
	local _log="${LOGPATH}/${_name}"
	local _pkg=$(find ${RPMPATH} -name "tools-${_name}-[0-9]*.rpm" -print 2>/dev/null)
	local _filespec=${SPECPATH}/tools-${_name}.spec
	#
	#	Build
	#
	msg_line "	Building: ${_name}: "
	if [ -z ${_pkg} ]; then
		rm ${_log}.installed > ${_log} 2>&1	|| true
		rm ${INFOPATH}/${_name} > ${_log} 2>&1	|| true
		rpmbuild -ba ${_filespec} >> ${_log} 2>&1 && msg_success || msg_failure
		_pkg=$(find ${RPMPATH} -name "tools-${_name}-[0-9]*.rpm" -print)
	else
		msg "Skipped"
		return
	fi
	return
}
info(){		#	$1:	Name of package
	local _log="${LOGPATH}/${1}"
	local _pkg=$(find ${RPMPATH} -name "tools-${1}-[0-9]*.rpm" -print 2>/dev/null)
	#
	#	Info
	#
	msg_line "	Info: ${1}: "
	[ -z ${_pkg} ] && die "ERROR: rpm package not found"
	if [ ! -e ${INFOPATH}/${1} ]; then
		rpm -qilp ${_pkg} > ${INFOPATH}/${1} 2>&1 || true
		rpm -qp --provides ${_pkg} > ${PROVIDESPATH}/${1} 2>&1 || true
		rpm -qp --requires ${_pkg} > ${REQUIRESPATH}/${1} 2>&1 || true
		msg_success
	else
		 msg "Skipped"
	fi
}
installer(){	#	$1:	name of package
	local _log="${LOGPATH}/${1}"
	local _pkg=$(find ${RPMPATH} -name "tools-${1}-[0-9]*.rpm" -print 2>/dev/null)
	#
	#	Install
	#
	msg_line "	Installing: ${1}: "
	if [ ! -e ${_log}.installed ]; then
		rpm -Uvh --nodeps ${_pkg} >> "${_log}" 2>&1  && msg_success || msg_failure
		mv ${_log} ${_log}.installed
	else
		msg "Skipped"
	fi
	return
}
_prepare() {
	local _log="${LOGPATH}/${1}"
	[ -e "${LOGPATH}/${1}" ] && return
	msg_line "	Installing macros file: " 
	cat > /home/lfs/.rpmmacros <<- EOF
		#
		#	System settings
		#
		%_lfs			/mnt/lfs
		%_lfs_tgt		x86_64-lfs-linux-gnu
		%_topdir		%{_lfs}/usr/src/Octothorpe
		%_dbpath		%{_lfs}/var/lib/rpm
		%_prefix		/tools
		%_docdir		%{_prefix}/share/doc
		%_lib			%{_prefix}/lib
		%_bindir		%{_prefix}/bin
		%_libdir		%{_prefix}/lib
		%_lib64			%{_prefix}/lib64
		%_var			%{_prefix}/var
		%_sharedstatedir	%{_prefix}/var/lib
		%_localstatedir		%{_prefix}/var
		%_tmppath		%{_prefix}/var/tmp
	EOF
	msg_line "	Creating rpm database path: "
		install -dm 755 ${LFS}/var/lib/rpm
	msg_success
	touch ${_log}
	msg_success
	return
}
_glibc() {
	local _log="${LOGPATH}/${1}.test"
	maker ${1}
	info  ${1}
	installer ${1}
	#
	#	Tests
	#
	if [ ! -e ${_log} ]; then
		msg_line "	Running Check: "
		echo 'int main(){}' > dummy.c
		$LFS_TGT-gcc dummy.c >> ${_log} 2>&1
		readelf -l a.out | grep ': /tools' >> ${_log} 2>&1
		msg "Output: [Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]" >> ${_log} 2>&1
		rm dummy.c a.out || true
		msg_success
	fi
	return
}
_gcc-pass-2() {
	local _log="${LOGPATH}/${1}"
	local _pkg=""
	maker ${1}	
	info  ${1}
	#
	#	Install
	#
	msg_line "	Installing: ${1}: "
	if [ ! -e ${_log}.installed ]; then
		_pkg=$(find ${RPMPATH} -name "tools-${1}-[0-9]*.rpm" -print)
		rpm -Uvh --force --nodeps \
			${_pkg} >> "${_log}" 2>&1  && msg_success || msg_failure
		mv ${_log} ${_log}.installed
	else
		msg "Skipped"
		return
	fi
	#
	#	Tests
	#
	_log="${LOGPATH}/${1}.test"
	if [ ! -e ${_log} ]; then
		msg_line "	Running Check: "
		echo 'int main(){}' > dummy.c
		$LFS_TGT-gcc dummy.c >> ${_log} 2>&1
		readelf -l a.out | grep ': /tools' >> ${_log} 2>&1
		msg "Output: [Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]" >> ${_log} 2>&1
		rm dummy.c a.out || true
		msg_success
	fi
	return
}
_stripping() {
	local _log="${LOGPATH}/${1}"
	if [ ! -e ${_log} ]; then
		msg "	 Stripping: ${1}"
		msg_line "	Strip libs: "
		strip --strip-debug /tools/lib/* > ${_log} 2>&1 || true
		msg_success
		msg_line "	Strip exes: "
		/usr/bin/strip --strip-unneeded /tools/{,s}bin/* >> ${_log} 2>&1 || true
		msg_success
		msg_line "	Remove documentation: "
		rm -rf /tools/{,share}/{info,man,doc} true >> ${_log} 2>&1
		msg_success
	else
		msg "	 Skipping: ${1}"
	fi
	return
}
_chown() {
	local _log="${LOGPATH}/${1}"
	if [ ! -e ${_log} ]; then
		msg_line "	Changing ownership: " 
		su -c 'chown -vR root:root /mnt/lfs/tools' - >> ${_log} 2>&1 || true
		touch ${LOGPATH}/tool-chain-complete
		msg_success
	fi
	return
}
_post() {
	local i=""
	local LIST=""
	local _package=""
	msg "	Post processing:"
	#	This preserves all the libraries that are needed 
	#	and removees evertything else so that only the static built
	#	rpm and its libraries that are needed are left.
	#	Keeps the LFS build clean of external packages.
	#	rpm was placed into /usr/bin and /usr/lib
	#	The chapter 6 iles will over write these files
	if [ ! -e ${LOGPATH}/${1} ]; then
		local LIST="tools-zlib tools-popt tools-openssl tools-libelf tools-rpm"
		local i=""
		local _package=""
		rm -rf ${TOPDIR}/BUILDROOT/* || true
		msg_line "	Saving libraries: " 
		install -dm 755 ${TOPDIR}/BUILDROOT/tools/lib
		cp -a /tools/lib/libelf-0.170.so ${TOPDIR}/BUILDROOT/tools/lib
		cp -a /tools/lib/libelf.so ${TOPDIR}/BUILDROOT/tools/lib
		cp -a /tools/lib/libelf.so.1 ${TOPDIR}/BUILDROOT/tools/lib
		#	Saving rpm
		install -dm 755 ${TOPDIR}/BUILDROOT/mnt/lfs/usr/bin
		install -dm 755 ${TOPDIR}/BUILDROOT/mnt/lfs/usr/lib
		cp -ar /mnt/lfs/usr/bin/* ${TOPDIR}/BUILDROOT/mnt/lfs/usr/bin
		cp -ar /mnt/lfs/usr/lib/* ${TOPDIR}/BUILDROOT/mnt/lfs/usr/lib
		msg_success
		for i in ${LIST}; do
			msg_line "	Removing: ${i}: "
			rpm -e --nodeps ${i} > /dev/null 2>&1 || true
			msg_success
		done
		msg_line "	Moving libraries: " 
		mv ${TOPDIR}/BUILDROOT/tools/lib/* /tools/lib
		install -dm 755 /mnt/lfs/usr/bin
		install -dm 755 /mnt/lfs/usr/lib
		cp -ar ${TOPDIR}/BUILDROOT/mnt/lfs/usr/bin/* /mnt/lfs/usr/bin
		cp -ar ${TOPDIR}/BUILDROOT/mnt/lfs/usr/lib/* /mnt/lfs/usr/lib
		msg_success
		msg_line "	Creating directories: " 
		install -dm 755 ${LFS}/var/tmp
		chmod 1777 ${LFS}/var/tmp
		install -dm 755 ${LFS}/etc/rpm
		install -dm 755 ${LFS}/bin
		ln -s /tools/bin/bash ${LFS}/bin
		ln -s /tools/bin/sh ${LFS}/bin
		msg_success
		touch ${LOGPATH}/${1}
	else
		msg "	Post processing: Skipping"
	fi
	return
}
#
#	Main line	
#
[ "lfs" != $(whoami) ]				&& die  "	Not lfs user: FAILURE"
[ -z "${LFS_TGT}" ]				&& die "	Environment not set: FAILURE"
[ ${PATH} = "/tools/bin:/bin:/usr/bin" ]	|| die "	Path not set: FAILURE"
[ -z ${PARENT} ]				&& die "	Variable: PARENT not set: FAILURE"
[ -z ${LFS} ]					&& die "	Variable: LFS not set: FAILURE"
[ -d ${LOGPATH} ]	|| die "	Path: ${LOGPATH} not existent: FAILURE"
[ -d ${INFOPATH} ]	|| die "	Path: ${INFOPATH} not existent: FAILURE"
[ -d ${SPECPATH} ]	|| die "	Path: ${SPECPATH} not existent: FAILURE"
[ -d ${PROVIDESPATH} ]	|| die "	Path: ${PROVIDESPATH} not existent: FAILURE"
[ -d ${REQUIRESPATH} ]	|| die "	Path: ${REQUIRESPATH} not existent: FAILURE"
#
#	LFS tool chain
#
msg "Building Chapter 5 Tool chain"
LIST+="prepare "		#    At the ready
LIST+="binutils-pass-1 "	#    Binutils-2.30 - Pass 1
LIST+="gcc-pass-1 "		#    GCC-7.3.0 - Pass 1
LIST+="linux-api-headers "	#    Linux-4.15.3 API Headers
LIST+="glibc "			#    Glibc-2.27
LIST+="libstdc "		#    Libstdc++-7.3.0
LIST+="binutils-pass-2 "	#    Binutils-2.30 - Pass 2
LIST+="gcc-pass-2 "		#    GCC-7.3.0 - Pass 2
LIST+="tcl-core "		#    Tcl-core-8.6.8
LIST+="expect "			#    Expect-5.45.4
LIST+="dejagnu "		#    DejaGNU-1.6.1
LIST+="m4 "			#    M4-1.4.18
LIST+="ncurses "		#    Ncurses-6.1
LIST+="bash "			#    Bash-4.4.18
LIST+="bison "			#    Bison-3.0.4
LIST+="bzip2 "			#    Bzip2-1.0.6
LIST+="coreutils "		#    Coreutils-8.29
LIST+="diffutils "		#    Diffutils-3.6
LIST+="file "			#    File-5.32
LIST+="findutils "		#    Findutils-4.6.0
LIST+="gawk "			#    Gawk-4.2.0
LIST+="gettext "		#    Gettext-0.19.8.1
LIST+="grep "			#    Grep-3.1
LIST+="gzip "			#    Gzip-1.9
LIST+="make "			#    Make-4.2.1
LIST+="patch "			#    Patch-2.7.6
LIST+="perl "			#    Perl-5.26.1
LIST+="sed "			#    Sed-4.4
LIST+="tar "			#    Tar-1.30
LIST+="texinfo "		#    Texinfo-6.5
LIST+="util-linux "		#    Util-linux-2.31.1
LIST+="xz "			#    Xz-5.2.3
#	package manager
#LIST+="zlib libelf openssl popt rpm post "
for i in ${LIST};do
	rm -rf BUILD BUILDROOT
	case ${i} in
		prepare)	_prepare ${i}		;;
		glibc)		_glibc ${i}		;;
		gcc-pass-2)	_gcc-pass-2 ${i}	;;
		stripping)	_stripping ${i}		;;
		chown)		_chown ${i}		;;
		post)		_post ${i}		;;
		*)		maker ${i}	
				info  ${i}
				installer ${i}		;;
	esac
done
end-run