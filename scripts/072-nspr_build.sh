    _pkgname="nspr"
    _pkgver="4.18"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ cd nspr" "cd nspr" ${_logfile}
    build "+ sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in" "sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in" ${_logfile}
    build "+ sed -i 's#\$(LIBRARY) ##'            config/rules.mk" "sed -i 's#\$(LIBRARY) ##'            config/rules.mk" ${_logfile}
    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ./configure --prefix=/usr --with-mozilla --with-pthreads $([ $(uname -m) = x86_64 ] && echo --enable-64bit)" "./configure --prefix=/usr --with-mozilla --with-pthreads $([ $(uname -m) = x86_64 ] && echo --enable-64bit)" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install" "make install" ${_logfile}

    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
