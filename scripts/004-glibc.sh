    _pkgname="glibc"
    _pkgver="2.27"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ patch -Np1 -i ../../SOURCES/glibc-2.27-fhs-1.patch" "patch -Np1 -i ../../SOURCES/glibc-2.27-fhs-1.patch" ${_logfile}

    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}

    
    build "+ ln -sfv /tools/lib/gcc /usr/lib" "ln -sfv /tools/lib/gcc /usr/lib" ${_logfile}
    case $(uname -m) in
        i?86)   build "+ GCC_INCDIR=/usr/lib/gcc/$(uname -m)-pc-linux-gnu/7.3.0/include" "GCC_INCDIR=/usr/lib/gcc/$(uname -m)-pc-linux-gnu/7.3.0/include" ${_logfile}
                build "+ ln -sfv ld-linux.so.2 /lib/ld-lsb.so.3" "ln -sfv ld-linux.so.2 /lib/ld-lsb.so.3" ${_logfile}
        ;;
        x86_64) build "+ GCC_INCDIR=/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/include" "GCC_INCDIR=/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/include" ${_logfile}
                build "+ ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64" "ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64" ${_logfile}
                build "+ ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3" "ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3" ${_logfile}}
        ;;
    esac
    build "+ rm -f /usr/include/limits.h" "rm -f /usr/include/limits.h" ${_logfile}
    build "+ CC=\"gcc -isystem $GCC_INCDIR -isystem /usr/include\" ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-werror --enable-kernel=3.2 --enable-stack-protector=strong libc_cv_slibdir=/lib" "CC=\"gcc -isystem $GCC_INCDIR -isystem /usr/include\" ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-werror --enable-kernel=3.2 --enable-stack-protector=strong libc_cv_slibdir=/lib" ${_logfile}
    build "+ unset GCC_INCDIR" "unset GCC_INCDIR" ${_logfile}
    build "+ make" "make" ${_logfile}
    #set +o errexit
    #build "+ make check" "make check" ${_logfile}
    #set -o errexit
    build "+ touch /etc/ld.so.conf" "touch /etc/ld.so.conf" ${_logfile}
    build "+ sed '/test-installation/s@\$(PERL)@echo not running@' -i ../${_pkgname}-${_pkgver}/Makefile" "sed '/test-installation/s@\$(PERL)@echo not running@' -i ../${_pkgname}-${_pkgver}/Makefile" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ cp -v ../${_pkgname}-${_pkgver}/nscd/nscd.conf /etc/nscd.conf" "cp -v ../${_pkgname}-${_pkgver}/nscd/nscd.conf /etc/nscd.conf" ${_logfile}
    build "+ mkdir -pv /var/cache/nscd" "mkdir -pv /var/cache/nscd" ${_logfile}
    build "+ install -v -Dm644 ../${_pkgname}-${_pkgver}/nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf" "install -v -Dm644 ../${_pkgname}-${_pkgver}/nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf" ${_logfile}
    build "+ install -v -Dm644 ../${_pkgname}-${_pkgver}/nscd/nscd.service /lib/systemd/system/nscd.service" "install -v -Dm644 ../${_pkgname}-${_pkgver}/nscd/nscd.service /lib/systemd/system/nscd.service" ${_logfile}
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
    #build "+ make localedata/install-locales" "make localedata/install-locales" ${_logfile}
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
    build " Adding time zone data" "" ${_logfile}
    tar -xf ../../SOURCES/tzdata2018c.tar.gz

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

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
