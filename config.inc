 #	Editable variables follow
LFS=/mnt/lfs			# where to build this animal
PARENT="/usr/src/Octothorpe"	# where build syetm lives
MKFLAGS="-j $(getconf _NPROCESSORS_ONLN)"	# how many processors on this host
#	Edit partition and mnt_point for the correct values.
#	Failing to do so will cause you grief as in overwriting your host system.
#	You have been warned!
DEVICE=sdb3			#	device to create filesystem on
FILESYSTEM=ext4			#	filesystem type
LOGFILE="$(date +%Y-%m-%d).log"	#	this is where we log the build to 
