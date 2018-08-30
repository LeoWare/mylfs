#!/bin/bash
set -o errexit
set -o nounset
set +h

source config.inc
source function.inc

_red="\\033[1;31m"
_green="\\033[1;32m"
_normal="\\033[1;39m"

# Build the LFS System

msg_section "Building LFS 8.2-systemd"

msg_success
msg_success "Message"
msg_warning
msg_warning "Message"
msg_failure

exit 0
msg_line "Checking for ${LFS}/tools: "
if [[ -d ${LFS} ]]; then
	msg_success "FOUND"
else
	msg_warning "NOT FOUND"
	build "Creating ${LFS}/tools: " "mkdir -pv ${LFS}/tools" ${LOGFILE}
fi

msg_line "Creating symlink for /tools: " 
if [[ -h "${LFS}/tools" ]]; then
	build "ln -sv $LFS/tools /" "ln -sv $LFS/tools /" ${LOGFILE}
else
	msg_warning "SKIPPING"
fi

msg_line "Creating user '${LFS_USER}': "
build "groupadd lfs" "groupadd lfs" ${LOGFILE}

