    _pkgname="libcap"
    _pkgver="2.25"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i '/install.STALIBNAME/d' libcap/Makefile" "sed -i '/install.STALIBNAME/d' libcap/Makefile" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make RAISE_SETFCAP=no lib=lib prefix=/usr install" "make RAISE_SETFCAP=no lib=lib prefix=/usr install" ${_logfile}
    build "+ chmod -v 755 /usr/lib/libcap.so" "chmod -v 755 /usr/lib/libcap.so" ${_logfile}
    build "+ mv -v /usr/lib/libcap.so.* /lib" "mv -v /usr/lib/libcap.so.* /lib" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so" "ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
