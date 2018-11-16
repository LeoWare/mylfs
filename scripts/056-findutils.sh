    _pkgname="findutils"
    _pkgver="4.6.0"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in" "sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --localstatedir=/var/lib/locate" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --localstatedir=/var/lib/locate" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ mv -v /usr/bin/find /bin" "mv -v /usr/bin/find /bin" ${_logfile}
    build "+ sed -i 's|find:=\${BINDIR}|find:=/bin|' /usr/bin/updatedb" "sed -i 's|find:=\${BINDIR}|find:=/bin|' /usr/bin/updatedb" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
