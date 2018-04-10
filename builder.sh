#!/bin/bash
##################################################
#	Title:	builder.sh				#
#        Date:	2018-04-04			#
#     Version:	1.0				#
#      Author:	baho-utot@columbus.rr.com	#
#     Options:					#
##################################################
PRGNAME=${0##*/}			# script name minus the path
TOPDIR=${PWD}				# parent directory
PARENT=/usr/src/Octothorpe	# rpm build directory
LOGS=LOGS					# build logs directory
INFOS=INFO				# rpm info log directory
SPECS=SPECS				# rpm spec file directory
PROVIDES=PROVIDES			# rpm provides log directory
REQUIRES=REQUIRES			# rpm requires log directory
RPMS=RPMS					# rpm binary package directory
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
end_run() {
	local _green="\\033[1;32m"
	local _normal="\\033[0;39m"
	printf "${_green}%s${_normal}\n" "Run Complete - ${rpm_name}"
	return
}
#
#	Variables
#
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
#
#	Funcions
#
rpm_params() {
	local i=""
	rpm_arch=$(uname -m)
	if [ -e ${rpm_spec} ]; then
		while  read i; do
			i=$(echo ${i} | tr -d '[:cntrl:][:space:]')
			case ${i} in
				Name:*)			rpm_name=${i##Name:}				;;
				Version:*)		rpm_version=${i##Version:}			;;
				Release:*)		rpm_release=${i##Release:}			;;
				BuildRequires:*)	rpm_requires+="${i##BuildRequires:} "	;;
				*)												;;
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
rpm_install() {
	local _log="${LOGS}/${rpm_name}"
	msg_line "Installing: ${rpm_binary}: "
	rpm -Uvh --nodeps --force "${RPMS}/${rpm_arch}/${rpm_binary}" >> "${_log}" 2>&1  && msg_success || msg_failure
	return
}
rpm_build() {
	local _log="${LOGS}/${rpm_name}"
	msg_line "Building: ${rpm_name}: "
	> ${_log}
	> ${INFOS}/${rpm_name}
	> ${PROVIDES}/${rpm_name}
	> ${REQUIRES}/${rpm_name}
	rm -rf BUILD BUILDROOT
	rpmbuild -ba ${rpm_spec}	>> ${_log} 2>&1	 && msg_success || die "ERROR: ${rpm_binary}"
	rpm_exists
	if [ "F" == ${rpm_exists} ]; then
		die "ERROR: ${rpm_binary}"
	fi
	rpm -qilp 		${RPMS}/${rpm_arch}/${rpm_binary} > ${INFOS}/${rpm_name}	2>&1 || true
	rpm -qp --provides	${RPMS}/${rpm_arch}/${rpm_binary} > ${PROVIDES}/${rpm_name}	2>&1 || true
	rpm -qp --requires	${RPMS}/${rpm_arch}/${rpm_binary} > ${REQUIRES}/${rpm_name}	2>&1 || true
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
#
#	Main line
#
if [ -z "$1" ]; then
  echo "Usage: builder.sh <filespec>"
  exit -1
fi
set -o errexit		# exit if error...insurance ;)
set -o nounset		# exit if variable not initalized
set +h			# disable hashall
#
#	Create directories if needed
#
[ -e "${LOGS}" ]		||	install -vdm 755 "${LOGS}"
[ -e "${INFOS}" ]		||	install -vdm 755 "${INFOS}"
[ -e "${SPECS}" ]		||	install -vdm 755 "${SPECS}"
[ -e "${PROVIDES}" ]	||	install -vdm 755 "${PROVIDES}"
[ -e "${REQUIRES}" ]	||	install -vdm 755 "${REQUIRES}"
[ -e "${RPMS}" ]		||	install -vdm 755 "${RPMS}"
rpm_spec=${SPECS}/$1.spec	# rpm spec file to build
rpm_params				# get status
printf "\n%s\n" "Status for ${rpm_binary}"
msg "Spec-------->	${rpm_spec}"
msg "Name-------->	${rpm_name}"
msg "Version----->	${rpm_version}"
msg "Release----->	${rpm_release}"
msg "Arch-------->	${rpm_arch}"
msg "Requires---->	${rpm_requires}"
msg "Installed--->	${rpm_installed}"
msg "Package----->	${rpm_package}"
msg "Binary------>	${rpm_binary}"
msg "Exists------>	${rpm_exists}"
#
#	Build dependencies and install if needed
#
rpm_depends
if [ "F" == "${rpm_exists}" ]; then
	rpm_build
fi
if [ "F" == "${rpm_installed}" ]; then
	rpm_install
fi
end_run
