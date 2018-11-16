    _pkgname="gettext"
    _pkgver="0.19.8.1"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in" "sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in" ${_logfile}
    build "+ sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in" "sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --docdir=/usr/share/doc/${_pkgname}-${_pkgver}" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --docdir=/usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ chmod -v 0755 /usr/lib/preloadable_libintl.so" "chmod -v 0755 /usr/lib/preloadable_libintl.so" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
