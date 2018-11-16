    _pkgname="readline"
    _pkgver="7.0"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i '/MV.*old/d' Makefile.in" "sed -i '/MV.*old/d' Makefile.in" ${_logfile}
    build "+ sed -i '/{OLDSUFF}/c:' support/shlib-install" "sed -i '/{OLDSUFF}/c:' support/shlib-install" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}

    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --docdir=/usr/share/doc/readline-7.0" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --docdir=/usr/share/doc/readline-7.0" ${_logfile}
    build "+ make SHLIB_LIBS=\"-L/tools/lib -lncursesw\"" "make SHLIB_LIBS=\"-L/tools/lib -lncursesw\"" ${_logfile}

    build "+ make SHLIB_LIBS=\"-L/tools/lib -lncurses\" install" "make SHLIB_LIBS=\"-L/tools/lib -lncurses\" install" ${_logfile}
    build "+ mv -v /usr/lib/lib{readline,history}.so.* /lib" "mv -v /usr/lib/lib{readline,history}.so.* /lib" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so" "ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so" "ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so" ${_logfile}
    build "+ install -v -m644 ../${_pkgname}-${_pkgver}doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-7.0" "install -v -m644 ../${_pkgname}-${_pkgver}doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-7.0" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}
readline_build() {
    _pkgname="readline"
    _pkgver="7.0"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i '/MV.*old/d' Makefile.in" "sed -i '/MV.*old/d' Makefile.in" ${_logfile}
    build "+ sed -i '/{OLDSUFF}/c:' support/shlib-install" "sed -i '/{OLDSUFF}/c:' support/shlib-install" ${_logfile}
    build "+ ./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/${_pkgname}-${_pkgver}" "./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build "+ make SHLIB_LIBS='-lncursesw'" "make SHLIB_LIBS='-lncursesw'" ${_logfile}
    build "+ make SHLIB_LIBS='-lncurses' install" "make SHLIB_LIBS='-lncurses' install" ${_logfile}
    build "+ mv -v /usr/lib/lib{readline,history}.so.* /lib" "mv -v /usr/lib/lib{readline,history}.so.* /lib" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so" "ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so" "ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so" ${_logfile}
    build "+ install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/${_pkgname}-${_pkgver}" "install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build "+ " "" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
