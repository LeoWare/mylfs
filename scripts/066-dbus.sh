    _pkgname="dbus"
    _pkgver="1.12.4"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static --disable-doxygen-docs --disable-xml-docs --docdir=/usr/share/doc/dbus-1.12.4 --with-console-auth-dir=/run/console" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static --disable-doxygen-docs --disable-xml-docs --docdir=/usr/share/doc/dbus-1.12.4 --with-console-auth-dir=/run/console" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install" "make install" ${_logfile}
    build "+ mv -v /usr/lib/libdbus-1.so.* /lib" "mv -v /usr/lib/libdbus-1.so.* /lib" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libdbus-1.so) /usr/lib/libdbus-1.so" "ln -sfv ../../lib/$(readlink /usr/lib/libdbus-1.so) /usr/lib/libdbus-1.so" ${_logfile}
    build "+ ln -sfv /etc/machine-id /var/lib/dbus" "ln -sfv /etc/machine-id /var/lib/dbus" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
