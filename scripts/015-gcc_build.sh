    _pkgname="gcc"
    _pkgver="7.3.0"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    case $(uname -m) in
      x86_64)
        build "+ sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64" "sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64" ${_logfile}
      ;;
    esac
    [ -h "/usr/lib/gcc" ] && build "+ rm -fv /usr/lib/gcc" "rm -fv /usr/lib/gcc" ${_logfile}

    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}


    build "+ SED=sed ../${_pkgname}-${_pkgver}/configure --prefix=/usr --enable-languages=c,c++ --disable-multilib --disable-bootstrap --with-system-zlib" "SED=sed ../${_pkgname}-${_pkgver}/configure --prefix=/usr --enable-languages=c,c++ --disable-multilib --disable-bootstrap --with-system-zlib" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ ulimit -s 32768" "ulimit -s 32768" ${_logfile}
    #build "+ make -k check" "make -k check" ${_logfile}
    #build "+ ../${_pkgname}-${_pkgver}/contrib/test_summary" "../${_pkgname}-${_pkgver}/contrib/test_summary" ${_logfile}
    build "+ make install" "make install" ${_logfile}

    build "+ ln -sfv ../usr/bin/cpp /lib" "ln -sfv ../usr/bin/cpp /lib" ${_logfile}
    build "+ ln -sfv gcc /usr/bin/cc" "ln -sfv gcc /usr/bin/cc" ${_logfile}
    build "+ install -v -dm755 /usr/lib/bfd-plugins" "install -v -dm755 /usr/lib/bfd-plugins" ${_logfile}
    build "+ ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/7.3.0/liblto_plugin.so /usr/lib/bfd-plugins/" "ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/7.3.0/liblto_plugin.so /usr/lib/bfd-plugins/" ${_logfile}
    
    build "+ echo 'int main(){}' > dummy.c" "echo 'int main(){}' > dummy.c" ${_logfile}
    build "+ cc dummy.c -v -Wl,--verbose &> dummy.log" "cc dummy.c -v -Wl,--verbose &> dummy.log" ${_logfile}
    build "+ readelf -l a.out | grep ': /lib'" "readelf -l a.out | grep ': /lib'" ${_logfile}
    build "+ grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log" "grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log" ${_logfile}
    build "+ grep -B4 '^ /usr/include' dummy.log" "grep -B4 '^ /usr/include' dummy.log" ${_logfile}
    build "+ grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'" "grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'" ${_logfile}
    build "+ grep \"/lib.*/libc.so.6 \" dummy.log" "grep \"/lib.*/libc.so.6 \" dummy.log" ${_logfile}
    build "+ grep found dummy.log" "grep found dummy.log" ${_logfile}
    build "+ rm -v dummy.c a.out dummy.log" "rm -v dummy.c a.out dummy.log" ${_logfile}
    build "+ mkdir -pv /usr/share/gdb/auto-load/usr/lib" "mkdir -pv /usr/share/gdb/auto-load/usr/lib" ${_logfile}
    build "+ mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib" "mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
