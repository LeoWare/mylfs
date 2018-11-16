    _pkgname="nss"
    _pkgver="3.35"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ patch -Np1 -i ../../SOURCES/nss-3.35-standalone-1.patch" "patch -Np1 -i ../../SOURCES/nss-3.35-standalone-1.patch" ${_logfile}
    build "+ cd nss" "cd nss" ${_logfile}
    build "+ make -j1 BUILD_OPT=1 NSPR_INCLUDE_DIR=/usr/include/nspr USE_SYSTEM_ZLIB=1 ZLIB_LIBS=-lz NSS_ENABLE_WERROR=0 $([ $(uname -m) = x86_64 ] && echo USE_64=1) $([ -f /usr/include/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1)" "make -j1 BUILD_OPT=1 NSPR_INCLUDE_DIR=/usr/include/nspr USE_SYSTEM_ZLIB=1 ZLIB_LIBS=-lz NSS_ENABLE_WERROR=0 $([ $(uname -m) = x86_64 ] && echo USE_64=1) $([ -f /usr/include/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1)" ${_logfile}
    build "+ cd ../dist" "cd ../dist" ${_logfile}
    build "+ install -v -m755 Linux*/lib/*.so /usr/lib" "install -v -m755 Linux*/lib/*.so /usr/lib" ${_logfile}
    build "+ install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /usr/lib" "install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /usr/lib" ${_logfile}
    build "+ install -v -m755 -d /usr/include/nss" "install -v -m755 -d /usr/include/nss" ${_logfile}
    build "+ cp -v -RL {public,private}/nss/* /usr/include/nss" "cp -v -RL {public,private}/nss/* /usr/include/nss" ${_logfile}
    build "+ chmod -v 644 /usr/include/nss/*" "chmod -v 644 /usr/include/nss/*" ${_logfile}
    build "+ install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /usr/bin" "install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /usr/bin" ${_logfile}
    build "+ install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib/pkgconfig" "install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib/pkgconfig" ${_logfile}
    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}




    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
