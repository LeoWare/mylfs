    _pkgname="flex"
    _pkgver="2.6.4"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i \"/math.h/a #include <malloc.h>\" src/flexdef.h" "sed -i \"/math.h/a #include <malloc.h>\" src/flexdef.h" ${_logfile}

    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ HELP2MAN=/tools/bin/true ../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4" "HELP2MAN=/tools/bin/true ../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ ln -sv flex /usr/bin/lex" "ln -sv flex /usr/bin/lex" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
