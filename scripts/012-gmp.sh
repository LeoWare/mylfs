    _pkgname="gmp"
    _pkgver="6.1.2"
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

    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --enable-cxx --disable-static --docdir=/usr/share/doc/gmp-6.1.2" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --enable-cxx --disable-static --docdir=/usr/share/doc/gmp-6.1.2" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make html" "make html" ${_logfile}
    build "+ make check 2>&1 | tee gmp-check-log" "make check 2>&1 | tee gmp-check-log" ${_logfile}
    build "+ awk '/# PASS:/{total+=\$3} ; END{print total}' gmp-check-log" "awk '/# PASS:/{total+=\$3} ; END{print total}' gmp-check-log" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ make install-html" "make install-html" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
