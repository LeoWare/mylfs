    _pkgname="attr"
    _pkgver="2.4.47"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in" "sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in" ${_logfile}
    build "+ sed -i -e \"/SUBDIRS/s|man[25]||g\" man/Makefile" "sed -i -e \"/SUBDIRS/s|man[25]||g\" man/Makefile" ${_logfile}
    build "+ sed -i 's:{(:\\{(:' test/run" "sed -i 's:{(:\\{(:' test/run" ${_logfile}

    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ make -j1 tests root-tests" "make -j1 tests root-tests" ${_logfile}
    build "+ make install install-dev install-lib" "make install install-dev install-lib" ${_logfile}
    build "+ chmod -v 755 /usr/lib/libattr.so" "chmod -v 755 /usr/lib/libattr.so" ${_logfile}
    build "+ mv -v /usr/lib/libattr.so.* /lib" "mv -v /usr/lib/libattr.so.* /lib" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so" "ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so" ${_logfile}

    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
