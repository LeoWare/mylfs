#!/bin/bash
#-----------------------------------------------------------------------------
#	Title: gitter.sh
#	Date: 2018-09-09
#	Version: 1.0
#	Author: baho-utot@columbus.rr.com
#	Options:
#	Pushes update to github.com
#-----------------------------------------------------------------------------
set -o errexit	# exit if error...insurance ;)
set -o nounset	# exit if variable not initalized
set +h			# disable hashall
#-----------------------------------------------------------------------------
/usr/bin/git add .;/usr/bin/git commit;/usr/bin/git push
