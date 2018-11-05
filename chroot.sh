#!/tools/bin/bash
#-----------------------------------------------------------------------------
#	Title: chroot.sh
#	Date: 2017-01-03
#	Version: 1.1
#	Author: baho-utot@columbus.rr.com
#	Options:
#-----------------------------------------------------------------------------
#set -o errexit	# exit if error...insurance ;)
set -o nounset	# exit if variable not initalized
set +h			# disable hashall
PRGNAME=${0##*/}	# script name minus the path
TOPDIR=${PWD}
LFS=/mnt/lfs
PARENT=/usr/src/LFS-RPM
LOGFILE=$(date +%Y-%m-%d).log
LOGFILE=${TOPDIR}/LOGS/${PRGNAME}
#LOGFILE=/dev/null		# uncomment to disable log file
#-----------------------------------------------------------------------------
#	Standard functions
die() {
	local _red="\\033[1;31m"
	local _normal="\\033[0;39m"
	[ -n "$*" ] && /usr/bin/printf "${_red}$*${_normal}\n"
	exit 1
}
msg() {
	/usr/bin/printf "%s\n" "${1}"
}
msg_line() {
	/usr/bin/printf "%s" "${1}"
}
msg_failure() {
	local _red="\\033[1;31m"
	local _normal="\\033[0;39m"
	/usr/bin/printf "${_red}%s${_normal}\n" "FAILURE"
	exit 2
}
msg_success() {
	local _green="\\033[1;32m"
	local _normal="\\033[0;39m"
	/usr/bin/printf "${_green}%s${_normal}\n" "SUCCESS"
	return 0
}
#-----------------------------------------------------------------------------
#	Main line function
_virtual() {	#	6.2. Preparing Virtual Kernel File Systems
	[ -d ${LFS}/dev ]         || /bin/mkdir -p ${LFS}/dev
	[ -d ${LFS}/proc ]        || /bin/mkdir -p ${LFS}/proc
	[ -d ${LFS}/sys ]         || /bin/mkdir -p ${LFS}/sys
	[ -d ${LFS}/run ]         || /bin/mkdir -p ${LFS}/run
	[ -e ${LFS}/dev/console ] || /bin/mknod -m 600 ${LFS}/dev/console c 5 1
	[ -e ${LFS}/dev/null ]    || /bin/mknod -m 666 ${LFS}/dev/null c 1 3
	return
}
_umount(){
	/bin/mountpoint -q ${LFS}/run	&&	/bin/umount ${LFS}/run
	/bin/mountpoint -q ${LFS}/sys	&&	/bin/umount ${LFS}/sys
	/bin/mountpoint -q ${LFS}/proc	&&	/bin/umount ${LFS}/proc
	/bin/mountpoint -q ${LFS}/dev/pts	&&	/bin/umount ${LFS}/dev/pts
	/bin/mountpoint -q ${LFS}/dev	&&	/bin/umount ${LFS}/dev
	return
}
_mount() {
	/bin/mountpoint -q ${LFS}/dev	||	/bin/mount --bind /dev ${LFS}/dev
	/bin/mountpoint -q ${LFS}/dev/pts	||	/bin/mount -t devpts devpts ${LFS}/dev/pts -o gid=5,mode=620
	/bin/mountpoint -q ${LFS}/proc	||	/bin/mount -t proc proc ${LFS}/proc
	/bin/mountpoint -q ${LFS}/sys	||	/bin/mount -t sysfs sysfs ${LFS}/sys
	/bin/mountpoint -q ${LFS}/run	||	/bin/mount -t tmpfs tmpfs ${LFS}/run
	[ -h ${LFS}/dev/shm ] &&			/bin/mkdir -p ${LFS}/$(readlink ${LFS}/dev/shm)
	return
}
_chroot() {
	/usr/sbin/chroot "$LFS" /tools/bin/env -i \
		HOME=/root \
		TERM="$TERM" \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
		/bin/bash --login +h
	return
}
_chown() {
	/bin/chown -R root:root ${LFS}
return
}
#-----------------------------------------------------------------------------
#	Main line
[ ${EUID} -eq 0 ] 	|| die "${PRGNAME}: Need to be root user: FAILURE"
LIST+="_chown _virtual _umount _mount _chroot"
for i in ${LIST};do ${i};done
