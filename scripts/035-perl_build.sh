    _pkgname="perl"
    _pkgver="5.26.1"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ echo \"127.0.0.1 localhost $(hostname)\" > /etc/hosts" "echo \"127.0.0.1 localhost $(hostname)\" > /etc/hosts" ${_logfile}
    build "+ export BUILD_ZLIB=False" "export BUILD_ZLIB=False" ${_logfile}
    build "+ export BUILD_BZIP2=0" "export BUILD_BZIP2=0" ${_logfile}
    build "+ sh Configure -des -Dprefix=/usr -Dvendorprefix=/usr            -Dman1dir=/usr/share/man/man1 -Dman3dir=/usr/share/man/man3 -Dpager=\"/usr/bin/less -isR\" -Duseshrplib -Dusethreads" "sh Configure -des -Dprefix=/usr -Dvendorprefix=/usr            -Dman1dir=/usr/share/man/man1 -Dman3dir=/usr/share/man/man3 -Dpager=\"/usr/bin/less -isR\" -Duseshrplib -Dusethreads" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make -k test" "make -k test" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ unset BUILD_ZLIB BUILD_BZIP2" "unset BUILD_ZLIB BUILD_BZIP2" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
