    _pkgname="acl"
    _pkgver="2.2.52"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in" "sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in" ${_logfile}
    build "+ sed -i \"s:| sed.*::g\" test/{sbits-restore,cp,misc}.test" "sed -i \"s:| sed.*::g\" test/{sbits-restore,cp,misc}.test" ${_logfile}
    build "+ sed -i 's/{(/\\{(/' test/run" "sed -i 's/{(/\\{(/' test/run" ${_logfile}
    build "+ sed -i -e \"/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);\" libacl/__acl_to_any_text.c" "sed -i -e \"/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);\" libacl/__acl_to_any_text.c" ${_logfile}

    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --libexecdir=/usr/lib" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --libexecdir=/usr/lib" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install install-dev install-lib" "make install install-dev install-lib" ${_logfile}
    build "+ chmod -v 755 /usr/lib/libacl.so" "chmod -v 755 /usr/lib/libacl.so" ${_logfile}
    build "+ mv -v /usr/lib/libacl.so.* /lib" "mv -v /usr/lib/libacl.so.* /lib" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so" "ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so" ${_logfile}

    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
