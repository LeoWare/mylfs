    _pkgname="xz"
    _pkgver="5.2.3"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --docdir=/usr/share/doc/${_pkgname}-${_pkgver}" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --docdir=/usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ " "" ${_logfile}
    build "+ mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin" "mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin" ${_logfile}
    build "+ mv -v /usr/lib/liblzma.so.* /lib" "mv -v /usr/lib/liblzma.so.* /lib" ${_logfile}
    build "+ ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so" "ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
