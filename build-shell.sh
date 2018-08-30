#!/tools/bin/bash
set -o errexit
set -o nounset
set +h
source ./config.inc
source ./function.inc

linux_api_headers() {
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

	build " make mrproper" "make mrproper" ${_logfile}
	build " make INSTALL_HDR_PATH=dest headers_install" "make INSTALL_HDR_PATH=dest headers_install" ${_logfile}
	find dest/include \( -name .install -o -name ..install.cmd \) -delete
	cp -rv dest/include/* /usr/include

    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0

}

# Build all packages from shell scripts

linux_api_headers
man_pages
glibc
adjust-toolchain
zlib
file
readline
m4
bc
binutils
gmp
mpfr
gcc
bzip2
pkg_config
ncurses
attr
acl
libcap
sed_build
shadow
psmisc
iana_etc_2
bison
flex
grep_build
bash
libtool
gdbm
gperf
expat
inetutils
perl
xml_parser
intltool
autoconf
automake
xz
kmod
gettext
libelf
libiffi
openssl
python3
ninja
meson
systemd
procps_ng
e2fsprogs
coreutils
check
gawk
findutils
groff
grub
less_build
gzip
iproute2
kbd
libpipeline
make
patch
dbus
util_linux
mandb
tar
texinfo
vim

strip_debug
clean_up
