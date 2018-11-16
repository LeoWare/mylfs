    _pkgname="kmod"
    _pkgver="25"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --bindir=/bin --sysconfdir=/etc --with-rootlibdir=/lib --with-xz --with-zlib" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --bindir=/bin --sysconfdir=/etc --with-rootlibdir=/lib --with-xz --with-zlib" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install" "make install" ${_logfile}
    for target in depmod insmod lsmod modinfo modprobe rmmod; do
        build "+ ln -sfv ../bin/kmod /sbin/$target" "ln -sfv ../bin/kmod /sbin/$target" ${_logfile}
    done
    build "+ ln -sfv kmod /bin/lsmod" "ln -sfv kmod /bin/lsmod" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
