%global debug_package %{nil}
#-----------------------------------------------------------------------------
Summary:	Meta package to build LFS Base
Name:		lfs
Version:	8.2
Release:	1
License:	None
URL:		None
Group:		LFS/Base
Vendor:	Octothorpe
#
#	LFS Chapter 6
#
Requires:	prepare
Requires:	filesystem
Requires:	linux-api-headers
Requires:	man-pages
Requires:	glibc
Requires:	tzdata
Requires:	locales
Requires:	adjust-tool-chain
Requires:	zlib
Requires:	file
Requires:	readline
Requires:	m4
Requires:	bc
Requires:	binutils
Requires:	gmp
Requires:	mpfr
Requires:	mpc
Requires:	gcc
Requires:	gcc-test
Requires:	bzip2
Requires:	pkg-config
Requires:	ncurses
Requires:	attr
Requires:	acl
Requires:	libcap
Requires:	sed
Requires:	shadow
Requires:	psmisc
Requires:	iana-etc
Requires:	bison
Requires:	flex
Requires:	grep
Requires:	bash
Requires:	libtool
Requires:	gdbm
Requires:	gperf
Requires:	expat
Requires:	inetutils
Requires:	perl
Requires:	XML-Parser
Requires:	intltool
Requires:	autoconf
Requires:	automake
Requires:	xz
Requires:	kmod
Requires:	gettext
Requires:	libelf
Requires:	libffi
Requires:	openssl
Requires:	python3
Requires:	ninja
Requires:	meson
Requires:	procps-ng
Requires:	e2fsprogs
Requires:	coreutils
Requires:	diffutils
Requires:	gawk
Requires:	check
Requires:	findutils
Requires:	groff
Requires:	grub
Requires:	less
Requires:	gzip
Requires:	iproute2
Requires:	kbd
Requires:	libpipeline
Requires:	make
Requires:	patch
Requires:	sysklogd
Requires:	sysvinit
Requires:	eudev
Requires:	util-linux
Requires:	man-db
Requires:	tar
Requires:	texinfo
Requires:	vim
Requires:	lfs-bootscripts
Requires:	cpio
Requires:	mkinitramfs
Requires:	linux
Requires:	popt
Requires:	python2
Requires:	rpm
Requires:	wget
Requires:	firmware-radeon
Requires:	firmware-realtek
Requires:	cleanup
Requires:	config
%description
Meta package to build LFS Base
#-----------------------------------------------------------------------------
%prep
%build
%install
%files
	%defattr(-,lfs,lfs)
#-----------------------------------------------------------------------------
%changelog
*	Mon Oct 01 2018 baho-utot <baho-utot@columbus.rr.com> 8.2-1
-	LFS-8.2
