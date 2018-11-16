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
systemd() {
    _pkgname="systemd"
    _pkgver="237"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
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
