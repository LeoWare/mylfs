#!/bin/bash
set -o errexit	# exit if error...insurance ;)
set -o nounset	# exit if variable not initalized
set +h			# disable hashall
PARENT=/mnt/lfs/usr/src/LFS-RPM
TARGET=/home/scrat/Desktop/LFS-RPM
rsync -va ${PARENT}/SPECS/*	${TARGET}/SPECS/
rsync -va ${PARENT}/*.sh	${TARGET}/
