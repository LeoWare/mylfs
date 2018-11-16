    _pkgname="linux"
    _pkgver="4.15.3"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}


    build "+ make mrproper" "make mrproper" ${_logfile}

    build "+ make INSTALL_HDR_PATH=dest headers_install" "make INSTALL_HDR_PATH=dest headers_install" ${_logfile}
    build "+ find dest/include \( -name .install -o -name ..install.cmd \) -delete" "find dest/include \( -name .install -o -name ..install.cmd \) -delete" ${_logfile}
    build "+ cp -rv dest/include/* /usr/include" "cp -rv dest/include/* /usr/include" ${_logfile}


    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
