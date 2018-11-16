    _pkgname="groff"
    _pkgver="1.22.3"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ PAGE=<paper_size> ./configure --prefix=/usr" "PAGE=<paper_size> ./configure --prefix=/usr" ${_logfile}
    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ make -j1" "make -j1" ${_logfile}
    build "+ make install" "make install" ${_logfile}

    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
