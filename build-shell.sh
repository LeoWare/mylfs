#!/tools/bin/bash
set -o errexit
set -o nounset
set +h
source ./config.inc
source ./function.inc

change_ownership() {
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
    > ${_logfile}
    build " chown -R root:root $LFS/tools" "chown -R root:root /mnt/lfs/tools" ${_logfile}
    >  ${_complete}
    return 0
}

linux_api_headers() {
    local   _pkgname="linux_api_headers"
    local   _pkgver="4.15.3"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
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


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

man_pages() {
    local   _pkgname="man_pages"
    local   _pkgver="4.15"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}




    build "+ make install" "make install" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

glibc() {
    local   _pkgname="glibc"
    local   _pkgver="2.27"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}

    build "+ patch -Np1 -i ../../SOURCES/glibc-2.27-fhs-1.patch" "patch -Np1 -i ../../SOURCES/glibc-2.27-fhs-1.patch" ${_logfile}
    build "+ ln -sfv /tools/lib/gcc /usr/lib" "ln -sfv /tools/lib/gcc /usr/lib" ${_logfile}
    case $(uname -m) in
        i?86)   build "+ GCC_INCDIR=/usr/lib/gcc/$(uname -m)-pc-linux-gnu/7.3.0/include" "GCC_INCDIR=/usr/lib/gcc/$(uname -m)-pc-linux-gnu/7.3.0/include" ${_logfile}
                build "+ ln -sfv ld-linux.so.2 /lib/ld-lsb.so.3" "ln -sfv ld-linux.so.2 /lib/ld-lsb.so.3" ${_logfile}
        ;;
        x86_64) GCC_INCDIR=/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/include
                build "ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64" "ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64" ${_logfile}
                build "ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3" "ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3" ${_logfile}}
        ;;
    esac
    build "+ rm -f /usr/include/limits.h" "rm -f /usr/include/limits.h" ${_logfile}
    build "+ CC="gcc -isystem $GCC_INCDIR -isystem /usr/include" ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-werror --enable-kernel=3.2 --enable-stack-protector=strong libc_cv_slibdir=/lib" "CC="gcc -isystem $GCC_INCDIR -isystem /usr/include" ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-werror --enable-kernel=3.2 --enable-stack-protector=strong libc_cv_slibdir=/lib" ${_logfile}
    build "+ unset GCC_INCDIR" "unset GCC_INCDIR" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ touch /etc/ld.so.conf" "touch /etc/ld.so.conf" ${_logfile}
    build "+ sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile" "sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile" ${_logfile}
    build "+ cp -v ../nscd/nscd.conf /etc/nscd.conf" "cp -v ../nscd/nscd.conf /etc/nscd.conf" ${_logfile}
    build "+ mkdir -pv /var/cache/nscd" "mkdir -pv /var/cache/nscd" ${_logfile}
    build "+ install -v -Dm644 ../nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf" "install -v -Dm644 ../nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf" ${_logfile}
    build "+ install -v -Dm644 ../nscd/nscd.service /lib/systemd/system/nscd.service" "install -v -Dm644 ../nscd/nscd.service /lib/systemd/system/nscd.service" ${_logfile}
    build "+ " "" ${_logfile}
    build "+ mkdir -pv /usr/lib/locale" "mkdir -pv /usr/lib/locale" ${_logfile}
    build "+ localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8" "localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8" ${_logfile}
    build "+ localedef -i de_DE -f ISO-8859-1 de_DE" "localedef -i de_DE -f ISO-8859-1 de_DE" ${_logfile}
    build "+ localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro" "localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro" ${_logfile}
    build "+ localedef -i de_DE -f UTF-8 de_DE.UTF-8" "localedef -i de_DE -f UTF-8 de_DE.UTF-8" ${_logfile}
    build "+ localedef -i en_GB -f UTF-8 en_GB.UTF-8" "localedef -i en_GB -f UTF-8 en_GB.UTF-8" ${_logfile}
    build "+ localedef -i en_HK -f ISO-8859-1 en_HK" "localedef -i en_HK -f ISO-8859-1 en_HK" ${_logfile}
    build "+ localedef -i en_PH -f ISO-8859-1 en_PH" "localedef -i en_PH -f ISO-8859-1 en_PH" ${_logfile}
    build "+ localedef -i en_US -f ISO-8859-1 en_US" "localedef -i en_US -f ISO-8859-1 en_US" ${_logfile}
    build "+ localedef -i en_US -f UTF-8 en_US.UTF-8" "localedef -i en_US -f UTF-8 en_US.UTF-8" ${_logfile}
    build "+ localedef -i es_MX -f ISO-8859-1 es_MX" "localedef -i es_MX -f ISO-8859-1 es_MX" ${_logfile}
    build "+ localedef -i fa_IR -f UTF-8 fa_IR" "localedef -i fa_IR -f UTF-8 fa_IR" ${_logfile}
    build "+ localedef -i fr_FR -f ISO-8859-1 fr_FR" "localedef -i fr_FR -f ISO-8859-1 fr_FR" ${_logfile}
    build "+ localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro" "localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro" ${_logfile}
    build "+ localedef -i fr_FR -f UTF-8 fr_FR.UTF-8" "localedef -i fr_FR -f UTF-8 fr_FR.UTF-8" ${_logfile}
    build "+ localedef -i it_IT -f ISO-8859-1 it_IT" "localedef -i it_IT -f ISO-8859-1 it_IT" ${_logfile}
    build "+ localedef -i it_IT -f UTF-8 it_IT.UTF-8" "localedef -i it_IT -f UTF-8 it_IT.UTF-8" ${_logfile}
    build "+ localedef -i ja_JP -f EUC-JP ja_JP" "localedef -i ja_JP -f EUC-JP ja_JP" ${_logfile}
    build "+ localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R" "localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R" ${_logfile}
    build "+ localedef -i ru_RU -f UTF-8 ru_RU.UTF-8" "localedef -i ru_RU -f UTF-8 ru_RU.UTF-8" ${_logfile}
    build "+ localedef -i tr_TR -f UTF-8 tr_TR.UTF-8" "localedef -i tr_TR -f UTF-8 tr_TR.UTF-8" ${_logfile}
    build "+ localedef -i zh_CN -f GB18030 zh_CN.GB18030" "localedef -i zh_CN -f GB18030 zh_CN.GB18030" ${_logfile}
    build "+ make localedata/install-locales" "make localedata/install-locales" ${_logfile}
    build " Adding nsswitch.conf" "" ${_logfile}
    cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF
    build " Adding time zone data" "make" ${_logfile}
    tar -xf ../../tzdata2018c.tar.gz

    ZONEINFO=/usr/share/zoneinfo
    mkdir -pv $ZONEINFO/{posix,right}

    for tz in etcetera southamerica northamerica europe africa antarctica  \
              asia australasia backward pacificnew systemv; do
        zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}
        zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
        zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
    done

    cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
    zic -d $ZONEINFO -p America/New_York
    unset ZONEINFO

    ln -sfv /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

    build " Adding /etc/ld.so.conf" "" ${_logfile}
    cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF
    cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
    mkdir -pv /etc/ld.so.conf.d
}

