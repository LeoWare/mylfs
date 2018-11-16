    _pkgname="openssl"
    _pkgver="1.1.0g"
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
    build "+ ../${_pkgname}-${_pkgver}/config --prefix=/usr --openssldir=/etc/ssl --libdir=lib shared zlib-dynamic" "../${_pkgname}-${_pkgver}/config --prefix=/usr --openssldir=/etc/ssl --libdir=lib shared zlib-dynamic" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile" "sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile" ${_logfile}
    build "+ make MANSUFFIX=ssl install" "make MANSUFFIX=ssl install" ${_logfile}
    build "+ mv -v /usr/share/doc/openssl /usr/share/doc/${_pkgname}-${_pkgver}" "mv -v /usr/share/doc/openssl /usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build "+ cp -vfr doc/* /usr/share/doc/${_pkgname}-${_pkgver}" "cp -vfr doc/* /usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
