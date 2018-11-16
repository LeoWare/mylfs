    _pkgname="sed"
    _pkgver="4.4"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i 's/usr/tools/'                 build-aux/help2man" "sed -i 's/usr/tools/'                 build-aux/help2man" ${_logfile}
    build "+ sed -i 's/testsuite.panic-tests.sh//' Makefile.in" "sed -i 's/testsuite.panic-tests.sh//' Makefile.in" ${_logfile}

    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --bindir=/bin" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --bindir=/bin" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make html" "make html" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ install -d -m755           /usr/share/doc/sed-4.4" "install -d -m755           /usr/share/doc/sed-4.4" ${_logfile}
    build "+ install -m644 doc/sed.html /usr/share/doc/sed-4.4" "install -m644 doc/sed.html /usr/share/doc/sed-4.4" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
