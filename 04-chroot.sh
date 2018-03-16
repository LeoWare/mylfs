#!/tools/bin/bash
#######################################################################
#	Title:	04-chroot.sh							#
#        Date:	2017-01-03						#
#     Version:	1.1							#
#      Author:	baho-utot@columbus.rr.com				#
#     Options:								#
#######################################################################
#set -o errexit	# exit if error...insurance ;)
set -o nounset	# exit if variable not initalized
set +h			# disable hashall
PRGNAME=${0##*/}	# script name minus the path
TOPDIR=${PWD}
LFS=/mnt/lfs
PARENT=/usr/src/Octothorpe
LOGFILE=$(date +%Y-%m-%d).log
LOGFILE=${TOPDIR}/LOGS/${PRGNAME}	# set log file name
#LOGFILE=/dev/null			# uncomment to disable log file
#
#	Standard functions
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
#
#	Main line function
#
_virtual() {	#	6.2. Preparing Virtual Kernel File Systems
	[ -d ${LFS}/dev ]         || mkdir -p ${LFS}/dev 
	[ -d ${LFS}/proc ]        || mkdir -p ${LFS}/proc 
	[ -d ${LFS}/sys ]         || mkdir -p ${LFS}/sys 
	[ -d ${LFS}/run ]         || mkdir -p ${LFS}/run 
	[ -e ${LFS}/dev/console ] || mknod -m 600 ${LFS}/dev/console c 5 1
	[ -e ${LFS}/dev/null ]    || mknod -m 666 ${LFS}/dev/null c 1 3
	return
}
_umount(){
	mountpoint -q ${LFS}/run && umount ${LFS}/run
	mountpoint -q ${LFS}/sys && umount ${LFS}/sys
	mountpoint -q ${LFS}/proc && umount ${LFS}/proc
	mountpoint -q ${LFS}/dev/pts && umount ${LFS}/dev/pts
	mountpoint -q ${LFS}/dev && umount ${LFS}/dev
	return
}
_mount() {
	mountpoint -q ${LFS}/dev || mount --bind /dev ${LFS}/dev
	mountpoint -q ${LFS}/dev/pts || mount -t devpts devpts ${LFS}/dev/pts -o gid=5,mode=620
	mountpoint -q ${LFS}/proc || mount -t proc proc ${LFS}/proc
	mountpoint -q ${LFS}/sys || mount -t sysfs sysfs ${LFS}/sys
	mountpoint -q ${LFS}/run || mount -t tmpfs tmpfs ${LFS}/run
	[ -h ${LFS}/dev/shm ] && mkdir -p ${LFS}/$(readlink ${LFS}/dev/shm)
	return
}
_chroot() {
	chroot "$LFS" /tools/bin/env -i \
		HOME=/root \
		TERM="$TERM" \
		PS1='\u:\w\$ ' \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
		/tools/bin/bash --login +h
	return
}
#
#	Main line	
#
[ ${EUID} -eq 0 ] 	|| die "${PRGNAME}: Need to be root user: FAILURE"
LIST+="_virtual _umount _mount _chroot"
for i in ${LIST};do 
	${i}
done
