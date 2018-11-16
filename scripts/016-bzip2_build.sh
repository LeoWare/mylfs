    _pkgname="bzip2"
    _pkgver="1.0.6"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}

    build "+ patch -Np1 -i ../../SOURCES/bzip2-1.0.6-install_docs-1.patch" "patch -Np1 -i ../../SOURCES/bzip2-1.0.6-install_docs-1.patch" ${_logfile}
    build "+ sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile" "sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile" ${_logfile}
    build "+ sed -i \"s@(PREFIX)/man@(PREFIX)/share/man@g\" Makefile" "sed -i \"s@(PREFIX)/man@(PREFIX)/share/man@g\" Makefile" ${_logfile}
    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}

   
    build "+ make -f Makefile-libbz2_so" "make -f Makefile-libbz2_so" ${_logfile}
    build "+ make clean" "make clean" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make PREFIX=/usr install" "make PREFIX=/usr install" ${_logfile}
    build "+ cp -v bzip2-shared /bin/bzip2" "cp -v bzip2-shared /bin/bzip2" ${_logfile}
    build "+ cp -av libbz2.so* /lib" "cp -av libbz2.so* /lib" ${_logfile}
    build "+ ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so" "ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so" ${_logfile}
    build "+ rm -v /usr/bin/{bunzip2,bzcat,bzip2}" "rm -v /usr/bin/{bunzip2,bzcat,bzip2}" ${_logfile}
    build "+ ln -sv bzip2 /bin/bunzip2" "ln -sv bzip2 /bin/bunzip2" ${_logfile}
    build "+ ln -sv bzip2 /bin/bzcat" "ln -sv bzip2 /bin/bzcat" ${_logfile}

    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
