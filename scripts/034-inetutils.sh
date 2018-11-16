    _pkgname="inetutils"
    _pkgver="1.9.4"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --localstatedir=/var --disable-logger --disable-whois --disable-rcp --disable-rexec --disable-rlogin --disable-rsh --disable-servers" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --localstatedir=/var --disable-logger --disable-whois --disable-rcp --disable-rexec --disable-rlogin --disable-rsh --disable-servers" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin" "mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin" ${_logfile}
    build "+ mv -v /usr/bin/ifconfig /sbin" "mv -v /usr/bin/ifconfig /sbin" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
