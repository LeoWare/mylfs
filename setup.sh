#!/bin/bash
#-----------------------------------------------------------------------------
#	Title: 01-setup.sh
#	Date: 2018-03-21
#	Version: 1.3
#	Author: baho-utot@columbus.rr.com
#	Options:
#-----------------------------------------------------------------------------
set -o errexit	# exit if error...insurance ;)
set -o nounset	# exit if variable not initalized
set +h			# disable hashall
PRGNAME=${0##*/}	# script name minus the path
TOPDIR=${PWD}
LFS=/mnt/lfs
PARENT=/usr/src/LFS-RPM
LOGFILE=$(date +%Y-%m-%d).log
TARBALL=""
MD5SUM=""
#-----------------------------------------------------------------------------
#	Common support functions
die() {
	local _red="\\033[1;31m"
	local _normal="\\033[0;39m"
	[ -n "$*" ] && printf "${_red}$*${_normal}\n"
	/bin/false
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
#-----------------------------------------------------------------------------
#	Functions
_setup_directories() {
	#	Setup base directories
	msg_line "	Creating base directories: "
		[ -d ${LFS} ]		&& /bin/rm -rf ${LFS}/*
		[ -d ${LFS} ]		|| /usr/bin/install -dm 755 ${LFS}
		[ -d ${LFS}/tools ]	|| /usr/bin/install -dm 755 ${LFS}/tools
		[ -h /tools ]		|| /bin/ln -vs ${LFS}/tools /
	msg_success
	return
}
_copy_source() {
	#	Copy build system to $LFS
	#	Directories to copy
	msg_line "	Installing build system: "
		/usr/bin/install -dm 777 ${LFS}/${PARENT}
		/usr/bin/install -dm 777 ${LFS}/${PARENT}/INFO
		/usr/bin/install -dm 777 ${LFS}/${PARENT}/LOGS
		/usr/bin/install -dm 777 ${LFS}/${PARENT}/PROVIDES
		/usr/bin/install -dm 777 ${LFS}/${PARENT}/REQUIRES
		/usr/bin/install -dm 777 ${LFS}/${PARENT}/SOURCES
		/bin/cp -ar BOOK	${LFS}${PARENT}
		/bin/cp -ar SOURCES	${LFS}${PARENT}
		/bin/cp -ar SPECS	${LFS}${PARENT}
		/bin/cp -ar README	${LFS}${PARENT}
		/bin/cp -ar *.sh	${LFS}${PARENT}
		/bin/chmod 777 ${LFS}${PARENT}/*.sh
	msg_success
	return
}
_setup_user() {
	#	Create lfs user
	msg_line "	Creating lfs user: "
		/usr/bin/getent group  lfs > /dev/null 2>&1 || /usr/sbin/groupadd lfs
		/usr/bin/getent passwd lfs > /dev/null 2>&1 || /usr/sbin/useradd  -c 'LFS user' -g lfs -m -k /dev/null -s /bin/bash lfs
		/usr/bin/getent passwd lfs > /dev/null 2>&1 && passwd --delete lfs > /dev/null 2>&1
		[ -d /home/lfs ] || install -dm 755 /home/lfs
		/bin/cat > /home/lfs/.bash_profile <<- EOF
			exec /usr/bin/env -i HOME=/home/lfs TERM=${TERM} PS1='\u:\w\$ ' /bin/bash
		EOF
		/bin/cat > /home/lfs/.bashrc <<- EOF
			set +h
			umask 022
			LFS=/mnt/lfs
			LC_ALL=POSIX
			LFS_TGT=$(uname -m)-lfs-linux-gnu
			PATH=/tools/bin:/bin:/usr/bin
			export LFS LC_ALL LFS_TGT PATH
		EOF
		/bin/cat > /home/lfs/.rpmmacros <<- EOF
			#
			#	System settings
			#
			%_lfsdir		/mnt/lfs
			%_lfs_tgt		x86_64-lfs-linux-gnu
			%_topdir		%{_lfsdir}/usr/src/LFS-RPM
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
		echo "%LFS_TGT			$(/bin/uname -m)-lfs-linux-gnu" >> /home/lfs/.rpmmacros
		[ -d ${LFS} ]				|| /usr/bin/install -dm 755 ${LFS}
		[ -d ${LFS}/tools ]			|| /usr/bin/install -dm 755 ${LFS}/tools
		[ -h /tools ]				|| ln -s ${LFS}/tools /
		/bin/chown -R lfs:lfs /home/lfs	|| die "${FUNCNAME}: FAILURE"
		/bin/chown -R lfs:lfs ${LFS}	|| die "${FUNCNAME}: FAILURE"
	msg_success
	return
}
_fetch () {
	local i=""
	local filespec=""
	[ -z "${TARBALL}" ] && return
	for i in ${TARBALL}; do
		filespec=${i##*/}
		if [ ! -e "SOURCES/${filespec}" ]; then
			msg_line "Fetching source tarball: ${i}: "
				wget --no-clobber --no-check-certificate --directory-prefix=SOURCES ${i} > /dev/null 2>&1 || die "Error: wget: ${i}"
#				wget --no-clobber --no-check-certificate --directory-prefix=SOURCES ${i} || die "Error: wget: ${i}"
			msg_success
		fi
	done
	> SOURCES/"MD5SUM"
	for i in ${MD5SUM}; do printf "%s\n" "$(echo ${i} | tr ";" " ")" >> SOURCES/"MD5SUM";done
	# do md5sum check
	msg "Checking source: "
	md5sum -c SOURCES/"MD5SUM" || msg_failure
	return
}
_get_list() {
	local i=""
	local rpm_spec=${1}
	if [ -e ${rpm_spec} ]; then
		while  read i; do
			i=$(echo ${i} | tr -d '[:cntrl:][:space:]')
			case ${i} in
				?TARBALL:*)	TARBALL+="${i##?TARBALL:} "	;;
				?MD5SUM:*)	MD5SUM+="${i##?MD5SUM:} "	;;
				*)						;;
			esac
		done < ${rpm_spec}
		#	remove trailing whitespace
		TARBALL=${TARBALL## }
		MD5SUM=${MD5SUM## }
	else
		die "ERROR: ${rpm_spec}: does not exist"
	fi
	return
}
_get_source() {
	local i=""
	pushd "${LFS}${PARENT}"
		for i in SPECS/*.spec; do
			TARBALL=""
			MD5SUM=""
			msg "Getting source: [${i}]"
			_get_list "${i}"
			msg "Source list:	[${TARBALL}]"
			msg "Source md5sum:	[${MD5SUM}]"
			_fetch
		done
	popd
	return
}
#-----------------------------------------------------------------------------
#	Main line
[ ${EUID} -eq 0 ]		|| { /bin/echo "${PRGNAME}: Need to be root user";exit 1; }
[ -x /usr/bin/getent ]	|| { /usr/bin/echo "${PRGNAME}: getent: missing: can not continue";exit 1; }
mountpoint -q ${LFS}		|| die "Hey ${LFS} is not mounted"
LIST="_setup_directories _copy_source _get_source _setup_user"
for i in ${LIST};do ${i};done
end-run
