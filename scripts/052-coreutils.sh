    _pkgname="coreutils"
    _pkgver="8.29"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ patch -Np1 -i ../../SOURCES/coreutils-8.29-i18n-1.patch" "patch -Np1 -i ../../SOURCES/coreutils-8.29-i18n-1.patch" ${_logfile}
    build "+ sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk" "sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ FORCE_UNSAFE_CONFIGURE=1 ../${_pkgname}-${_pkgver}/configure --prefix=/usr --enable-no-install-program=kill,uptime" "FORCE_UNSAFE_CONFIGURE=1 ../${_pkgname}-${_pkgver}/configure --prefix=/usr --enable-no-install-program=kill,uptime" ${_logfile}
    build "+ FORCE_UNSAFE_CONFIGURE=1 make" "FORCE_UNSAFE_CONFIGURE=1 make" ${_logfile}

    build "+ make install" "make install" ${_logfile}
    build "+ mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin" "mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin" ${_logfile}
    build "+ mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin" "mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin" ${_logfile}
    build "+ mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin" "mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin" ${_logfile}
    build "+ mv -v /usr/bin/chroot /usr/sbin" "mv -v /usr/bin/chroot /usr/sbin" ${_logfile}
    build "+ mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8" "mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8" ${_logfile}
    build '+ sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8' 'sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8' ${_logfile}
    build "+ mv -v /usr/bin/{head,sleep,nice} /bin" "mv -v /usr/bin/{head,sleep,nice} /bin" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
