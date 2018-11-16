    _pkgname="procps-ng"
    _pkgver="3.3.12"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}

    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --exec-prefix= --libdir=/usr/lib --docdir=/usr/share/doc/${_pkgname}-${_pkgver} --disable-static --disable-kill --with-systemd" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --exec-prefix= --libdir=/usr/lib --docdir=/usr/share/doc/${_pkgname}-${_pkgver} --disable-static --disable-kill --with-systemd" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp" "sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp" ${_logfile}
    #build "+ sed -i '/set tty/d' testsuite/pkill.test/pkill.exp" "sed -i '/set tty/d' testsuite/pkill.test/pkill.exp" ${_logfile}
    #build "+ rm testsuite/pgrep.test/pgrep.exp" "rm testsuite/pgrep.test/pgrep.exp" ${_logfile}
    #build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ mv -v /usr/lib/libprocps.so.* /lib" "mv -v /usr/lib/libprocps.so.* /lib" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so" "ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
