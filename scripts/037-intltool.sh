    _pkgname="intltool"
    _pkgver="0.51.0"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i 's:\\\${:\\\$\\{:' intltool-update.in" "sed -i 's:\\\${:\\\$\\{:' intltool-update.in" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ install -v -Dm644 ../${_pkgname}-${_pkgver}/doc/I18N-HOWTO /usr/share/doc/${_pkgname}-${_pkgver}/I18N-HOWTO" "install -v -Dm644 ../${_pkgname}-${_pkgver}/doc/I18N-HOWTO /usr/share/doc/${_pkgname}-${_pkgver}/I18N-HOWTO" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
