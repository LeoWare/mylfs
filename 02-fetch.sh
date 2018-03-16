#!/bin/bash
##################################################
#	Title:	2-fetch.sh				#
#        Date:	2017-11-22			#
#     Version:	1.1				#
#      Author:	baho-utot@columbus.rr.com	#
#     Options:					#
##################################################
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
_fetch_source() {
	#	Fetch source packages
	local DESTDIR=""
	local INPUTFILE=""
	msg_line "	Fetching source: "
		[ -d SOURCES ] || install -vdm 755 ${DESTDIR}
		#	LFS sources
		DESTDIR=${TOPDIR}/SOURCES
		INPUTFILE=${TOPDIR}/SOURCES/wget-list
		wget --no-clobber --no-check-certificate --input-file=${INPUTFILE} --directory-prefix=${DESTDIR}
		md5sum -c SOURCES/md5sum-list
	msg_success
	return
}
#
#	Main line
#
[ ${EUID} -eq 0 ]		&& { echo "${PRGNAME}: Need to be lfs user";exit 1; }
[ -z ${LFS} ]			&& { echo "${PRGNAME}: LFS: not set";exit 1; }
[ -z ${PARENT} ]		&& { echo "${PRGNAME}: PARENT: not set";exit 1; }
[ -z ${LOGFILE} ]		&& { echo "${PRGNAME}: LOGFILE: not set";exit 1; }
[ -x /usr/bin/getent ]		|| { echo "${PRGNAME}: getent: missing: can not continue";exit 1; }
_fetch_source			#	Fetch source packages
end-run
