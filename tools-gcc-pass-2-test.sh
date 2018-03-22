#!/bin/bash
##################################################
#	Title:	tools-glibc-test.sh			#
#        Date:	2018-03-22			#
#     Version:	1.0				#
#      Author:	baho-utot@columbus.rr.com	#
#     Options:					#
##################################################
set -o errexit	# exit if error...insurance ;)
set -o nounset	# exit if variable not initalized
set +h			# disable hashall
PRGNAME=${0##*/}	# script name minus the path
TOPDIR=${PWD}		# script lives here
#		Build variables
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
#
PARENT=/usr/src/Octothorpe
LOGPATH=${TOPDIR}/LOGS
INFOPATH=${TOPDIR}/INFO
SPECPATH=${TOPDIR}/SPECS
PROVIDESPATH=${TOPDIR}/PROVIDES
REQUIRESPATH=${TOPDIR}/REQUIRES
RPMPATH=${TOPDIR}/RPMS
#
_log="${LOGPATH}/${PRGNAME}.test"
printf "%s" "	Running Check: "
echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c >> ${_log} 2>&1
readelf -l a.out | grep ': /tools' >> ${_log} 2>&1
printf "%s\n" "Output: [Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]" >> ${_log} 2>&1
rm dummy.c a.out || true
printf "%s\n" "SUCCESS"
