#!/tools/bin/bash

# this file is run in chroot.
# in this environment / is /mnt/lfs from the host system
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
    build "+ chown -R root:root /tools" "chown -R root:root /tools" ${_logfile}
    >  ${_complete}
    return 0
}

files_and_symlinks() {
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
    > ${_logfile}
    msg "Creating files and symlinks: "
    build "+ ln -sv /tools/bin/{bash,cat,dd,echo,ln,pwd,rm,stty} /bin" "ln -sv /tools/bin/{bash,cat,dd,echo,ln,pwd,rm,stty} /bin" ${_logfile}
    build "+ ln -sv /tools/bin/{env,install,perl} /usr/bin" "ln -sv /tools/bin/{env,install,perl} /usr/bin" ${_logfile}
    build "+ ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib" "ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib" ${_logfile}
    build "+ ln -sv /tools/lib/libstdc++.{a,so{,.6}} /usr/lib" "ln -sv /tools/lib/libstdc++.{a,so{,.6}} /usr/lib" ${_logfile}
    for lib in blkid lzma mount uuid
    do
        build "+ ln -sv /tools/lib/lib$lib.so* /usr/lib" "ln -sv /tools/lib/lib$lib.so* /usr/lib" ${_logfile}
    done
    build "+ ln -svf /tools/include/blkid    /usr/include" "ln -svf /tools/include/blkid    /usr/include" ${_logfile}
    build "+ ln -svf /tools/include/libmount /usr/include" "ln -svf /tools/include/libmount /usr/include" ${_logfile}
    build "+ ln -svf /tools/include/uuid     /usr/include" "ln -svf /tools/include/uuid     /usr/include" ${_logfile}
    build "+ install -vdm755 /usr/lib/pkgconfig" "install -vdm755 /usr/lib/pkgconfig" ${_logfile}
    for pc in blkid mount uuid
    do
        build "+ sed 's@tools@usr@g' /tools/lib/pkgconfig/${pc}.pc > /usr/lib/pkgconfig/${pc}.pc" "sed 's@tools@usr@g' /tools/lib/pkgconfig/${pc}.pc > /usr/lib/pkgconfig/${pc}.pc" ${_logfile}
    done
    build "+ ln -sv bash /bin/sh" "ln -sv bash /bin/sh" ${_logfile}

    build "+ ln -sv /proc/self/mounts /etc/mtab" "ln -sv /proc/self/mounts /etc/mtab" "${_logfile}"

    msg_line "Creating /etc/passwd: "
    cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
systemd-bus-proxy:x:72:72:systemd Bus Proxy:/:/bin/false
systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/bin/false
systemd-journal-remote:x:74:74:systemd Journal Remote:/:/bin/false
systemd-journal-upload:x:75:75:systemd Journal Upload:/:/bin/false
systemd-network:x:76:76:systemd Network Management:/:/bin/false
systemd-resolve:x:77:77:systemd Resolver:/:/bin/false
systemd-timesync:x:78:78:systemd Time Synchronization:/:/bin/false
systemd-coredump:x:79:79:systemd Core Dumper:/:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF
    msg_success

    msg_line "Creating /etc/group: "
cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
kvm:x:61:
systemd-bus-proxy:x:72:
systemd-journal-gateway:x:73:
systemd-journal-remote:x:74:
systemd-journal-upload:x:75:
systemd-network:x:76:
systemd-resolve:x:77:
systemd-timesync:x:78:
systemd-coredump:x:79:
nogroup:x:99:
users:x:999:
EOF
    msg_success

    build "+ touch /var/log/{btmp,lastlog,faillog,wtmp}" "touch /var/log/{btmp,lastlog,faillog,wtmp}" ${_logfile}

    build "+ chgrp -v utmp /var/log/lastlog" "chgrp -v utmp /var/log/lastlog" ${_logfile}
    build "+ chmod -v 664 /var/log/lastlog" "chmod -v 664 /var/log/lastlog" ${_logfile}
    build "+ chmod -v 600 /var/log/btmp" "chmod -v 600 /var/log/btmp" ${_logfile}
    touch ${_complete}
}

