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
git add .;git commit;git push
