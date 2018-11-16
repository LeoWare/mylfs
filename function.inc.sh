# Common support functions

# Give an error message and exit with a non-zero status
die() {
	local _red="\\033[1;31m"
	local _normal="\\033[0;39m"
	[ -n "$*" ] && {
		printf "${_red}$*${_normal}\n"
		printf "$*\n" >> ${LOGFILE}
	}
	exit 1
}

# Check if we are the root user. if not, exit.
check_root() {
	[ $EUID -eq 0 ] || die "${PRGNAME}: Must be root. Exiting."
}

# Make sure we have all our environment variables set
check_environment() {
	[ -z ${PARENT} ] && die "${PRGNAME}: PARENT not set: FAILURE"
	[ -z ${LFS_USER} ] && die "${PRGNAME}: LFS_USER not set: FAILURE"
	[ -z ${DEVICE} ] && die "${PRGNAME}: DEVICE not set: FAILURE"
	[ -z ${FILESYSTEM} ] && die "${PRGNAME}: FILESYSTEM not set: FAILURE"
	[ -z ${LFS} ] && die "${PRGNAME}: LFS not set: FAILURE"
	[ -z ${BOOT_DEVICE} ] && die "${PRGNAME}: BOOT_DEVICE not set: FAILURE"
	[ -z ${BOOT_FS} ] && die "${PRGNAME}: BOOT_FS not set: FAILURE"
	[ -z ${BOOT} ] && die "${PRGNAME}: BOOT not set: FAILURE"
	[ -z ${TOOLS} ] && die "${PRGNAME}: TOOLS not set: FAILURE"
	[ -z ${LFS_TGT} ] && die "${PRGNAME}: LFS_TGT not set: FAILURE"
	return 0
}

