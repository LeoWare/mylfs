    _pkgname="bc"
    _pkgver="1.07.1"
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

    build " Change script to use sed" "" ${_logfile}
    cat > ../${_pkgname}-${_pkgver}/bc/fix-libmath_h << "EOF"
#! /bin/bash
sed -e '1   s/^/{"/' \
    -e     's/$/",/' \
    -e '2,$ s/^/"/'  \
    -e   '$ d'       \
    -i libmath.h

sed -e '$ s/$/0}/' \
    -i libmath.h
EOF
    build "+ ln -sfv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6" "ln -sfv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6" ${_logfile}
    build "+ ln -sfv libncurses.so.6 /usr/lib/libncurses.so" "ln -sfv libncurses.so.6 /usr/lib/libncurses.so" ${_logfile}
    build "+ sed -i -e '/flex/s/as_fn_error/: ;; # &/' ../${_pkgname}-${_pkgver}/configure" "sed -i -e '/flex/s/as_fn_error/: ;; # &/' ../${_pkgname}-${_pkgver}/configure" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --with-readline --mandir=/usr/share/man --infodir=/usr/share/info" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --with-readline --mandir=/usr/share/man --infodir=/usr/share/info" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ echo \"quit\" | ./bc/bc -l Test/checklib.b" "echo \"quit\" | ./bc/bc -l Test/checklib.b" ${_logfile}
    build "+ make install" "make install" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
