    _pkgname="e2fsprogs"
    _pkgver="1.43.9"
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
    build "+ LIBS=-L/tools/lib CFLAGS=-I/tools/include PKG_CONFIG_PATH=/tools/lib/pkgconfig ../${_pkgname}-${_pkgver}/configure --prefix=/usr --bindir=/bin --with-root-prefix="" --enable-elf-shlibs --disable-libblkid --disable-libuuid --disable-uuidd --disable-fsck" "LIBS=-L/tools/lib CFLAGS=-I/tools/include PKG_CONFIG_PATH=/tools/lib/pkgconfig ../${_pkgname}-${_pkgver}/configure --prefix=/usr --bindir=/bin --with-root-prefix="" --enable-elf-shlibs --disable-libblkid --disable-libuuid --disable-uuidd --disable-fsck" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ ln -sfv /tools/lib/lib{blk,uu}id.so.1 lib" "ln -sfv /tools/lib/lib{blk,uu}id.so.1 lib" ${_logfile}
    #build "+ make LD_LIBRARY_PATH=/tools/lib check" "make LD_LIBRARY_PATH=/tools/lib check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ make install-libs" "make install-libs" ${_logfile}
    build "+ chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a" "chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a" ${_logfile}
    build "+ gunzip -v /usr/share/info/libext2fs.info.gz" "gunzip -v /usr/share/info/libext2fs.info.gz" ${_logfile}
    build "+ install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info" "install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info" ${_logfile}
    build "+ makeinfo -o      ../${_pkgname}-${_pkgver}/doc/com_err.info ../${_pkgname}-${_pkgver}/lib/et/com_err.texinfo" "makeinfo -o      ../${_pkgname}-${_pkgver}/doc/com_err.info ../${_pkgname}-${_pkgver}/lib/et/com_err.texinfo" ${_logfile}
    build "+ install -v -m644 ../${_pkgname}-${_pkgver}/doc/com_err.info /usr/share/info" "install -v -m644 ../${_pkgname}-${_pkgver}/doc/com_err.info /usr/share/info" ${_logfile}
    build "+ install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info" "install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
