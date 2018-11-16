    _pkgname="bash"
    _pkgver="4.4.18"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/bash-4.4.18 --without-bash-malloc --with-installed-readline" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/bash-4.4.18 --without-bash-malloc --with-installed-readline" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ chown -Rv nobody ../build ../${_pkgname}-${_pkgver}" "chown -Rv nobody ../build ../${_pkgname}-${_pkgver}" ${_logfile}
    #build "+ su nobody -s /bin/bash -c \"PATH=$PATH make tests\"" "su nobody -s /bin/bash -c \"PATH=$PATH make tests\"" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ mv -vf /usr/bin/bash /bin" "mv -vf /usr/bin/bash /bin" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
