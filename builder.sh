#!/bin/bash
#-----------------------------------------------------------------------------
#	Title: builder.sh
#	Date: 2018-04-04
#	Version: 1.0
#	Author: baho-utot@columbus.rr.com
#	Options:
#-----------------------------------------------------------------------------
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
#-----------------------------------------------------------------------------
#	Variables
rpm_name=""
rpm_version=""
rpm_release=""
rpm_requires=""
rpm_spec=""
rpm_installed=""
rpm_arch=""
rpm_binary=""
rpm_package=""
rpm_exists=""
rpm_source=""
rpm_tarballs=""
rpm_md5sums=""
#-----------------------------------------------------------------------------
#	Funcions
rpm_params() {
	local i=""
	rpm_arch=$(uname -m)
	if [ -e ${rpm_spec} ]; then
		while  read i; do
			i=$(echo ${i} | tr -d '[:cntrl:][:space:]')
			case ${i} in
				Name:*)		rpm_name=${i##Name:}				;;
				Version:*)		rpm_version=${i##Version:}			;;
				Release:*)		rpm_release=${i##Release:}			;;
				Requires:*)		rpm_requires+="${i##Requires:} "		;;
				?TARBALL:*)		rpm_tarballs+="${i##?TARBALL:} "		;;
				?MD5SUM:*)		rpm_md5sums+="${i##?MD5SUM:} "		;;
				*)									;;
			esac
		done < ${rpm_spec}
		#	remove trailing whitespace
		rpm_requires=${rpm_requires## }
		rpm_tarballs=${rpm_tarballs## }
		rpm_md5sums=${rpm_md5sums## }
	else
		die "ERROR: ${rpm_spec}: does not exist"
	fi
	rpm_binary="${rpm_name}-${rpm_version}-${rpm_release}.${rpm_arch}.rpm"
	rpm_package=${rpm_binary%.*}
	rpm_status
	rpm_exists
	return
}
rpm_build() {
	local i=""
	local _log="${LOGS}/${rpm_name}"
	> ${_log}
	> ${INFOS}/${rpm_name}
	> ${PROVIDES}/${rpm_name}
	> ${REQUIRES}/${rpm_name}
	printf "%s\n" "Status for ${rpm_binary}"
	msg "Spec-------->	${rpm_spec}"
	msg "Name-------->	${rpm_name}"
	msg "Version----->	${rpm_version}"
	msg "Release----->	${rpm_release}"
	msg "Arch-------->	${rpm_arch}"
	for i in ${rpm_requires};do msg "Requires---->	${i}";done
	msg "Package----->	${rpm_package}"
	msg "Binary------>	${rpm_binary}"
	msg "Exists------>	${rpm_exists}"
	msg "Installed--->	${rpm_installed}"
	for i in ${rpm_tarballs}; do msg "Tarball----->	${i}";done
	for i in ${rpm_md5sums}; do  msg "MD5SUM------>	${i}";done
	rm -rf BUILD BUILDROOT
	#
	#	These fixes are for chapter 5 and chapter 6
	#	Due to the way LFS build the system
	#
	case ${rpm_name} in
		"adjust-tool-chain")		# adjust and test tools chain
#			msg "Building: ${rpm_name}: "
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
			;;
		"glibc")		#	fixes for chapter 6 glibc
			[ -e /usr/lib/gcc ]			|| ln -sf /tools/lib/gcc /usr/lib
			[ -e /usr/include/limits.h ]	&& rm -f /usr/include/limits.h
			[ -h /lib64/ld-linux-x86-64.so.2 ]	|| ln -sf ../lib/ld-linux-x86-64.so.2 /lib64
			[ -h /lib64/ld-lsb-x86-64.so.3 ]	|| ln -sf ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
			;;
		"locales")		#	build locales
			msg "Building: ${rpm_name}: "
			/sbin/locale-gen.sh >> ${_log} 2>&1
			;;
		"bc")			#	fixes for chapter 6 bc
			[ -h /usr/lib/libncursesw.so.6 ] || ln -s /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
			[ -h /usr/lib/libncurses.so ] || ln -sf libncurses.so.6 /usr/lib/libncurses.so
			;;
		"gcc-test")		#	fixes for chapter 6 glibc
			msg "Building: ${rpm_name}: "
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
			;;
		"tools-post")
			#	remove all un-needed files only leaving
			#	what is needed to run rpm
			msg "	Post processing:"
			#	This preserves all the libraries that are needed
			#	and removes evertything else so that only the static built
			#	rpm and its libraries that are needed are left.
			#	Keeps the LFS build clean of external packages.
			#	rpm was placed into /usr/bin and /usr/lib
			#	The chapter 6 rpm files will over write these files
			LIST="tools-zlib tools-popt tools-openssl tools-libelf tools-rpm"
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
			for i in ${LIST}; do
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
			touch ${LOGPATH}/${PRGNAME}
			;;
		"prepare")		#	Prepare for chapter 6
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
					#	%optflags	-march=x86-64 -mtune=generic -O2 -pipe -fPIC -fstack-protector-strong -fno-plt -fpie -pie
					#	%_ldflags	-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now,--build-id
					%_tmppath	/var/tmp
					%_dbpath	/var/lib/rpm
					#
					#	Do not compress man or info files - breaks file list
					%_build_id_links	none
				EOF
			msg_success
			msg_line "Creating Filesystem: "