adjust_toolchain() {
    mv -v /tools/bin/{ld,ld-old}
    mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
    mv -v /tools/bin/{ld-new,ld}
    ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld
    gcc -dumpspecs | sed -e 's@/tools@@g'                   \
        -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
        -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
        `dirname $(gcc --print-libgcc-file-name)`/specs
    echo 'int main(){}' > dummy.c
    cc dummy.c -v -Wl,--verbose &> dummy.log
    readelf -l a.out | grep ': /lib'
    grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
    grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
    grep "/lib.*/libc.so.6 " dummy.log
    grep found dummy.log
    rm -v dummy.c a.out dummy.log
}

zlib() {
    local   _pkgname="zlib"
    local   _pkgver="1.2.11"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}

    build "+ ./configure --prefix=/usr" "./configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ mv -v /usr/lib/libz.so.* /lib" "mv -v /usr/lib/libz.so.* /lib" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so" "ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

file() {
    local   _pkgname="file"
    local   _pkgver="5.32"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}

    build "+ ./configure --prefix=/usr" "./configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

readline() {
    local   _pkgname="readline"
    local   _pkgver="7.0"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}

    build "+ sed -i '/MV.*old/d' Makefile.in" "sed -i '/MV.*old/d' Makefile.in" ${_logfile}
    build "+ sed -i '/{OLDSUFF}/c:' support/shlib-install" "sed -i '/{OLDSUFF}/c:' support/shlib-install" ${_logfile}
    build "+ ./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/readline-7.0" "./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/readline-7.0" ${_logfile}
    build "+ make SHLIB_LIBS="-L/tools/lib -lncursesw"" "make SHLIB_LIBS="-L/tools/lib -lncursesw"" ${_logfile}

    build "+ make SHLIB_LIBS="-L/tools/lib -lncurses" install" "make SHLIB_LIBS="-L/tools/lib -lncurses" install" ${_logfile}
    build "+ mv -v /usr/lib/lib{readline,history}.so.* /lib" "mv -v /usr/lib/lib{readline,history}.so.* /lib" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so" "ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so" "ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so" ${_logfile}
    build "+ install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-7.0" "install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-7.0" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

