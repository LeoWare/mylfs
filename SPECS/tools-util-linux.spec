%global debug_package %{nil}
#TARBALL:	https://www.kernel.org/pub/linux/utils/util-linux/v2.31/util-linux-2.31.1.tar.xz
#MD5SUM:	7733b583dcb51518944d42aa62ef19ea;SOURCES/util-linux-2.31.1.tar.xz
#PATCHES:
#FILE:		util-linux-2.31.1.tar.xz.md5sum
#-----------------------------------------------------------------------------
Summary:	The Util-linux package contains miscellaneous utility programs.
Name:		tools-util-linux
Version:	2.31.1
Release:	1
License:	GPL
URL:		https://www.kernel.org/pub/linux/utils/util-linux/v2.30
Group:		LFS/Tools
Vendor:	Octothorpe
Source0:	https://www.kernel.org/pub/linux/utils/util-linux/v2.30/util-linux-%{version}.tar.xz
%description
The Util-linux package contains miscellaneous utility programs.
#-----------------------------------------------------------------------------
%prep
%setup -q -n util-linux-%{version}
%build
	./configure --prefix=%{_prefix} \
		--without-python \
		--disable-makeinstall-chown \
		--without-systemdsystemunitdir \
		--without-ncurses \
		PKG_CONFIG=""
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
#	Remove /tools/bin/kill, installed by tools-coreutils package
	rm 	%{buildroot}/tools/bin/kill
	rm -rf %{buildroot}%{_infodir}
	rm -rf %{buildroot}%{_mandir}
	rm -rf %{buildroot}%{_datarootdir}/locale
#-----------------------------------------------------------------------------
#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
#-----------------------------------------------------------------------------
%changelog
*	Tue Mar 13 2018 baho-utot <baho-utot@columbus.rr.com> 2.31.1-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 2.30.1-1
-	LFS-8.1
