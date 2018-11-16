    _pkgname="ncurses"
    _pkgver="6.1"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in" "sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in" ${_logfile}

    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ./configure --prefix=/usr --mandir=/usr/share/man --with-shared --without-debug --without-normal --enable-pc-files --enable-widec" "./configure --prefix=/usr --mandir=/usr/share/man --with-shared --without-debug --without-normal --enable-pc-files --enable-widec" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install" "make install" ${_logfile}
    build "+ mv -v /usr/lib/libncursesw.so.6* /lib" "mv -v /usr/lib/libncursesw.so.6* /lib" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so" "ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so" ${_logfile}
    for lib in ncurses form panel menu ; do
        build "+ rm -vf /usr/lib/lib${lib}.so" "rm -vf /usr/lib/lib${lib}.so" ${_logfile}
        build "+ echo 'INPUT(-l${lib}w)' > /usr/lib/lib${lib}.so" "echo 'INPUT(-l${lib}w)' > /usr/lib/lib${lib}.so" ${_logfile}
        build "+ ln -sfv ${lib}w.pc /usr/lib/pkgconfig/${lib}.pc" "ln -sfv ${lib}w.pc /usr/lib/pkgconfig/${lib}.pc" ${_logfile}
    done
    build "+ rm -vf                     /usr/lib/libcursesw.so" "rm -vf                     /usr/lib/libcursesw.so" ${_logfile}
    build "+ echo 'INPUT(-lncursesw)' > /usr/lib/libcursesw.so" "echo 'INPUT(-lncursesw)' > /usr/lib/libcursesw.so" ${_logfile}
    build "+ ln -sfv libncurses.so      /usr/lib/libcurses.so" "ln -sfv libncurses.so      /usr/lib/libcurses.so" ${_logfile}
    build "+ mkdir -v       /usr/share/doc/ncurses-6.1" "mkdir -v       /usr/share/doc/ncurses-6.1" ${_logfile}
    build "+ cp -v -R doc/* /usr/share/doc/ncurses-6.1" "cp -v -R doc/* /usr/share/doc/ncurses-6.1" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