m4() {
    local   _pkgname="m4"
    local   _pkgver="1.4.18"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}

    build "+ ./configure --prefix=/usr" "./configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

bc() {
    local   _pkgname="bc"
    local   _pkgver="1.07.1"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
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
    build "+ ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6" "ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6" ${_logfile}
    build "+ ln -sfv libncurses.so.6 /usr/lib/libncurses.so" "ln -sfv libncurses.so.6 /usr/lib/libncurses.so" ${_logfile}
    build "+ sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure" "sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure" ${_logfile}
    build "+ ./configure --prefix=/usr --with-readline --mandir=/usr/share/man --infodir=/usr/share/info" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --with-readline --mandir=/usr/share/man --infodir=/usr/share/info" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ echo "quit" | ./bc/bc -l Test/checklib.b" "echo "quit" | ./bc/bc -l Test/checklib.b" ${_logfile}
    build "+ make install" "make install" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

binutils() {
    local   _pkgname="binutils"
    local   _pkgver="2.30"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}

    build "+ ./configure --prefix=/usr --enable-gold --enable-ld=default --enable-plugins --enable-shared --disable-werror --enable-64-bit-bfd --with-system-zlib" "./configure --prefix=/usr --enable-gold --enable-ld=default --enable-plugins --enable-shared --disable-werror --enable-64-bit-bfd --with-system-zlib" ${_logfile}
    build "+ make tooldir=/usr" "make tooldir=/usr" ${_logfile}
    build "+ make -k check" "make -k check" ${_logfile}
    build "+ make tooldir=/usr install" "make tooldir=/usr install" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

gmp() {
    local   _pkgname="gmp"
    local   _pkgver="6.1.2"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}

    build "+ ./configure --prefix=/usr --enable-cxx --disable-static --docdir=/usr/share/doc/gmp-6.1.2" "./configure --prefix=/usr --enable-cxx --disable-static --docdir=/usr/share/doc/gmp-6.1.2" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make html" "make html" ${_logfile}
    build "+ make check 2>&1 | tee gmp-check-log" "make check 2>&1 | tee gmp-check-log" ${_logfile}
    build "+ awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log" "awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ make install-html" "make install-html" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}






# Build all packages from shell scripts

change_ownership
linux_api_headers
man_pages
glibc
adjust_toolchain
zlib
file
readline
m4
bc
binutils
#gmp
#mpfr
#gcc
#bzip2
#pkg_config
#ncurses
#attr
#acl
#libcap
#sed_build
#shadow
#psmisc
#iana_etc_2
#bison
#flex
#grep_build
#bash
#libtool
#gdbm
#gperf
#expat
#inetutils
#perl
#xml_parser
#intltool
#autoconf
#automake
#xz
#kmod
#gettext
#libelf
#libiffi
#openssl
#python3
#ninja
#meson
#systemd
#procps_ng
#e2fsprogs
#coreutils
#check
#gawk
#findutils
#groff
#grub
#less_build
#gzip
#iproute2
#kbd
#libpipeline
#make
#patch
#dbus
#util_linux
#mandb
#tar
#texinfo
#vim
#
#strip_debug
#clean_up
#