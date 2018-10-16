#!/bin/bash
#-----------------------------------------------------------------------------
#	Title: configure.sh
#	Date: 2018-10-16
#	Version: 1.0
#	Author: baho-utot@columbus.rr.com
#	Options:
#-----------------------------------------------------------------------------
PRGNAME=${0##*/}		# script name minus the path
TOPDIR=${PWD}			# parent directory
PARENT=/usr/src/LFS-RPM	# rpm build directory
MOUNTPOINT=/mnt		# mount point for root filesystem installation
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
	printf "${_green}%s${_normal}\n" "Run Complete - ${rpm_name}"
	return
}
#
#-----------------------------------------------------------------------------
#	Main line

if [ ! /usr/bin/mountpoint $MOUNTPOINT} > /dev/null 2>&1 ]; then die "Hey ${MOUNTPOINT} is not mounted"; fi
msg "	Edit Configuration:"
/sbin/ldconfig
_list="/etc/sysconfig/clock "
_list+="/etc/passwd "
_list+="/etc/hosts "
_list+="/etc/hostname "
_list+="/etc/fstab "
_list+="/etc/sysconfig/ifconfig.eth0 "
_list+="/etc/resolv.conf "
_list+="/etc/lsb-release "
_list+="/etc/sysconfig/rc.site"
for i in ${_list}; do vim "${i}"; done
msg_success
