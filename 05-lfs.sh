#!/bin/bash
#################################################
#	Title:	05-lfs.sh												#
#        Date:	2017-01-03										#
#     Version:	1.1												#
#      Author:	baho-utot@columbus.rr.com							#
#     Options:													#
#################################################
set -o errexit			# exit if error...insurance ;)
set -o nounset			# exit if variable not initalized
set +h				# disable hashall
PRGNAME=${0##*/}	# script name minus the path
TOPDIR=${PWD}
#	Build variables
LC_ALL=POSIX
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin
export LC_ALL PATH
#
PARENT=/usr/src/Octothorpe
LOGPATH=${TOPDIR}/LOGS/BASE
INFOPATH=${TOPDIR}/INFO/BASE
SPECPATH=${TOPDIR}/SPECS/BASE
PROVIDESPATH=${TOPDIR}/PROVIDES/BASE
REQUIRESPATH=${TOPDIR}/REQUIRES/BASE
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

maker(){	#	$1:	name of package
	local _log="${LOGPATH}/${1}"
	local _pkg=$(find ${RPMPATH} -name "${1}-[0-9]*.rpm" -print 2>/dev/null)
	local _filespec=${SPECPATH}/${1}.spec
	#
	#	Build
	#
	msg_line "	Building: ${1}: "
	if [ -z ${_pkg} ]; then
		rm ${_log}.installed > ${_log} 2>&1	|| true
		rm ${INFOPATH}/${1} > ${_log} 2>&1	|| true
		rpmbuild -ba \
			${_filespec} >> ${_log} 2>&1 && msg_success || msg_failure
		_pkg=$(find ${RPMPATH} -name "${1}-[0-9]*.rpm" -print)
	else
		msg "Skipped"
		#	return
	fi
}
info(){		#	$1:	Name of package
	local _log="${LOGPATH}/${1}"
	local _pkg=$(find ${RPMPATH} -name "${1}-[0-9]*.rpm" -print 2>/dev/null)
	#
	#	Info
	#
	msg_line "	Info: ${1}: "
	[ -z ${_pkg} ] && die "ERROR: rpm package not found"
	if [ ! -e ${INFOPATH}/${1} ]; then
		rpm -qilp \
			${_pkg} > ${INFOPATH}/${1} 2>&1 || true
		rpm -qp --provides \
			${_pkg} > ${PROVIDESPATH}/${1} 2>&1 || true
		rpm -qp --requires \
			${_pkg} > ${REQUIRESPATH}/${1} 2>&1 || true
		msg_success
	else
		 msg "Skipped"
	fi
}
installer(){	#	$1:	name of package
	local _log="${LOGPATH}/${1}"
	local _pkg=$(find ${RPMPATH} -name "${1}-[0-9]*.rpm" -print 2>/dev/null)
	#
	#	Install
	#
	msg_line "	Installing: ${1}: "
	[ -z ${_pkg} ] && die "ERROR: rpm package not found"
	if [ ! -e ${_log}.installed ]; then
		rpm -Uvh --nodeps \
			${_pkg} >> "${_log}" 2>&1  && msg_success || msg_failure
		mv ${_log} ${_log}.installed
	else
		msg "Skipped"
	fi
}
_prepare() {
	local _log="${LOGPATH}/${1}"
#	msg "	Post processing:"
	if [ ! -e ${LOGPATH}/${1} ]; then
		msg_line "	Installing macros file: " 
		cat > /etc/rpm/macros <<- EOF
			#
			#	System settings
			#
			%_topdir		/usr/src/Octothorpe
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
			#	%optflags	-march=x86-64 -mtune=generic -O2 -pipe -fPIC
			#		-fstack-protector-strong -fno-plt -fpie -pie
			#	%_ldflags	-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now,--build-id
			%_tmppath	/var/tmp
			%_dbpath	/var/lib/rpm
			#
			#	Do not compress man or info files - breaks file list
			%_build_id_links	none
		EOF
		msg_success
	else
		msg "	 Skipping: ${1} "
	fi		
	touch ${_log}
	return
}
_directories() {
	local _log="${LOGPATH}/${1}"
#	msg "	 Building: ${1}"
	if [ ! -e ${_log} ]; then
		> ${_log}
		msg_line "	Creating Filesystem: "
		mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt} >> ${_log} 2>&1
		mkdir -pv /{media/{floppy,cdrom},sbin,srv,var} >> ${_log} 2>&1
		install -dv -m 0750 /root >> ${_log} 2>&1
		install -dv -m 1777 /tmp /var/tmp >> ${_log} 2>&1
		mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src} >> ${_log} 2>&1
		mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man} >> ${_log} 2>&1
		mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo} >> ${_log} 2>&1
		mkdir -v  /usr/libexec >> ${_log} 2>&1
		mkdir -pv /usr/{,local/}share/man/man{1..8} >> ${_log} 2>&1
		mkdir -pv /lib64  >> ${_log} 2>&1
		mkdir -v /var/{log,mail,spool} >> ${_log} 2>&1
		ln -sv /run /var/run >> ${_log} 2>&1
		ln -sv /run/lock /var/lock >> ${_log} 2>&1
		mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local} >> ${_log} 2>&1
		msg_success
	else
		msg "	 Skipping: ${1} "
	fi
	return
}
_symlinks() {
	local _log="${LOGPATH}/${1}"
#	msg "	 Building: ${1}"
	if [ ! -e ${_log} ]; then
		> ${_log}
		msg_line "	Creating Symlinks: "
			ln -sfv /tools/bin/{bash,cat,dd,echo,ln,pwd,rm,stty} /bin >> ${_log} 2>&1
			ln -sfv /tools/bin/{install,perl} /usr/bin >> ${_log} 2>&1
			ln -sfv /tools/lib/libgcc_s.so{,.1} /usr/lib >> ${_log} 2>&1
			ln -sfv /tools/lib/libstdc++.{a,so{,.6}} /usr/lib >> ${_log} 2>&1
			ln -sfv bash /bin/sh >> ${_log} 2>&1
			ln -sfv /proc/self/mounts /etc/mtab >> ${_log} 2>&1
		msg_success
		msg_line "	Creating Files: "
		cat > /etc/passwd <<- "EOF"
			root:x:0:0:root:/root:/bin/bash
			bin:x:1:1:bin:/dev/null:/bin/false
			daemon:x:6:6:Daemon User:/dev/null:/bin/false
			messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
			nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
		EOF
		cat > /etc/group <<- "EOF"
			root:x:0:
			bin:x:1:daemon
			sys:x:2:
			kmem:x:3:
			tape:x:4:
			tty:x:5:
			daemon:x:6:
			floppy:x:7:
			disk:x:8:
			lp:x:9:
			dialout:x:10:
			audio:x:11:
			video:x:12:
			utmp:x:13:
			usb:x:14:
			cdrom:x:15:
			adm:x:16:
			messagebus:x:18:
			systemd-journal:x:23:
			input:x:24:
			mail:x:34:
			nogroup:x:99:
			users:x:999:
		EOF
		touch /var/log/{btmp,lastlog,faillog,wtmp}  >> ${_log} 2>&1
		chgrp -v utmp /var/log/lastlog >> ${_log} 2>&1
		chmod -v 664  /var/log/lastlog >> ${_log} 2>&1
		chmod -v 600  /var/log/btmp >> ${_log} 2>&1
		msg_success
	else
		msg "	 Skipping: ${1} "
	fi
	return
}
_glibc() {
	local _log="${LOGPATH}/${1}"
	if [ ! -e ${_log}.prepare ]; then
		[ -h /usr/lib/gcc ]			|| ln -sf /tools/lib/gcc /usr/lib
		[ -e /usr/include/limits.h ]	&& rm -f /usr/include/limits.h
		case $(uname -m) in
			i?86)		GCC_INCDIR=/usr/lib/gcc/$(uname -m)-pc-linux-gnu/7.3.0/include
					ln -sfv ld-linux.so.2 /lib/ld-lsb.so.3
			;;
			x86_64)	GCC_INCDIR=/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/include
					[ -d /lib64 ]	|| install -vdm 755 /lib64
					ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64
					ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
			;;
		esac
		touch ${_log}.prepare
	fi
	maker ${1}
	info  ${1}
	installer ${1}
	return
}
_gen-locales() {
	local _log="${LOGPATH}/${1}"
	if [ ! -e ${_log}.installed ]; then
		msg "	 Building: ${1}"
		> ${_log}
		msg_line "	Creating locales: "
		/sbin/locale-gen.sh
		msg_success
		mv ${_log} ${_log}.installed
	else
		msg "	Skipping: ${1}"
	fi
	return
}
_adjust-tool-chain() {
	local _log="${LOGPATH}/${1}"
	if [ ! -e ${_log}.installed ]; then
		msg "	Building: ${1}"
		> ${_log}
		msg_line "	Moving files: "
			mv -v /tools/bin/{ld,ld-old} >> ${_log} 2>&1
			mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old} >> ${_log} 2>&1
			mv -v /tools/bin/{ld-new,ld} >> ${_log} 2>&1
			ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld >> ${_log} 2>&1
		msg_success
		msg_line "	Fixing spec file: "
			gcc -dumpspecs | sed -e 's@/tools@@g' \
				-e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
				-e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' > \
				`dirname $(gcc --print-libgcc-file-name)`/specs
		msg_success
		mv ${_log} ${_log}.installed
	else
		msg "	Skipping: ${1}"
	fi
	return

}
_tool-chain-test() {
	local _log="${LOGPATH}/${1}"
	if [ ! -e ${_log}.installed ]; then
		msg "	Building: ${1}"
		> ${_log}
		msg_line "	Running Check: "
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
		msg_success
		mv ${_log} ${_log}.installed
	else
		msg "	Skipping: ${1}"
	fi
	return
}
_bc() {
	local _log="${LOGPATH}/${1}"
	if [ ! -e ${_log}.prepare ]; then
		[ -h /usr/lib/libncursesw.so.6 ] || ln -s /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
		[ -h /usr/lib/libncurses.so ] || ln -sf libncurses.so.6 /usr/lib/libncurses.so
		touch ${_log}.prepare
	fi
	maker ${1}
	info  ${1}
	installer ${1}
	return
}
_ncurses() {
	#	baker ${1}
	[ -h /usr/lib/libncursesw.so.6 ] 	&& rm /usr/lib/libncursesw.so.6
	[ -h /usr/lib/libncurses.so ]		&& rm /usr/lib/libncurses.so
	maker ${1}
	info  ${1}
	installer ${1}
	return
}
_gcc() {
	maker ${1}
	info  ${1}
	rm /usr/lib/gcc 2> /dev/null || true
	installer ${1}
	return
}
_gcc-test() {
	local _log="${LOGPATH}/${1}"
	if [ ! -e ${_log}.installed ]; then
		msg_line "	Running Check: "
		echo 'int main(){}' > dummy.c
		cc dummy.c -v -Wl,--verbose &> dummy.log

		readelf -l a.out | grep ': /lib' >> ${_log} 2>&1
		msg 'Book: [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]' >> ${_log} 2>&1
		echo"" >> ${_log} 2>&1
		
		grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log >> ${_log} 2>&1
		msg 'Book: /usr/lib/gcc/x86_64-pc-linux-gnu/7.2.0/../../../../lib/crt1.o succeeded' >> ${_log} 2>&1
		msg 'Book: /usr/lib/gcc/x86_64-pc-linux-gnu/7.2.0/../../../../lib/crti.o succeeded' >> ${_log} 2>&1
		msg 'Book: /usr/lib/gcc/x86_64-pc-linux-gnu/7.2.0/../../../../lib/crtn.o succeeded' >> ${_log} 2>&1
		echo"" >> ${_log} 2>&1

		grep -B4 '^ /usr/include' dummy.log >> ${_log} 2>&1
		msg 'Book: #include <...> search starts here:' >> ${_log} 2>&1
		msg 'Book:  /usr/lib/gcc/x86_64-pc-linux-gnu/7.2.0/include' >> ${_log} 2>&1
		msg 'Book:  /usr/local/include' >> ${_log} 2>&1
		msg 'Book:  /usr/lib/gcc/x86_64-pc-linux-gnu/7.2.0/include-fixed' >> ${_log} 2>&1
		msg 'Book:  /usr/include' >> ${_log} 2>&1
		echo"" >> ${_log} 2>&1

		grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g' >> ${_log} 2>&1
		msg 'Book: SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib64")' >> ${_log} 2>&1
		msg 'Book: SEARCH_DIR("/usr/local/lib64")' >> ${_log} 2>&1
		msg 'Book: SEARCH_DIR("/lib64")' >> ${_log} 2>&1
		msg 'Book: SEARCH_DIR("/usr/lib64")' >> ${_log} 2>&1
		msg 'Book: SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib")' >> ${_log} 2>&1
		msg 'Book: SEARCH_DIR("/usr/local/lib")' >> ${_log} 2>&1
		msg 'Book: SEARCH_DIR("/lib")' >> ${_log} 2>&1
		msg 'Book: SEARCH_DIR("/usr/lib");' >> ${_log} 2>&1
		echo"" >> ${_log} 2>&1

		grep "/lib.*/libc.so.6 " dummy.log dummy.log >> ${_log} 2>&1
		msg 'Book: attempt to open /lib/libc.so.6 succeeded' >> ${_log} 2>&1
		echo"" >> ${_log} 2>&1

		grep found dummy.log >> ${_log} 2>&1
		msg 'Book: found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2' >> ${_log} 2>&1

		rm -v dummy.c a.out dummy.log >> ${_log} 2>&1
		msg_success
		mv ${_log} ${_log}.installed
	else
		msg "	Skipping: ${1}"
	fi
	return
}
_ncurses() {
	[ -h /usr/lib/libncursesw.so.6 ] 	&& rm /usr/lib/libncursesw.so.6
	[ -h /usr/lib/libncurses.so ]		&& rm /usr/lib/libncurses.so
	maker ${1}
	info  ${1}
	installer ${1}
	return
}
_shadow() {
	local _log="${LOGPATH}/${1}"
	maker ${1}
	info  ${1}
	installer ${1}
	if [ ! -e ${_log}.post ]; then
		pwconv
		grpconv
		passwd --delete root
		#	passwd root
		touch ${_log}.post
	fi
	return
}
_perl() {
	local _log="${LOGPATH}/${1}"
	if [ ! -e ${_log}.post ]; then
		echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
		touch ${_log}.post
	fi
	maker ${1}
	info  ${1}
	installer ${1}
	return
}
_linux() {
	local _log="${LOGPATH}/${1}"
	maker ${1}
	info  ${1}
	installer ${1}
	return
}
_cleanup() {
	local _log="${LOGPATH}/${1}"
	local _list=""
	local i=""
	msg "	Cleanup processing:"
	if [ ! -e ${_log} ]; then
		msg_line "	Removing tool chain rpms: "
			_list+="tools-binutils-pass-1 tools-gcc-pass-1 tools-linux-api-headers "
			_list+="tools-glibc tools-libstdc tools-binutils-pass-2 "
			_list+="tools-gcc-pass-2 tools-tcl-core tools-expect tools-dejagnu "
			_list+="tools-check tools-ncurses tools-bash tools-bison tools-bzip2 tools-coreutils "
			_list+="tools-diffutils tools-file tools-findutils tools-gawk tools-gettext "
			_list+="tools-grep tools-gzip tools-m4 tools-make tools-patch tools-perl tools-sed "
			_list+="tools-tar tools-texinfo tools-util-linux tools-xz "
		for i in ${_list};do
			rpm -e --nodeps ${i} > /dev/null 2>&1 || true
		done	
		msg_success
		msg_line "	Removing /tools directory"
			rm -rf /tools
		msg_success
		msg_line "	Installing system rpm macro file"
		cat > /etc/rpm/macros <<- EOF
			#
			#	System settings
			#
			%_topdir		/usr/src/Octothorpe
			%_prefix		/usr
			%_lib			/lib
			%_libdir		/usr/lib
			%_lib64			/lib64
			%_libdir64		/usr/lib64
			%_var			/var
			%_sharedstatedir	/var/lib
			%_localstatedir		/var
			%_tmppath	/var/tmp
			%_dbpath	/var/lib/rpm
			#
			#	Do not compress man or info files - breaks file list
			%__os_install_post \
			    %{_rpmconfigdir}/brp-strip %{__strip} \
			    %{_rpmconfigdir}/brp-strip-static-archive %{__strip} \
			    %{_rpmconfigdir}/brp-strip-comment-note %{__strip} %{__objdump} \
			%{nil}
		EOF
		msg_success
	fi		
	touch ${_log}
	return
}
_config() {
	local _log="${LOGPATH}/${1}"
	local _list=""
	local i=""
	if [ ! -e ${_log} ]; then
		msg "	Edit Configuration:"
#		/sbin/locale-gen.sh
#		/sbin/ldconfig
		_list="/etc/sysconfig/clock "
		_list+="/etc/profile "
		_list+="/etc/hosts "
		_list+="/etc/hostname "
		_list+="/etc/fstab "
		_list+="/etc/sysconfig/ifconfig.eth0 "
		_list+="/etc/resolv.conf "
		_list+="/etc/lsb-release "
		_list+="/etc/sysconfig/rc.site"
		for i in ${_list};do vim "${i}";done
	fi
#	touch ${_log}
	return
}
#
#	Main line
#
[ ${EUID} -eq 0 ] 	|| die "${PRGNAME}: Need to be root user: FAILURE"
[ -z ${PARENT} ]	&& die "${PRGNAME}: Variable: PARENT not set: FAILURE"
#
#	LFS Base system
#
msg "Building LFS base"
LIST=""
LIST+="prepare "
LIST+="directories "
LIST+="symlinks "
LIST+="filesystem "
LIST+="linux-api-headers "
LIST+="man-pages "
LIST+="glibc "
LIST+="gen-locales "
LIST+="tzdata "
LIST+="adjust-tool-chain "
LIST+="tool-chain-test "
LIST+="zlib "
LIST+="file "
LIST+="readline "
LIST+="m4 "
LIST+="bc "
#LIST+="binutils "
#LIST+="gmp "
#LIST+="mpfr "
#LIST+="mpc "
#LIST+="gcc "
#LIST+="gcc-test "