#				mkdir -p /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
#				mkdir -p /{media/{floppy,cdrom},sbin,srv,var}
#				install -d -m 0750 /root
#				install -d -m 1777 /tmp /var/tmp
#				mkdir -p /usr/{,local/}{bin,include,lib,sbin,src}
#				mkdir -p /usr/{,local/}share/{color,dict,doc,info,locale,man}
#				mkdir -p  /usr/{,local/}share/{misc,terminfo,zoneinfo}
#				mkdir -p  /usr/libexec
#				mkdir -p /usr/{,local/}share/man/man{1..8}
#				mkdir -p /lib64
#				mkdir -p /var/{log,mail,spool}
#				ln -sf /run /var/run
#				ln -sf /run/lock /var/lock
#				mkdir -p /var/{opt,cache,lib/{color,misc,locate},local}
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
#				touch /var/log/{btmp,lastlog,faillog,wtmp}
#				chgrp utmp /var/log/lastlog
#				chmod 664  /var/log/lastlog
#				chmod 600  /var/log/btmp
			;;
		"cleanup")		#	Cleanup chapter 6 build
			local _list=""
			local i=""
			msg "	Cleanup processing:"
			msg_line "	Removing tool chain rpms: "
				_list+="tools-fetch "
				_list+="tools-binutils-pass-1 tools-gcc-pass-1 tools-linux-api-headers "
				_list+="tools-glibc tools-libstdc tools-binutils-pass-2 "
				_list+="tools-gcc-pass-2 tools-tcl-core tools-expect tools-dejagnu "
				_list+="tools-check tools-ncurses tools-bash tools-bison tools-bzip2 tools-coreutils "
				_list+="tools-diffutils tools-file tools-findutils tools-gawk tools-gettext "
				_list+="tools-grep tools-gzip tools-m4 tools-make tools-patch tools-perl tools-sed "
				_list+="tools-tar tools-texinfo tools-util-linux tools-xz "
				for i in ${_list};do rpm -e --nodeps ${i} > /dev/null 2>&1 || true;done
			msg_success
			msg_line "	Removing Builder helper rpms: "
				_list+="prepare adjust-tool-chain locales gcc-test "
				for i in ${_list};do rpm -e --nodeps ${i} > /dev/null 2>&1 || true;done
			msg_success
			msg_line "	Removing /tools directory: "; rm -rf /tools;msg_success
