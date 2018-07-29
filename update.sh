#!/bin/bash
set -o errexit		# exit if error...insurance ;)
set -o nounset		# exit if variable not initalized
set +h			# disable hashall
#
#rsync -va /home/scrat/Desktop/LFS-RPM/SPECS/*	/mnt/lfs/usr/src/Octothorpe/SPECS/
#rsync -va /home/scrat/Desktop/LFS-RPM/*.sh		/mnt/lfs/usr/src/Octothorpe/

#
#chown -R lfs:lfs /mnt/lfs/usr/src/Octothorpe
#chown -R root:root /mnt/lfs/usr/src/Octothorpe

rsync -va /mnt/lfs/usr/src/Octothorpe/SPECS/*	/home/scrat/Desktop/LFS-RPM/SPECS/
rsync -va /mnt/lfs/usr/src/Octothorpe/*.sh	/home/scrat/Desktop/LFS-RPM/
