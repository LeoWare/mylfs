#!/bin/bash
##########################################
#       Title: lfs.sh                    #
#        Date:	2018-04-04               #
#     Version:	1.0                      #
#      Author: baho-utot@columbus.rr.com #
#     Options:                           #
##########################################
set -o errexit		# exit if error...insurance ;)
set -o nounset		# exit if variable not initalized
set +h				# disable hashall
PRGNAME=${0##*/}	# script name minus the path
TOPDIR=${PWD}		# script lives here
#		Build variables
LC_ALL=POSIX
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin
export LC_ALL PATH
#
PARENT=/usr/src/Octothorpe
LOGPATH=${TOPDIR}/LOGS
INFOPATH=${TOPDIR}/INFO
SPECPATH=${TOPDIR}/SPECS
PROVIDESPATH=${TOPDIR}/PROVIDES
REQUIRESPATH=${TOPDIR}/REQUIRES
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
#
#	Functions
#
_prepare() {
	local _log="${LOGPATH}/prepare"
	if [ ! -e ${_log} ]; then
		msg_line "Installing macros file: "
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
		msg "Skipping: prepare "
	fi
	touch ${_log}
	return
}
_directories() {
	local _log="${LOGPATH}/directories"
	if [ ! -e ${_log} ]; then
		> ${_log}
		msg_line "Creating Filesystem: "
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
		msg "Skipping: directories "
	fi
	return
}
_symlinks() {
	local _log="${LOGPATH}/symlinks"
	if [ ! -e ${_log} ]; then
		> ${_log}
		msg_line "Creating Symlinks: "
			ln -sfv /tools/bin/{bash,cat,dd,echo,ln,pwd,rm,stty} /bin >> ${_log} 2>&1
			ln -sfv /tools/bin/{install,perl} /usr/bin >> ${_log} 2>&1
			ln -sfv /tools/lib/libgcc_s.so{,.1} /usr/lib >> ${_log} 2>&1
			ln -sfv /tools/lib/libstdc++.{a,so{,.6}} /usr/lib >> ${_log} 2>&1
			ln -sfv bash /bin/sh >> ${_log} 2>&1
			ln -sfv /proc/self/mounts /etc/mtab >> ${_log} 2>&1
			ln -sfv /tools/bin/getconf /usr/bin/getconf
		msg_success
		msg_line "Creating Files: "
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
		msg "Skipping: symlinks "
	fi
	return
}
_glibc() {
	local _log="${LOGPATH}/glibc"
	if [ ! -e ${_log}.prepare ]; then
		[ -e /usr/lib/gcc ]			|| ln -sf /tools/lib/gcc /usr/lib
		[ -e /usr/include/limits.h ]	&& rm -f /usr/include/limits.h
		[ -h /lib64/ld-linux-x86-64.so.2 ]	|| ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64
		[ -h /lib64/ld-lsb-x86-64.so.3 ]	|| ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
		touch ${_log}.prepare
	fi
	./builder.sh glibc
	return
}
_gen-locales() {
	local _log="${LOGPATH}/gen-locales"
	if [ ! -e ${_log}.installed ]; then
		msg "Building: gen-locales"
		> ${_log}
		msg_line "Creating locales: "
		/sbin/locale-gen.sh >> ${_log} 2>&1
		msg_success
		mv ${_log} ${_log}.installed
	else
		msg "Skipping: gen-locales"
	fi
	return
}
_adjust-tool-chain() {
	local _log="${LOGPATH}/adjust-tool-chain"
	if [ ! -e ${_log}.installed ]; then
		msg "Building: adjust-tool-chain"
		> ${_log}
		msg_line "Moving files: "
			mv -v /tools/bin/{ld,ld-old} >> ${_log} 2>&1
			mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old} >> ${_log} 2>&1
			mv -v /tools/bin/{ld-new,ld} >> ${_log} 2>&1
			ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld >> ${_log} 2>&1
		msg_success
		msg_line "Fixing spec file: "
			gcc -dumpspecs | sed -e 's@/tools@@g' \
				-e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
				-e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' > \
				`dirname $(gcc --print-libgcc-file-name)`/specs
		msg_success
		mv ${_log} ${_log}.installed
	else
		msg "Skipping: adjust-tool-chain"
	fi
	return
}
_tool-chain-test() {
	local _log="${LOGPATH}/tool-chain-test"
	if [ ! -e ${_log}.installed ]; then
		msg "Building: tool-chain-test"
		> ${_log}
		msg_line "Running Check: "
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
		msg "Skipping: tool-chain-test"
	fi
	return
}
_gcc-test() {
	local _log="${LOGPATH}/gcc-test"
	if [ ! -e ${_log}.installed ]; then
		msg "Building: gcc-test"
		> ${_log}
		msg_line "Running Check: "
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

		echo ""
		rm -v dummy.c a.out dummy.log >> ${_log} 2>&1
		msg_success
		mv ${_log} ${_log}.installed
	else
		msg "Skipping: tool-chain-test"
	fi
	return
}
_bc() {
	local _log="${LOGPATH}/bc"
	if [ ! -e ${_log}.prepare ]; then
		[ -h /usr/lib/libncursesw.so.6 ] || ln -s /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
		[ -h /usr/lib/libncurses.so ] || ln -sf libncurses.so.6 /usr/lib/libncurses.so
		touch ${_log}.prepare
	fi
	./builder.sh bc
	return
}
_cleanup() {
	local _log="${LOGPATH}/cleanup"
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
		msg_line "	Removing /tools directory: "
			rm -rf /tools
		msg_success
		msg_line "	Installing system rpm macro file: "
		cat > /etc/rpm/macros <<- EOF
			#
			#	System settings
			#
			%_topdir		/usr/src/Octothorpe
			%_dbpath		/var/lib/rpm
			%_lib			/lib
			%_libdir		/usr/lib
			%_lib64			/lib64
			%_libdir64		/usr/lib64
			%_var			/var
			%_docdir		/usr/share/doc
			%_sharedstatedir	/var/lib
			%_localstatedir		/var
			%_tmppath		/var/tmp
			%_build_id_links	none
		EOF
		msg_success
	fi
	touch ${_log}
	return
}
_config() {
	local _log="${LOGPATH}/config"
	local _list=""
	local i=""
	if [ ! -e ${_log} ]; then
		msg "	Edit Configuration:"
		/sbin/locale-gen.sh
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
	fi
	touch ${_log}
	return
}
#
#	LFS Base system
#
msg "Building LFS base"
_prepare
_directories
_symlinks
./builder.sh filesystem
./builder.sh linux-api-headers
./builder.sh man-pages
_glibc
_gen-locales
./builder.sh tzdata
_adjust-tool-chain
_tool-chain-test
./builder.sh zlib
./builder.sh file
./builder.sh readline
./builder.sh m4
_bc
./builder.sh binutils
./builder.sh gmp
./builder.sh mpfr
./builder.sh mpc
./builder.sh gcc
_gcc-test
./builder.sh bzip2
./builder.sh pkg-config
./builder.sh ncurses
./builder.sh attr
./builder.sh acl
./builder.sh libcap
./builder.sh sed
./builder.sh shadow
./builder.sh psmisc
./builder.sh iana-etc
./builder.sh bison
./builder.sh flex
./builder.sh grep
./builder.sh bash
./builder.sh libtool
./builder.sh gdbm
./builder.sh gperf
./builder.sh expat
./builder.sh inetutils
./builder.sh perl
./builder.sh XML-Parser
./builder.sh intltool
./builder.sh autoconf
./builder.sh automake
./builder.sh xz
./builder.sh kmod
./builder.sh gettext
./builder.sh libelf
./builder.sh libffi
./builder.sh openssl
./builder.sh python
./builder.sh ninja
./builder.sh meson
./builder.sh procps-ng
./builder.sh e2fsprogs
./builder.sh coreutils
./builder.sh check
./builder.sh diffutils
./builder.sh gawk
./builder.sh findutils
./builder.sh groff
./builder.sh grub
./builder.sh less
./builder.sh gzip
./builder.sh iproute2
./builder.sh kbd
./builder.sh libpipeline
./builder.sh make
./builder.sh patch
./builder.sh sysklogd
./builder.sh sysvinit
./builder.sh eudev
./builder.sh util-linux
./builder.sh man-db
./builder.sh tar
./builder.sh texinfo
./builder.sh vim
./builder.sh lfs-bootscripts
#	RPM packages
./builder.sh popt
./builder.sh rpm
./builder.sh wget
#	kernel
./builder.sh linux
./builder.sh firmware-radeon
./builder.sh firmware-realtek
#	cleanup scruff /tools tools-toolchain
_cleanup
_config
end-run