#			msg_line "	Removing lfs user: ";userdel -r lfs;msg_success
			;;
		"config")
			local i=""
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
			;;
		*)	;;
	esac
	rpm_fetch	#	fetch packages
	msg_line "Building: ${rpm_name}: "
	rpmbuild -ba ${rpm_spec} >> ${_log} 2>&1	 && msg_success || die "ERROR: ${rpm_binary}"
	rpm_exists
	[ "F" == ${rpm_exists} ] && die "ERROR: Binary Missing: ${rpm_binary}"
	rpm -qilp		${RPMS}/${rpm_arch}/${rpm_binary} > ${INFOS}/${rpm_name}	2>&1 || true
	rpm -qp --provides	${RPMS}/${rpm_arch}/${rpm_binary} > ${PROVIDES}/${rpm_name}	2>&1 || true
	rpm -qp --requires	${RPMS}/${rpm_arch}/${rpm_binary} > ${REQUIRES}/${rpm_name}	2>&1 || true
	return
}
rpm_install() {
	local _log="${LOGS}/${rpm_name}"
	msg_line "Installing: ${rpm_binary}: "
	rpm -Uvh --nodeps "${RPMS}/${rpm_arch}/${rpm_binary}" >> "${_log}" 2>&1  && msg_success || msg_failure
	return
}
rpm_exists(){
	[ -e "${RPMS}/${rpm_arch}/${rpm_binary}" ] && rpm_exists="T" || rpm_exists="F"
	return
}
rpm_depends() {
	local i=""
	for i in ${rpm_requires}; do ${TOPDIR}/builder.sh ${i} || die "ERROR: rpm_depends: ${rpm_spec}";done
	return
}
rpm_status() {
	[ "${rpm_package}" == "$(rpm -q "$rpm_package")" ] && rpm_installed="T" || rpm_installed="F"
	return
}
rpm_fetch() {
	local i=""
	local filespec=""
	for i in ${rpm_tarballs}; do
		filespec=${i##*/}
		if [ ! -e "SOURCES/${filespec}" ]; then
			msg_line "Fetching source tarball: ${i}: "
				wget --no-clobber --no-check-certificate --directory-prefix=SOURCES ${i} > /dev/null 2>&1 || die "Error: wget: ${i}"
#				wget --no-clobber --no-check-certificate --directory-prefix=SOURCES ${i} || die "Error: wget: ${i}"
			msg_success
		fi
	done
	if [ ! -z "${rpm_tarballs}" ]; then
		> SOURCES/"MD5SUM"
		for i in ${rpm_md5sums}; do printf "%s\n" "$(echo ${i} | tr ";" " ")" >> SOURCES/"MD5SUM";done
		# do md5sum check
		msg "Checking source: "
		md5sum -c SOURCES/"MD5SUM" || msg_failure
	fi
	return
}
#-----------------------------------------------------------------------------
#	Main line
if [ -z "$1" ]; then
  echo "Usage: builder.sh <filespec.spec>"
  exit -1
fi
set -o errexit	# exit if error...insurance ;)
set -o nounset	# exit if variable not initalized
set +h			# disable hashall
#
#	Create directories if needed
#
[ -e "${LOGS}" ]		||	install -vdm 755 "${LOGS}"
[ -e "${INFOS}" ]		||	install -vdm 755 "${INFOS}"
[ -e "${SPECS}" ]		||	install -vdm 755 "${SPECS}"
[ -e "${PROVIDES}" ]		||	install -vdm 755 "${PROVIDES}"
[ -e "${REQUIRES}" ]		||	install -vdm 755 "${REQUIRES}"
[ -e "${RPMS}" ]		||	install -vdm 755 "${RPMS}"
rpm_spec=${SPECS}/${1}.spec	#	rpm spec file to build
rpm_params			#	get status and display
rpm_depends			#	Build dependencies
if [ "F" == "${rpm_exists}" ]; then
	rpm_build || die " FAILURE: rpm_build "
fi
if [ "F" == "${rpm_installed}" ]; then
	###	Modified 2018-08-07
	if [ "tools-gcc-pass-2" == ${rpm_name} ]; then
		rpm -e tools-gcc-pass-1 tools-libstdc
	fi
	###
	rpm_install		#	Install rpm
fi
end_run