linux_api_headers() {
    local   _pkgname="linux"
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


    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

man_pages() {
    local   _pkgname="man-pages"
    local   _pkgver="4.15"
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




    build "+ make install" "make install" ${_logfile}


    #build " Restore directory" "popd " /dev/null
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
}

adjust_toolchain() {
    local   _pkgname="adjust_toolchain"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
    > ${_logfile}
    build "+ mv -v /tools/bin/{ld,ld-old}" "mv -v /tools/bin/{ld,ld-old}" ${_logfile}
    build "+ mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}" "mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}" ${_logfile}
    build "+ mv -v /tools/bin/{ld-new,ld}" "mv -v /tools/bin/{ld-new,ld}" ${_logfile}
    build "+ ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld" "ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld" ${_logfile}
    gcc -dumpspecs | sed -e 's@/tools@@g'                   \
        -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
        -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
        `dirname $(gcc --print-libgcc-file-name)`/specs
    build "+ echo 'int main(){}' > dummy.c" "echo 'int main(){}' > dummy.c" ${_logfile}
    build "+ cc dummy.c -v -Wl,--verbose &> dummy.log" "cc dummy.c -v -Wl,--verbose &> dummy.log" ${_logfile}
    build "+ readelf -l a.out | grep ': /lib'" "readelf -l a.out | grep ': /lib'" ${_logfile}
    build "+ grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log" "grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log" ${_logfile}
    build "+ grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'" "grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'" ${_logfile}
    build "+ grep \"/lib.*/libc.so.6 \" dummy.log" "grep \"/lib.*/libc.so.6 \" dummy.log" ${_logfile}
    build "+ grep found dummy.log" "grep found dummy.log" ${_logfile}
    build "+ rm -v dummy.c a.out dummy.log" "rm -v dummy.c a.out dummy.log" ${_logfile}

    > ${_complete}
    return 0
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

    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
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

    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
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

    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
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

    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --enable-gold --enable-ld=default --enable-plugins --enable-shared --disable-werror --enable-64-bit-bfd --with-system-zlib" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --enable-gold --enable-ld=default --enable-plugins --enable-shared --disable-werror --enable-64-bit-bfd --with-system-zlib" ${_logfile}
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

    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --enable-cxx --disable-static --docdir=/usr/share/doc/gmp-6.1.2" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --enable-cxx --disable-static --docdir=/usr/share/doc/gmp-6.1.2" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make html" "make html" ${_logfile}
    build "+ make check 2>&1 | tee gmp-check-log" "make check 2>&1 | tee gmp-check-log" ${_logfile}
    build "+ awk '/# PASS:/{total+=\$3} ; END{print total}' gmp-check-log" "awk '/# PASS:/{total+=\$3} ; END{print total}' gmp-check-log" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ make install-html" "make install-html" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

mpfr() {
    local   _pkgname="mpfr"
    local   _pkgver="4.0.1"
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

    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --enable-thread-safe --docdir=/usr/share/doc/mpfr-4.0.1" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --enable-thread-safe --docdir=/usr/share/doc/mpfr-4.0.1" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make html" "make html" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ make install-html" "make install-html" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

mpc() {
    local   _pkgname="mpc"
    local   _pkgver="1.1.0"
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

    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --docdir=/usr/share/doc/mpc-1.1.0" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --docdir=/usr/share/doc/mpc-1.1.0" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make html" "make html" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ make install-html" "make install-html" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

gcc_build() {
    local   _pkgname="gcc"
    local   _pkgver="7.3.0"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
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
}

bzip2_build() {
    local   _pkgname="bzip2"
    local   _pkgver="1.0.6"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}

    build "+ patch -Np1 -i ../../SOURCES/bzip2-1.0.6-install_docs-1.patch" "patch -Np1 -i ../../SOURCES/bzip2-1.0.6-install_docs-1.patch" ${_logfile}
    build "+ sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile" "sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile" ${_logfile}
    build "+ sed -i \"s@(PREFIX)/man@(PREFIX)/share/man@g\" Makefile" "sed -i \"s@(PREFIX)/man@(PREFIX)/share/man@g\" Makefile" ${_logfile}
    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}

   
    build "+ make -f Makefile-libbz2_so" "make -f Makefile-libbz2_so" ${_logfile}
    build "+ make clean" "make clean" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make PREFIX=/usr install" "make PREFIX=/usr install" ${_logfile}
    build "+ cp -v bzip2-shared /bin/bzip2" "cp -v bzip2-shared /bin/bzip2" ${_logfile}
    build "+ cp -av libbz2.so* /lib" "cp -av libbz2.so* /lib" ${_logfile}
    build "+ ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so" "ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so" ${_logfile}
    build "+ rm -v /usr/bin/{bunzip2,bzcat,bzip2}" "rm -v /usr/bin/{bunzip2,bzcat,bzip2}" ${_logfile}
    build "+ ln -sv bzip2 /bin/bunzip2" "ln -sv bzip2 /bin/bunzip2" ${_logfile}
    build "+ ln -sv bzip2 /bin/bzcat" "ln -sv bzip2 /bin/bzcat" ${_logfile}

    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

pkg_config() {
    local   _pkgname="pkg_config"
    local   _pkgver="0.29.2"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --with-internal-glib --disable-host-too --docdir=/usr/share/doc/pkg-config-0.29.2" "./configure --prefix=/usr --with-internal-glib --disable-host-too --docdir=/usr/share/doc/pkg-config-0.29.2" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

ncurses() {
    local   _pkgname="ncurses"
    local   _pkgver="6.1"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
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
}

attr_build() {
    local   _pkgname="attr"
    local   _pkgver="2.4.47"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in" "sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in" ${_logfile}
    build "+ sed -i -e \"/SUBDIRS/s|man[25]||g\" man/Makefile" "sed -i -e \"/SUBDIRS/s|man[25]||g\" man/Makefile" ${_logfile}
    build "+ sed -i 's:{(:\\{(:' test/run" "sed -i 's:{(:\\{(:' test/run" ${_logfile}

    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ make -j1 tests root-tests" "make -j1 tests root-tests" ${_logfile}
    build "+ make install install-dev install-lib" "make install install-dev install-lib" ${_logfile}
    build "+ chmod -v 755 /usr/lib/libattr.so" "chmod -v 755 /usr/lib/libattr.so" ${_logfile}
    build "+ mv -v /usr/lib/libattr.so.* /lib" "mv -v /usr/lib/libattr.so.* /lib" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so" "ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so" ${_logfile}

    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

acl() {
    local   _pkgname="acl"
    local   _pkgver="2.2.52"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in" "sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in" ${_logfile}
    build "+ sed -i \"s:| sed.*::g\" test/{sbits-restore,cp,misc}.test" "sed -i \"s:| sed.*::g\" test/{sbits-restore,cp,misc}.test" ${_logfile}
    build "+ sed -i 's/{(/\\{(/' test/run" "sed -i 's/{(/\\{(/' test/run" ${_logfile}
    build "+ sed -i -e \"/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);\" libacl/__acl_to_any_text.c" "sed -i -e \"/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);\" libacl/__acl_to_any_text.c" ${_logfile}

    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --libexecdir=/usr/lib" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --libexecdir=/usr/lib" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install install-dev install-lib" "make install install-dev install-lib" ${_logfile}
    build "+ chmod -v 755 /usr/lib/libacl.so" "chmod -v 755 /usr/lib/libacl.so" ${_logfile}
    build "+ mv -v /usr/lib/libacl.so.* /lib" "mv -v /usr/lib/libacl.so.* /lib" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so" "ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so" ${_logfile}

    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

libcap() {
    local   _pkgname="libcap"
    local   _pkgver="2.25"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i '/install.STALIBNAME/d' libcap/Makefile" "sed -i '/install.STALIBNAME/d' libcap/Makefile" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make RAISE_SETFCAP=no lib=lib prefix=/usr install" "make RAISE_SETFCAP=no lib=lib prefix=/usr install" ${_logfile}
    build "+ chmod -v 755 /usr/lib/libcap.so" "chmod -v 755 /usr/lib/libcap.so" ${_logfile}
    build "+ mv -v /usr/lib/libcap.so.* /lib" "mv -v /usr/lib/libcap.so.* /lib" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so" "ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

sed_build() {
    local   _pkgname="sed"
    local   _pkgver="4.4"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i 's/usr/tools/'                 build-aux/help2man" "sed -i 's/usr/tools/'                 build-aux/help2man" ${_logfile}
    build "+ sed -i 's/testsuite.panic-tests.sh//' Makefile.in" "sed -i 's/testsuite.panic-tests.sh//' Makefile.in" ${_logfile}

    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --bindir=/bin" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --bindir=/bin" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make html" "make html" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ install -d -m755           /usr/share/doc/sed-4.4" "install -d -m755           /usr/share/doc/sed-4.4" ${_logfile}
    build "+ install -m644 doc/sed.html /usr/share/doc/sed-4.4" "install -m644 doc/sed.html /usr/share/doc/sed-4.4" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

shadow() {
    local   _pkgname="shadow"
    local   _pkgver="4.5"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i 's/groups$(EXEEXT) //' src/Makefile.in" "sed -i 's/groups$(EXEEXT) //' src/Makefile.in" ${_logfile}
    build "+ find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;" "find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;" ${_logfile}
    build "+ find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;" "find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;" ${_logfile}
    build "+ find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;" "find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;" ${_logfile}
    build "+ sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' -e 's@/var/spool/mail@/var/mail@' etc/login.defs" "sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' -e 's@/var/spool/mail@/var/mail@' etc/login.defs" ${_logfile}
    build "+ sed -i 's@DICTPATH.*@DICTPATH\t/lib/cracklib/pw_dict@' etc/login.defs" "sed -i 's@DICTPATH.*@DICTPATH\t/lib/cracklib/pw_dict@' etc/login.defs" ${_logfile}
    build "+ sed -i 's/1000/999/' etc/useradd" "sed -i 's/1000/999/' etc/useradd" ${_logfile}

    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --sysconfdir=/etc --with-group-name-max-length=32" "../${_pkgname}-${_pkgver}/configure --sysconfdir=/etc --with-group-name-max-length=32" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install" "make install" ${_logfile}
    build "+ mv -v /usr/bin/passwd /bin" "mv -v /usr/bin/passwd /bin" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

psmisc() {
    local   _pkgname="psmisc"
    local   _pkgver="23.1"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install" "make install" ${_logfile}
    build "+ mv -v /usr/bin/fuser   /bin" "mv -v /usr/bin/fuser   /bin" ${_logfile}
    build "+ mv -v /usr/bin/killall /bin" "mv -v /usr/bin/killall /bin" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

iana_etc_2() {
    local   _pkgname="iana-etc"
    local   _pkgver="2.30"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make install" "make install" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}


bison_build() {
    local   _pkgname="bison"
    local   _pkgver="3.0.4"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.4" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.4" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install" "make install" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

flex_build() {
    local   _pkgname="flex"
    local   _pkgver="2.6.4"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i \"/math.h/a #include <malloc.h>\" src/flexdef.h" "sed -i \"/math.h/a #include <malloc.h>\" src/flexdef.h" ${_logfile}

    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ HELP2MAN=/tools/bin/true ../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4" "HELP2MAN=/tools/bin/true ../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ ln -sv flex /usr/bin/lex" "ln -sv flex /usr/bin/lex" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

grep_build() {
    local   _pkgname="grep"
    local   _pkgver="3.1"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --bindir=/bin" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --bindir=/bin" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}


    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

bash_build() {
    local   _pkgname="bash"
    local   _pkgver="4.4.18"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/bash-4.4.18 --without-bash-malloc --with-installed-readline" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/bash-4.4.18 --without-bash-malloc --with-installed-readline" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ chown -Rv nobody ../build ../${_pkgname}-${_pkgver}" "chown -Rv nobody ../build ../${_pkgname}-${_pkgver}" ${_logfile}
    #build "+ su nobody -s /bin/bash -c \"PATH=$PATH make tests\"" "su nobody -s /bin/bash -c \"PATH=$PATH make tests\"" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ mv -vf /usr/bin/bash /bin" "mv -vf /usr/bin/bash /bin" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

libtool() {
    local   _pkgname="libtool"
    local   _pkgver="2.4.6"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}


gdbm() {
    local   _pkgname="gdbm"
    local   _pkgver="1.14.1"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --enable-libgdbm-compat" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --enable-libgdbm-compat" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

gperf() {
    local   _pkgname="gperf"
    local   _pkgver="3.1"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make -j1 check" "make -j1 check" ${_logfile}
    build "+ make install" "make install" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

expat() {
    local   _pkgname="expat"
    local   _pkgver="2.2.5"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i 's|usr/bin/env |bin/|' run.sh.in" "sed -i 's|usr/bin/env |bin/|' run.sh.in" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ install -v -dm755 /usr/share/doc/${_pkgname}-${_pkgver}" "install -v -dm755 /usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build "+ install -v -m644 ../${_pkgname}-${_pkgver}/doc/*.{html,png,css} /usr/share/doc/${_pkgname}-${_pkgver}" "install -v -m644 ../${_pkgname}-${_pkgver}/doc/*.{html,png,css} /usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

inetutils() {
    local   _pkgname="inetutils"
    local   _pkgver="1.9.4"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --localstatedir=/var --disable-logger --disable-whois --disable-rcp --disable-rexec --disable-rlogin --disable-rsh --disable-servers" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --localstatedir=/var --disable-logger --disable-whois --disable-rcp --disable-rexec --disable-rlogin --disable-rsh --disable-servers" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin" "mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin" ${_logfile}
    build "+ mv -v /usr/bin/ifconfig /sbin" "mv -v /usr/bin/ifconfig /sbin" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

perl_build() {
    local   _pkgname="perl"
    local   _pkgver="5.26.1"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ echo \"127.0.0.1 localhost $(hostname)\" > /etc/hosts" "echo \"127.0.0.1 localhost $(hostname)\" > /etc/hosts" ${_logfile}
    build "+ export BUILD_ZLIB=False" "export BUILD_ZLIB=False" ${_logfile}
    build "+ export BUILD_BZIP2=0" "export BUILD_BZIP2=0" ${_logfile}
    build "+ sh Configure -des -Dprefix=/usr -Dvendorprefix=/usr            -Dman1dir=/usr/share/man/man1 -Dman3dir=/usr/share/man/man3 -Dpager=\"/usr/bin/less -isR\" -Duseshrplib -Dusethreads" "sh Configure -des -Dprefix=/usr -Dvendorprefix=/usr            -Dman1dir=/usr/share/man/man1 -Dman3dir=/usr/share/man/man3 -Dpager=\"/usr/bin/less -isR\" -Duseshrplib -Dusethreads" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make -k test" "make -k test" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ unset BUILD_ZLIB BUILD_BZIP2" "unset BUILD_ZLIB BUILD_BZIP2" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

xml_parser() {
    local   _pkgname="XML-Parser"
    local   _pkgver="2.44"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ perl Makefile.PL" "perl Makefile.PL" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make test" "make test" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

intltool() {
    local   _pkgname="intltool"
    local   _pkgver="0.51.0"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i 's:\\\${:\\\$\\{:' intltool-update.in" "sed -i 's:\\\${:\\\$\\{:' intltool-update.in" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ install -v -Dm644 ../${_pkgname}-${_pkgver}/doc/I18N-HOWTO /usr/share/doc/${_pkgname}-${_pkgver}/I18N-HOWTO" "install -v -Dm644 ../${_pkgname}-${_pkgver}/doc/I18N-HOWTO /usr/share/doc/${_pkgname}-${_pkgver}/I18N-HOWTO" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

autoconf_build() {
    local   _pkgname="autoconf"
    local   _pkgver="2.69"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ " "" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

automake_build() {
    local   _pkgname="automake"
    local   _pkgver="1.15.1"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/${_pkgname}-${_pkgver}" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install" "make install" ${_logfile}
    build "+ " "" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

xz_build() {
    local   _pkgname="xz"
    local   _pkgver="5.2.3"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --docdir=/usr/share/doc/${_pkgname}-${_pkgver}" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --docdir=/usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ " "" ${_logfile}
    build "+ mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin" "mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin" ${_logfile}
    build "+ mv -v /usr/lib/liblzma.so.* /lib" "mv -v /usr/lib/liblzma.so.* /lib" ${_logfile}
    build "+ ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so" "ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

kmod_build() {
    local   _pkgname="kmod"
    local   _pkgver="25"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --bindir=/bin --sysconfdir=/etc --with-rootlibdir=/lib --with-xz --with-zlib" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --bindir=/bin --sysconfdir=/etc --with-rootlibdir=/lib --with-xz --with-zlib" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install" "make install" ${_logfile}
    for target in depmod insmod lsmod modinfo modprobe rmmod; do
        build "+ ln -sfv ../bin/kmod /sbin/$target" "ln -sfv ../bin/kmod /sbin/$target" ${_logfile}
    done
    build "+ ln -sfv kmod /bin/lsmod" "ln -sfv kmod /bin/lsmod" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

gettext_build() {
    local   _pkgname="gettext"
    local   _pkgver="0.19.8.1"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in" "sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in" ${_logfile}
    build "+ sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in" "sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --docdir=/usr/share/doc/${_pkgname}-${_pkgver}" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static --docdir=/usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ chmod -v 0755 /usr/lib/preloadable_libintl.so" "chmod -v 0755 /usr/lib/preloadable_libintl.so" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

libelf() {
    local   _pkgname="elfutils"
    local   _pkgver="0.170"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make -C libelf install" "make -C libelf install" ${_logfile}
    build "+ install -vm644 ./config/libelf.pc /usr/lib/pkgconfig" "install -vm644 ../${_pkgname}-${_pkgver}/config/libelf.pc /usr/lib/pkgconfig" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

libffi() {
    local   _pkgname="libffi"
    local   _pkgver="3.2.1"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' -i include/Makefile.in" "sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' -i include/Makefile.in" ${_logfile}
    build "+ sed -e '/^includedir/ s/=.*$/=@includedir@/' -e 's/^Cflags: -I${includedir}/Cflags:/' -i libffi.pc.in" "sed -e '/^includedir/ s/=.*$/=@includedir@/' -e 's/^Cflags: -I${includedir}/Cflags:/' -i libffi.pc.in" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

openssl_build() {
    local   _pkgname="openssl"
    local   _pkgver="1.1.0g"
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
    build "+ ../${_pkgname}-${_pkgver}/config --prefix=/usr --openssldir=/etc/ssl --libdir=lib shared zlib-dynamic" "../${_pkgname}-${_pkgver}/config --prefix=/usr --openssldir=/etc/ssl --libdir=lib shared zlib-dynamic" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile" "sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile" ${_logfile}
    build "+ make MANSUFFIX=ssl install" "make MANSUFFIX=ssl install" ${_logfile}
    build "+ mv -v /usr/share/doc/openssl /usr/share/doc/${_pkgname}-${_pkgver}" "mv -v /usr/share/doc/openssl /usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build "+ cp -vfr doc/* /usr/share/doc/${_pkgname}-${_pkgver}" "cp -vfr doc/* /usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

python3_build() {
    local   _pkgname="Python"
    local   _pkgver="3.6.4"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --enable-shared --with-system-expat --with-system-ffi --with-ensurepip=yes" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --enable-shared --with-system-expat --with-system-ffi --with-ensurepip=yes" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install" "make install" ${_logfile}
    build "+ " "" ${_logfile}
    build "+ chmod -v 755 /usr/lib/libpython3.6m.so" "chmod -v 755 /usr/lib/libpython3.6m.so" ${_logfile}
    build "+ chmod -v 755 /usr/lib/libpython3.so" "chmod -v 755 /usr/lib/libpython3.so" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

ninja_build() {
    local   _pkgname="ninja"
    local   _pkgver="1.8.2"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ export NINJAJOBS=4" "export NINJAJOBS=4" ${_logfile}
    build "+ patch -Np1 -i ../../SOURCES/ninja-1.8.2-add_NINJAJOBS_var-1.patch" "patch -Np1 -i ../../SOURCES/ninja-1.8.2-add_NINJAJOBS_var-1.patch" ${_logfile}
    build "+ python3 configure.py --bootstrap" "python3 configure.py --bootstrap" ${_logfile}
    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}

    build "+ python3 configure.py" "python3 configure.py" ${_logfile}
    build "+ ./ninja ninja_test" "./ninja ninja_test" ${_logfile}
    build "+ ./ninja_test --gtest_filter=-SubprocessTest.SetWithLots" "./ninja_test --gtest_filter=-SubprocessTest.SetWithLots" ${_logfile}
    build "+ install -vm755 ninja /usr/bin/" "install -vm755 ninja /usr/bin/" ${_logfile}
    build "+ install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja" "install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja" ${_logfile}
    build "+ install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja" "install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja" ${_logfile}

    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

meson() {
    local   _pkgname="meson"
    local   _pkgver="0.44.0"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ python3 setup.py build" "python3 setup.py build" ${_logfile}
    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}


    build "+ python3 setup.py install" "python3 setup.py install" ${_logfile}

    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

systemd() {
    local   _pkgname="systemd"
    local   _pkgver="237"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ ln -sf /tools/bin/true /usr/bin/xsltproc" "ln -sf /tools/bin/true /usr/bin/xsltproc" ${_logfile}
    build "+ tar -xf ../../SOURCES/systemd-man-pages-237.tar.xz" "tar -xf ../../SOURCES/systemd-man-pages-237.tar.xz" ${_logfile}
    build "+ sed '178,222d' -i src/resolve/meson.build" "sed '178,222d' -i src/resolve/meson.build" ${_logfile}
    build "+ sed -i 's/GROUP=\"render\", //' rules/50-udev-default.rules.in" "sed -i 's/GROUP=\"render\", //' rules/50-udev-default.rules.in" ${_logfile}
    build " Create work directory" "install -vdm 755 build" ${_logfile}
    build " Change directory: build" "pushd build" ${_logfile}
    build "+ LANG=en_US.UTF-8 meson --prefix=/usr --sysconfdir=/etc --localstatedir=/var -Dblkid=true -Dbuildtype=release -Ddefault-dnssec=no -Dfirstboot=false -Dinstall-tests=false -Dkill-path=/bin/kill -Dkmod-path=/bin/kmod -Dldconfig=false -Dmount-path=/bin/mount -Drootprefix= -Drootlibdir=/lib -Dsplit-usr=true -Dsulogin-path=/sbin/sulogin -Dsysusers=false -Dumount-path=/bin/umount -Db_lto=false ../${_pkgname}-${_pkgver}" "LANG=en_US.UTF-8 meson --prefix=/usr --sysconfdir=/etc --localstatedir=/var -Dblkid=true -Dbuildtype=release -Ddefault-dnssec=no -Dfirstboot=false -Dinstall-tests=false -Dkill-path=/bin/kill -Dkmod-path=/bin/kmod -Dldconfig=false -Dmount-path=/bin/mount -Drootprefix= -Drootlibdir=/lib -Dsplit-usr=true -Dsulogin-path=/sbin/sulogin -Dsysusers=false -Dumount-path=/bin/umount -Db_lto=false ../${_pkgname}-${_pkgver}" ${_logfile}
    build "+ LANG=en_US.UTF-8 ninja" "LANG=en_US.UTF-8 ninja" ${_logfile}

    build "+ LANG=en_US.UTF-8 ninja install" "LANG=en_US.UTF-8 ninja install" ${_logfile}
    build "+ rm -rfv /usr/lib/rpm" "rm -rfv /usr/lib/rpm" ${_logfile}
    for tool in runlevel reboot shutdown poweroff halt telinit; do
        build "+ ln -sfv ../bin/systemctl /sbin/${tool}" "ln -sfv ../bin/systemctl /sbin/${tool}" ${_logfile}
    done
    build "+ ln -sfv ../lib/systemd/systemd /sbin/init" "ln -sfv ../lib/systemd/systemd /sbin/init" ${_logfile}
    build "+ rm -f /usr/bin/xsltproc" "rm -f /usr/bin/xsltproc" ${_logfile}
    build "+ systemd-machine-id-setup" "systemd-machine-id-setup" ${_logfile}
    msg_line "Creating /lib/systemd/systemd-user-sessions"
    cat > /lib/systemd/systemd-user-sessions << "EOF"
#!/bin/bash
rm -f /run/nologin
EOF
    msg_success
    build "+ chmod 755 /lib/systemd/systemd-user-sessions" "chmod 755 /lib/systemd/systemd-user-sessions" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

procps_ng() {
    local   _pkgname="procps-ng"
    local   _pkgver="3.3.12"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --exec-prefix= --libdir=/usr/lib --docdir=/usr/share/doc/${_pkgname}-${_pkgver} --disable-static --disable-kill --with-systemd" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --exec-prefix= --libdir=/usr/lib --docdir=/usr/share/doc/${_pkgname}-${_pkgver} --disable-static --disable-kill --with-systemd" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp" "sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp" ${_logfile}
    #build "+ sed -i '/set tty/d' testsuite/pkill.test/pkill.exp" "sed -i '/set tty/d' testsuite/pkill.test/pkill.exp" ${_logfile}
    #build "+ rm testsuite/pgrep.test/pgrep.exp" "rm testsuite/pgrep.test/pgrep.exp" ${_logfile}
    #build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ mv -v /usr/lib/libprocps.so.* /lib" "mv -v /usr/lib/libprocps.so.* /lib" ${_logfile}
    build "+ ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so" "ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

e2fsprogs() {
    local   _pkgname="e2fsprogs"
    local   _pkgver="1.43.9"
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
}

coreutils() {
    local   _pkgname="coreutils"
    local   _pkgver="8.29"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
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
}

check() {
    local   _pkgname="check"
    local   _pkgver="0.12.0"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ make check" "make check" ${_logfile}
    build "+ make installl" "make installl" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

diffutils() {
    local   _pkgname="diffutils"
    local   _pkgver="3.6"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ make check" "make check" ${_logfile}
    build "+ make installl" "make installl" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

gawk_build() {
    local   _pkgname="gawk"
    local   _pkgver="4.2.0"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i 's/extras//' Makefile.in" "sed -i 's/extras//' Makefile.in" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

findutils() {
    local   _pkgname="findutils"
    local   _pkgver="4.6.0"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in" "sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --localstatedir=/var/lib/locate" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --localstatedir=/var/lib/locate" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ mv -v /usr/bin/find /bin" "mv -v /usr/bin/find /bin" ${_logfile}
    build "+ sed -i 's|find:=\${BINDIR}|find:=/bin|' /usr/bin/updatedb" "sed -i 's|find:=\${BINDIR}|find:=/bin|' /usr/bin/updatedb" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

groff_build() {
    local   _pkgname="groff"
    local   _pkgver="1.22.3"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ PAGE=<paper_size> ./configure --prefix=/usr" "PAGE=<paper_size> ./configure --prefix=/usr" ${_logfile}
    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ make -j1" "make -j1" ${_logfile}
    build "+ make install" "make install" ${_logfile}

    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

grub_build() {
    local   _pkgname="grub"
    local   _pkgver="2.02"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --sbindir=/sbin --sysconfdir=/etc --disable-efiemu --disable-werror" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --sbindir=/sbin --sysconfdir=/etc --disable-efiemu --disable-werror" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install" "make install" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

less_build() {
    local   _pkgname="less"
    local   _pkgver="530"
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
    build "+ ../${_pkgname}-${_pkgver}configure --prefix=/usr --sysconfdir=/etc" "../${_pkgname}-${_pkgver}configure --prefix=/usr --sysconfdir=/etc" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install" "make install" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

gzip_build() {
    local   _pkgname="gzip"
    local   _pkgver="1.9"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ mv -v /usr/bin/gzip /bin" "mv -v /usr/bin/gzip /bin" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

iproute2() {
    local   _pkgname="iproute2"
    local   _pkgver="4.15.0"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i /ARPD/d Makefile" "sed -i /ARPD/d Makefile" ${_logfile}
    build "+ rm -fv man/man8/arpd.8" "rm -fv man/man8/arpd.8" ${_logfile}
    build "+ sed -i 's/m_ipt.o//' tc/Makefile" "sed -i 's/m_ipt.o//' tc/Makefile" ${_logfile}
    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make DOCDIR=/usr/share/doc/${_pkgname}-${_pkgver} install" "make DOCDIR=/usr/share/doc/${_pkgname}-${_pkgver} install" ${_logfile}

    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

kbd() {
    local   _pkgname="kbd"
    local   _pkgver="2.0.4"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ patch -Np1 -i ../../SOURCES/kbd-2.0.4-backspace-1.patch" "patch -Np1 -i ../../SOURCES/kbd-2.0.4-backspace-1.patch" ${_logfile}
    build "+ sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure" "sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure" ${_logfile}
    build "+ sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in" "sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ PKG_CONFIG_PATH=/tools/lib/pkgconfig ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-vlock" "PKG_CONFIG_PATH=/tools/lib/pkgconfig ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-vlock" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ mkdir -v /usr/share/doc/${_pkgname}-${_pkgver}" "mkdir -v /usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build "+ cp -R -v ../${_pkgname}-${_pkgver}/docs/doc/* /usr/share/doc/${_pkgname}-${_pkgver}" "cp -R -v ../${_pkgname}-${_pkgver}/docs/doc/* /usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

libpipeline() {
    local   _pkgname="libpipeline"
    local   _pkgver="1.5.0"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

make_build() {
    local   _pkgname="make"
    local   _pkgver="4.2.1"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c" "sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ make PERL5LIB=$PWD/tests/ check" "make PERL5LIB=$PWD/tests/ check" ${_logfile}
    build "+ make install" "make install" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

patch_build() {
    local   _pkgname="patch"
    local   _pkgver="2.7.6"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

dbus() {
    local   _pkgname="dbus"
    local   _pkgver="1.12.4"
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
}

util_linux() {
    local   _pkgname="util-linux"
    local   _pkgver="2.31.1"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ mkdir -pv /var/lib/hwclock" "mkdir -pv /var/lib/hwclock" ${_logfile}
    build "+ rm -vf /usr/include/{blkid,libmount,uuid}" "rm -vf /usr/include/{blkid,libmount,uuid}" ${_logfile}
    build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure ADJTIME_PATH=/var/lib/hwclock/adjtime --docdir=/usr/share/doc/util-linux-2.31.1 --disable-chfn-chsh --disable-login --disable-nologin --disable-su --disable-setpriv --disable-runuser --disable-pylibmount --disable-static --without-python" "../${_pkgname}-${_pkgver}/configure ADJTIME_PATH=/var/lib/hwclock/adjtime --docdir=/usr/share/doc/util-linux-2.31.1 --disable-chfn-chsh --disable-login --disable-nologin --disable-su --disable-setpriv --disable-runuser --disable-pylibmount --disable-static --without-python" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install" "make install" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

man_db() {
    local   _pkgname="man-db"
    local   _pkgver="2.8.1"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/man-db-2.8.1 --sysconfdir=/etc --disable-setuid --enable-cache-owner=bin --with-browser=/usr/bin/lynx --with-vgrind=/usr/bin/vgrind --with-grap=/usr/bin/grap" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --docdir=/usr/share/doc/man-db-2.8.1 --sysconfdir=/etc --disable-setuid --enable-cache-owner=bin --with-browser=/usr/bin/lynx --with-vgrind=/usr/bin/vgrind --with-grap=/usr/bin/grap" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ sed -i \"s:man man:root root:g\" /usr/lib/tmpfiles.d/man-db.conf" "sed -i \"s:man man:root root:g\" /usr/lib/tmpfiles.d/man-db.conf" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

tar_build() {
    local   _pkgname="tar"
    local   _pkgver="1.30"
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
    build "+ FORCE_UNSAFE_CONFIGURE=1 ../${_pkgname}-${_pkgver}/configure --prefix=/usr --bindir=/bin" "FORCE_UNSAFE_CONFIGURE=1 ../${_pkgname}-${_pkgver}/configure --prefix=/usr --bindir=/bin" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ make -C doc install-html docdir=/usr/share/doc/${_pkgname}-${_pkgver}" "make -C doc install-html docdir=/usr/share/doc/${_pkgname}-${_pkgver}" ${_logfile}

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

texinfo_build() {
    local   _pkgname="texinfo"
    local   _pkgver="6.5"
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
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static" "../${_pkgname}-${_pkgver}/configure --prefix=/usr --disable-static" ${_logfile}
    build "+ make" "make" ${_logfile}
    #build "+ make check" "make check" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ pushd /usr/share/info" "pushd /usr/share/info" ${_logfile}
    build "+ rm -v dir" "rm -v dir" ${_logfile}
    for f in *; do
    build "+     install-info $f dir 2>/dev/null" "    install-info $f dir 2>/dev/null" ${_logfile}
    done
    build "+ popd" "popd" ${_logfile}
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

vim_build() {
    local   _pkgname="vim"
    local   _pkgver="8.0.586"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build "+ mv vim?? vim-${_pkgver}" "mv vim?? vim-${_pkgver}" ${_logfile}
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ echo '#define SYS_VIMRC_FILE \"/etc/vimrc\"' >> src/feature.h" "echo '#define SYS_VIMRC_FILE \"/etc/vimrc\"' >> src/feature.h" ${_logfile}
    build "+ sed -i '/call/{s/split/xsplit/;s/303/492/}' src/testdir/test_recover.vim" "sed -i '/call/{s/split/xsplit/;s/303/492/}' src/testdir/test_recover.vim" ${_logfile}
    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make -j1 test &> vim-test.log" "make -j1 test &> vim-test.log" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ ln -sv vim /usr/bin/vi" "ln -sv vim /usr/bin/vi" ${_logfile}
    for L in  /usr/share/man/{,*/}man1/vim.1; do
        build "+ ln -sv vim.1 $(dirname $L)/vi.1" "ln -sv vim.1 $(dirname $L)/vi.1" ${_logfile}
    done
    build "+ ln -sv ../vim/vim80/doc /usr/share/doc/vim-8.0.586" "ln -sv ../vim/vim80/doc /usr/share/doc/vim-8.0.586" ${_logfile}
    msg_line "Creating /etc/vimrc"
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1 

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" (this one to fix my syntax hightlighting)
" End /etc/vimrc
EOF
    msg_success
    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

nspr_build() {
    local   _pkgname="nspr"
    local   _pkgver="4.18"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ cd nspr" "cd nspr" ${_logfile}
    build "+ sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in" "sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in" ${_logfile}
    build "+ sed -i 's#\$(LIBRARY) ##'            config/rules.mk" "sed -i 's#\$(LIBRARY) ##'            config/rules.mk" ${_logfile}
    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ./configure --prefix=/usr --with-mozilla --with-pthreads $([ $(uname -m) = x86_64 ] && echo --enable-64bit)" "./configure --prefix=/usr --with-mozilla --with-pthreads $([ $(uname -m) = x86_64 ] && echo --enable-64bit)" ${_logfile}
    build "+ make" "make" ${_logfile}

    build "+ make install" "make install" ${_logfile}

    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

nss_build() {
    local   _pkgname="nss"
    local   _pkgver="3.35"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
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
}

popt_build() {
    local   _pkgname="popt"
    local   _pkgver="1.16"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ ./configure --prefix=/usr --disable-static" "./configure --prefix=/usr --disable-static" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}

readline_build() {
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
}

elfutils() {
    local   _pkgname="elfutils"
    local   _pkgver="0.170"
    local   _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    local   _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ ./configure --prefix=/usr --bindir=/usr/bin --program-prefix=\"eu-\" --disable-silent-rules" "./configure --prefix=/usr --bindir=/usr/bin --program-prefix=\"eu-\" --disable-silent-rules" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make install" "make install" ${_logfile}
   
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
}


# Build all packages from shell scripts

change_ownership
files_and_symlinks
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
gmp
mpfr
mpc
gcc_build
bzip2_build
pkg_config
ncurses
attr_build
acl
libcap
sed_build
shadow
# set root password
psmisc
iana_etc_2
bison_build
flex_build
grep_build
bash_build
libtool
gdbm
gperf
expat
inetutils
perl_build
xml_parser
intltool
autoconf_build
automake_build
xz_build
kmod_build
gettext_build
libelf
libffi
openssl_build
python3_build
ninja_build
meson
systemd
procps_ng
e2fsprogs
coreutils
check
diffutils
gawk_build
findutils
groff_build
grub_build
less_build
gzip_build
iproute2
kbd
libpipeline
make_build
patch_build
dbus
util_linux
man_db
tar_build
texinfo_build
vim_build

# Build the RPM Package Manager
# we've already built zlib
#zlib
nspr_build
nss_build
popt_build
readline_build
elfutils
rpm_build

# Build the EFI boot system
dosfstools
pciutils
efivar
efibootmgr

#
#strip_debug
#clean_up
#
