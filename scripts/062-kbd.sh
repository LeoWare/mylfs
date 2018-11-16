    _pkgname="kbd"
    _pkgver="2.0.4"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ patch -Np1 -i ../../SOURCES/kbd-2.0.4-backspace-1.patch" "patch -Np1 -i ../../SOURCES/kbd-2.0.4-backspace-1.patch" ${_logfile}
    build "+ sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure" "sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure" ${_logfile}
    build "+ sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in" "sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ PKG_CONFIG_PATH=/tools/lib/pkgconfig ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-vlock" "PKG_CONFIG_PATH=/tools/lib/pkgconfig ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-vlock" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ mkdir -v /usr/share/doc/${_pkgname}-${_pkgver}" "mkdir -v /usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build "+ cp -R -v ../${_pkgname}-${_pkgver}/docs/doc/* /usr/share/doc/${_pkgname}-${_pkgver}" "cp -R -v ../${_pkgname}-${_pkgver}/docs/doc/* /usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
