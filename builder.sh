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
rpm_patches=""
rpm_filespec=""
#-----------------------------------------------------------------------------
#	Funcions
rpm_params() {
	local i=""
	rpm_arch=$(uname -m)
	if [ -e ${rpm_spec} ]; then
		while  read i; do
			i=$(echo ${i} | tr -d '[:cntrl:][:space:]')
			case ${i} in
#				Source?:*)		rpm_source=${i##Source?:}			;;
				Name:*)		rpm_name=${i##Name:}				;;
				Version:*)		rpm_version=${i##Version:}			;;
				Release:*)		rpm_release=${i##Release:}			;;
				Requires:*)		rpm_requires+="${i##Requires:} "		;;
				?TARBALL:*)		rpm_tarballs+="${i##?TARBALL:} "		;;
				?MD5SUM:*)		rpm_md5sums+="${i##?MD5SUM:} "		;;
				?PATCHES:*)		rpm_patches+="${i##?PATCHES:} "		;;
				?FILE:*)		rpm_filespec+="${i##?FILE:}"		;;
				*)									;;
			esac
		done < ${rpm_spec}
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
#	msg "Source------>	${rpm_source}"
	msg "Md5sum------>	${rpm_filespec}"
	for i in ${rpm_tarballs}; do msg "Tarball----->	${i}";done
	for i in ${rpm_md5sums}; do  msg "MD5SUM------>	${i}";done
	for i in ${rpm_patches}; do  msg "Patch------->	${i}";done
	#rpm_tarballs=""
	#rpm_md5sums=""
	#rpm_patches=""
	#rpm_filespec=""
	rm -rf BUILD BUILDROOT
	#
	#	These fixes are for base system chapter 6
	#
	case ${rpm_name} in
		"adjust-tool-chain")	# adjust and test tools chain
			msg_line "Building: ${rpm_name}: "
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
		"glibc")
			[ -e /usr/lib/gcc ]			|| ln -sf /tools/lib/gcc /usr/lib
			[ -e /usr/include/limits.h ]	&& rm -f /usr/include/limits.h
			[ -h /lib64/ld-linux-x86-64.so.2 ]	|| ln -sf ../lib/ld-linux-x86-64.so.2 /lib64
			[ -h /lib64/ld-lsb-x86-64.so.3 ]	|| ln -sf ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
			;;
		"locales")
			msg_line "Building: ${rpm_name}: "
			/sbin/locale-gen.sh >> ${_log} 2>&1
			;;
		"bc")
			[ -h /usr/lib/libncursesw.so.6 ] || ln -s /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
			[ -h /usr/lib/libncurses.so ] || ln -sf libncurses.so.6 /usr/lib/libncurses.so
			;;
		"gcc-test")
			msg_line "Building: ${rpm_name}: "
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
		*)	;;
	esac
	rpm_fetch	#	fetch packages
	msg_line "Building: ${rpm_name}: "
	rpmbuild -ba ${rpm_spec} >> ${_log} 2>&1	 && msg_success || die "ERROR: ${rpm_binary}"
	rpm_exists
	[ "F" == ${rpm_exists} ] && die "ERROR: Binary Missing: ${rpm_binary}"
	rpm -qilp			${RPMS}/${rpm_arch}/${rpm_binary} > ${INFOS}/${rpm_name}	2>&1 || true
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
	if [ -e "${RPMS}/${rpm_arch}/${rpm_binary}" ]; then
		rpm_exists="T"
	else
		rpm_exists="F"
	fi
	return
}
rpm_depends() {
	local i=""
	for i in ${rpm_requires}; do
		${TOPDIR}/builder.sh ${i} || die "ERROR: rpm_depends: ${rpm_spec}"
	done
	return
}
rpm_status() {
	if [ "${rpm_package}" == "$(rpm -q "$rpm_package")" ]; then
		rpm_installed="T"
	else
		rpm_installed="F"
	fi
	return
}
rpm_fetch() {
	local i=""
	local retval=""
	local filespec=""
	#	Strip whitespace
	rpm_tarballs=${rpm_tarballs%% }
	rpm_tarballs=${rpm_tarballs## }
	rpm_md5sums=${rpm_md5sums%% }
	rpm_md5sums=${rpm_md5sums## }
	rpm_patches=${rpm_patches%% }
	rpm_patches=${rpm_patches## }
	rpm_filespec=${rpm_filespec%% }
	rpm_filespec=${rpm_filespec## }
	#	get it done
	for i in ${rpm_tarballs}; do
		msg_line "Fetching source tarball: ${i}: "
		/usr/bin/wget --no-clobber --no-check-certificate --directory-prefix=SOURCES ${i} > /dev/null 2>&1 || die "Error: ${i}"
#		/usr/bin/wget --no-clobber --no-check-certificate --directory-prefix=SOURCES ${i} || die "Error: ${i}"
		msg_success
	done
	for i in ${rpm_patches}; do
		msg "Fetching patch: ${rpm_patches}: "
		/usr/bin/wget --no-clobber --no-check-certificate --directory-prefix=SOURCES ${i} > /dev/null 2>&1 || die "Error: ${i}"
		msg_success
	done
	rpm_filespec="MD5SUM"
	if [ ! -z "${rpm_filespec}" ]; then
		> SOURCES/${rpm_filespec}
		for i in ${rpm_md5sums}; do printf "%s\n" "$(echo ${i} | tr ";" " ")" >> SOURCES/${rpm_filespec};done
		# do md5sum check
		msg "Checking source: "
		/usr/bin/md5sum -c SOURCES/${rpm_filespec} || msg_failure
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
rpm_spec=${SPECS}/$1.spec	#	rpm spec file to build
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