msg() {
	printf "%s\n" "${1}"
	printf "%s\n" "${1}" >> ${LOGFILE}

}
msg_line() {
	printf "%s" "${1}"
	printf "%s" "${1}" >> ${LOGFILE}
}
msg_failure() {
	local _red="\\033[1;31m"
	local _normal="\\033[0;39m"
	local _msg=""
	if [[ $# -ne 0 ]]; then 
		_msg="${*}"
	else
		_msg="FAILURE"
	fi
	printf "${_red}%s${_normal}\n" "${_msg}"
	printf "%s" "${_msg}" >> $LOGFILE
	exit 2
}
msg_warning() {
	local _yellow="\\033[1;33m"
	local _normal="\\033[0;39m"
	local _msg=""
	if [[ $# -ne 0 ]]; then 
		_msg="${*}"
	else
		_msg="WARNING"
	fi
	printf "${_yellow}%s${_normal}\n" "${_msg}"
	printf "%s\n" "${_msg}" >> $LOGFILE
	return 0
}
msg_success() {
	local _green="\\033[1;32m"
	local _normal="\\033[0;39m"
	#local _msg=""
	if [ $# -ne 0 ]; then 
		local _msg="${*}"
	else
		local _msg="SUCCESS"
	fi
	printf "${_green}%s${_normal}\n" "${_msg}"
	printf "%s\n" "${_msg}" >> $LOGFILE
	return 0
}
msg_section() {
	local _red="\\033[1;31m"
	local _green="\\033[1;32m"
	local _normal="\\033[0;39m"

	local _msg="${1}"
	printf "\n${_red}###        ${_green}%s${_red}        ###${_normal}\n\n" "${_msg}"
	printf "\n###        %s        ###\n\n" "${_msg}" >> ${LOGFILE}
}
end_run() {
	local _green="\\033[1;32m"
	local _normal="\\033[0;39m"
	printf "${_green}%s${_normal}\n" "Run Complete" >> ${LOGFILE}
	return
}
build() {
	# $1 = message 
	# $2 = command
	# $3 = log file
	local _msg="${1}"
	local _cmd="${2}"
	local _logfile="${3}"
	if [ "/dev/null" == "${_logfile}" ]; then
		msg_line "${_msg}: "
		eval ${_cmd} >> ${_logfile} 2>&1 && msg_success || msg_failure 
	else
		msg_line "${_msg}: "
		printf "\n%s\n\n" "###       ${_msg}       ###" >> ${_logfile} 2>&1
		eval ${_cmd} >> ${_logfile} 2>&1 && msg_success || msg_failure 
		fi
	return 0
}

unpack() {
	# $1 = directory
	# $2 = source package name. I'll find the suffix thank you
	local _dir=${1%%/BUILD*} # remove BUILD from path
	local i=${2}
	local p=$(echo ${_dir}/SOURCES/${i}*.tar.*)
	msg_line "	Unpacking: ${i}: "
	[ -e ${p} ] || die " File not found: FAILURE"
	tar xf ${p} && msg_success || msg_failure
	return 0
}

build_toolchain() {
    su --login $USER <<- "EOF"
		cd ~
		source ~/.bashrc
		cd ${LFS}${PARENT}
		pwd
		./toolchain.sh
		EOF
	return 0
}

build_filesystem() {
	local _logfile="${LOGDIR}/filesystem.log"
	BLD="/tools/bin/rpmbuild -ba --nocheck --define \"_topdir ${LFS}${PARENT}\" --define \"_dbpath ${LFS}/var/lib/rpm\" SPECS/filesystem.spec"
	RPMPKG="$(find ${RPMSDIR} -name 'filesystem-[0-9]*.rpm' -print)"
	[ -z ${RPMPKG} ] && build "${BLD}" "${BLD}" "${_logfile}"
	RPMPKG="$(find ${RPMSDIR} -name 'filesystem-[0-9]*.rpm' -print)"
	[ -z ${RPMPKG} ] && die "Filesystem rpm package missing: Can not continue"
	build "Installing filesystem" "/tools/bin/rpm -Uvh --nodeps --root /mnt/lfs ${RPMPKG}" "${_logfile}"
	build "Creating symlinks: /tools/bin/{bash,cat,echo,pwd,stty}" "ln -fsv /tools/bin/{bash,cat,echo,pwd,stty} ${LFS}/bin"   "${_logfile}"
	build "Creating symlinks: /tools/bin/perl /usr/bin" "ln -fsv /tools/bin/perl ${LFS}/usr/bin" "${_logfile}"
	build "Creating symlinks: /tools/lib/gcc /usr/lib/gcc" "ln -fsv /tools/lib/gcc ${LFS}/usr/lib/gcc" "${_logfile}"
	build "Creating symlinks: /tools/lib/libgcc_s.so{,.1}" "ln -fsv /tools/lib/libgcc_s.so{,.1} ${LFS}/usr/lib" "${_logfile}"
	build "Creating symlinks: /tools/lib/libstdc++.so{,.6} /usr/lib" "ln -fsv /tools/lib/libstdc++.so{,.6} ${LFS}/usr/lib"	 "${_logfile}"
	build "Sed: /usr/lib/libstdc++.la" "sed 's/tools/usr/' /tools/lib/libstdc++.la > ${LFS}/usr/lib/libstdc++.la" "${_logfile}"
	build "Creating symlinks: bash /bin/sh" "ln -fsv bash ${LFS}/bin/sh" "${_logfile}"
	#	Ommited in the filesystem.spec file - not needed for booting
	
	[ -e ${LFS}/dev/console ]	|| build "mknod -m 600 ${LFS}/dev/console c 5 1" "mknod -m 600 ${LFS}/dev/console c 5 1" "${_logfile}"
	[ -e ${LFS}/dev/null ]		|| build "mknod -m 666 ${LFS}/dev/null c 1 3" "mknod -m 666 ${LFS}/dev/null c 1 3" "${_logfile}"
	return 0
}

# this function is called in the host context
build_shell_filesystem() {
	local _logfile="${LOGDIR}/filesystem.log"
	mkdir -pv $LFS/{dev,proc,sys,run}
	mkdir -pv $LFS/{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
	mkdir -pv $LFS/{media/{floppy,cdrom},sbin,srv,var}
	install -dv -m 0750 $LFS/root
	install -dv -m 1777 $LFS/tmp $LFS/var/tmp
	mkdir -pv $LFS/usr/{,local/}{bin,include,lib,sbin,src}
	mkdir -pv $LFS/usr/{,local/}share/{color,dict,doc,info,locale,man}
	mkdir -v  $LFS/usr/{,local/}share/{misc,terminfo,zoneinfo}
	mkdir -v  $LFS/usr/libexec
	mkdir -pv $LFS/usr/{,local/}share/man/man{1..8}

	case $(uname -m) in
		x86_64) mkdir -v $LFS/lib64 ;;
	esac

	mkdir -v $LFS/var/{log,mail,spool}
	ln -sv /run $LFS/var/run
	ln -sv /run/lock $LFS/var/lock
	mkdir -pv $LFS/var/{opt,cache,lib/{color,misc,locate},local}
	[ -e ${LFS}/dev/console ]	|| build "mknod -m 600 ${LFS}/dev/console c 5 1" "mknod -m 600 ${LFS}/dev/console c 5 1" "${_logfile}"
	[ -e ${LFS}/dev/null ]		|| build "mknod -m 666 ${LFS}/dev/null c 1 3" "mknod -m 666 ${LFS}/dev/null c 1 3" "${_logfile}"
	touch ${LOGDIR}/filesystem.completed
	return 0
}

install_filesystem() {
	return 1
}

mount_kernel_vfs() {
	if ! mountpoint ${LFS}/dev	>/dev/null 2>&1; then mount --bind /dev ${LFS}/dev; fi
	if ! mountpoint ${LFS}/dev/pts	>/dev/null 2>&1; then mount -t devpts devpts ${LFS}/dev/pts -o gid=5,mode=620; fi
	if ! mountpoint ${LFS}/proc	>/dev/null 2>&1; then mount -t proc proc ${LFS}/proc; fi
	if ! mountpoint ${LFS}/sys 	>/dev/null 2>&1; then mount -t sysfs sysfs ${LFS}/sys; fi
	if ! mountpoint ${LFS}/run	>/dev/null 2>&1; then mount -t tmpfs tmpfs ${LFS}/run; fi
	if [ -h ${LFS}/dev/shm ];			 then mkdir -pv ${LFS}/$(readlink ${LFS}/dev/shm); fi
	return 0
}

umount_kernel_vfs() {
	if mountpoint ${LFS}/run	>/dev/null 2>&1; then umount ${LFS}/run; fi
	if mountpoint ${LFS}/sys	>/dev/null 2>&1; then umount ${LFS}/sys; fi
	if mountpoint ${LFS}/proc	>/dev/null 2>&1; then umount ${LFS}/proc; fi
	if mountpoint ${LFS}/dev/pts	>/dev/null 2>&1; then umount ${LFS}/dev/pts; fi
	if mountpoint ${LFS}/dev	>/dev/null 2>&1; then umount ${LFS}/dev; fi
	return 0
}

build_rpms() {
	chroot "${LFS}" \
		/tools/bin/env -i \
		HOME=/root \
		TERM="$TERM" \
		PS1='(LFS chroot) \u:\w\$ ' \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
		PARENT="${PARENT}" \
		LOGFILE="${LOGFILE}" \
		/tools/bin/bash --login +h -c "cd ${PARENT};./build-rpms.sh"
}

build_shell() {
	chroot "${LFS}" \
		/tools/bin/env -i \
		HOME=/root \
		TERM="$TERM" \
		PS1='(LFS chroot) \u:\w\$ ' \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
		PARENT="${PARENT}" \
		BUILDLOG="${LOGFILE}" \
		/tools/bin/bash --login +h -c "cd ${PARENT};./build-shell.sh"
}



# vim: set number syntax=sh ts=4 sw=4:
