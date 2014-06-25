build() {
	# $1 = message 
	# $2 = command
	# $3 = log file
	local _msg="${1}"
	local _cmd="${2}"
	local _logfile="${3}"
	if [ "/dev/null" == "${_logfile}" ]; then
		msg_line "${_msg}: " && msg_success || msg_failure
		eval ${_cmd} >> ${_logfile} 2>&1
	else
		msg_line "${_msg}: "
		printf "\n%s\n\n" "###       ${_msg}       ###" >> ${_logfile} 2>&1
		eval ${_cmd} >> ${_logfile} 2>&1 && msg_success || msg_failure 
		fi
	return 0
}
unpack() {	# $1 = directory
	# $2 = source package name I'll find the suffix thank you
	local _dir=${1%%/BUILD*} # remove BUILD from path
	local i=${2}
	local p=$(echo ${_dir}/SOURCES/${i}*.tar.*)
	msg_line "	Unpacking: ${i}: "
	[ -e ${p} ] || die " File not found: FAILURE"
	tar xf ${p} && msg_success || msg_failure
	return 0
}
cmd-line() {
	# $1 = message 
	# $2 = command
	local _msg="${1}"
	local _cmd="${2}"
	msg_line "${_msg}: "
	eval ${_cmd} > /dev/null 2>&1 && msg_success || msg_failure 
	return 0

}
 
