
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
shadow() {
    _pkgname="shadow"
    _pkgver="4.5"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
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