#LIST+="bzip2 pkg-config ncurses attr acl libcap sed shadow psmisc iana-etc "
#LIST+="bison flex grep bash libtool gdbm gperf expat inetutils perl XML-Parser "
#LIST+="intltool autoconf automake xz kmod gettext procps-ng e2fsprogs coreutils "
#LIST+="diffutils gawk findutils groff grub less gzip iproute2 kbd libpipeline "
#LIST+="make patch sysklogd sysvinit eudev util-linux man-db tar texinfo "
#LIST+="vim lfs-bootscripts "
#	rpm package manager
#LIST+="elfutils openssl popt rpm openssh wget "
#	Kernel config needs openssl
#LIST+="linux "
#LIST+="cleanup config"
for i in ${LIST};do
	rm -rf BUILD 
	rm -rf BUILDROOT
	case ${i} in
		directories)		_directories ${i}	;;
		symlinks)		_symlinks ${i}		;;
		prepare)		_prepare ${i}		;;
		glibc)			_glibc ${i}		;;
		gcc)			_gcc ${i}		;;
		gen-locales)		_gen-locales ${i}	;;
		adjust-tool-chain)	_adjust-tool-chain ${i}	;;
		tool-chain-test)	_tool-chain-test ${i}	;;
		bc)			_bc ${i}		;;
		gcc-test)		_gcc-test ${i}		;;
		ncurses)		_ncurses ${i}		;;
		shadow)			_shadow ${i}		;;
		linux)			_linux ${i}		;;
		cleanup)		_cleanup ${i}		;;
		config)			_config ${i}		;;
		*)			maker ${i}	
					info  ${i}
					installer ${i}		;;
	esac
done
end-run
