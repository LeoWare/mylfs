%global debug_package %{nil}
#-----------------------------------------------------------------------------
#	package
Summary:	Meta package to build Chapter 5 tool chain
Name:		tools
Version:	8.2
Release:	1
License:	None
URL:		None
Group:		LFS/Tools
Vendor:	Octothorpe
#
#	LFS tool chain packages
#
Requires:	tools-fetch
Requires:	tools-binutils-pass-1
Requires:	tools-gcc-pass-1
Requires:	tools-linux-api-headers
Requires:	tools-glibc
Requires:	tools-libstdc
Requires:	tools-binutils-pass-2
Requires:	tools-gcc-pass-2
Requires:	tools-tcl-core
Requires:	tools-expect
Requires:	tools-dejagnu
Requires:	tools-m4
Requires:	tools-ncurses
Requires:	tools-bash
Requires:	tools-bison
Requires:	tools-bzip2
Requires:	tools-coreutils
Requires:	tools-diffutils
Requires:	tools-file
Requires:	tools-findutils
Requires:	tools-gawk
Requires:	tools-gettext
Requires:	tools-grep
Requires:	tools-gzip
Requires:	tools-make
Requires:	tools-patch
Requires:	tools-perl
Requires:	tools-sed
Requires:	tools-tar
Requires:	tools-texinfo
Requires:	tools-util-linux
Requires:	tools-xz
#
#	RPM tool chain packages
#
Requires:	tools-zlib
Requires:	tools-libelf
Requires:	tools-openssl
Requires:	tools-popt
Requires:	tools-rpm
Requires:	tools-post
%description
Meta package to build Chapter 5 tool chain
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
