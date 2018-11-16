    _pkgname="expat"
    _pkgver="2.2.5"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i 's|usr/bin/env |bin/|' run.sh.in" "sed -i 's|usr/bin/env |bin/|' run.sh.in" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ install -v -dm755 /usr/share/doc/${_pkgname}-${_pkgver}" "install -v -dm755 /usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build "+ install -v -m644 ../${_pkgname}-${_pkgver}/doc/*.{html,png,css} /usr/share/doc/${_pkgname}-${_pkgver}" "install -v -m644 ../${_pkgname}-${_pkgver}/doc/*.{html,png,css} /usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
