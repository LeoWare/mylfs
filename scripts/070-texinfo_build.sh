    _pkgname="texinfo"
    _pkgver="6.5"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ pushd /usr/share/info" "pushd /usr/share/info" ${_logfile}
    build "+ rm -v dir" "rm -v dir" ${_logfile}
    for f in *; do
    build "+     install-info $f dir 2>/dev/null" "    install-info $f dir 2>/dev/null" ${_logfile}
    done
    build "+ popd" "popd" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
