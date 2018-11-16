    _pkgname="iproute2"
    _pkgver="4.15.0"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i /ARPD/d Makefile" "sed -i /ARPD/d Makefile" ${_logfile}
    build "+ rm -fv man/man8/arpd.8" "rm -fv man/man8/arpd.8" ${_logfile}
    build "+ sed -i 's/m_ipt.o//' tc/Makefile" "sed -i 's/m_ipt.o//' tc/Makefile" ${_logfile}
    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make DOCDIR=/usr/share/doc/${_pkgname}-${_pkgver} install" "make DOCDIR=/usr/share/doc/${_pkgname}-${_pkgver} install" ${_logfile}

    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
