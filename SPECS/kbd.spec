#TARBALL:	https://www.kernel.org/pub/linux/utils/kbd/kbd-2.0.4.tar.xz
#MD5SUM:	c1635a5a83b63aca7f97a3eab39ebaa6;SOURCES/kbd-2.0.4.tar.xz
#TARBALL:	http://www.linuxfromscratch.org/patches/lfs/8.2/kbd-2.0.4-backspace-1.patch
#MD5SUM:	f75cca16a38da6caa7d52151f7136895;SOURCES/kbd-2.0.4-backspace-1.patch
#-----------------------------------------------------------------------------
Summary:	The Kbd package contains key-table files, console fonts, and keyboard utilities.
Name:		kbd
Version:	2.0.4
Release:	1
License:	Other
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	https://www.kernel.org/pub/linux/utils/kbd/%{name}-%{version}.tar.xz
Patch0:	kbd-2.0.4-backspace-1.patch
%description
The Kbd package contains key-table files, console fonts, and keyboard utilities.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
%patch0 -p1
	sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
	sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
%build
	PKG_CONFIG_PATH=/tools/lib/pkgconfig \
	./configure \
		--prefix=%{_prefix} \
		--disable-vlock
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}%{_docdir}/%{NAME}-%{VERSION}
	cp -R -v docs/doc/* %{buildroot}%{_docdir}/%{NAME}-%{VERSION}
#-----------------------------------------------------------------------------
#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
#-----------------------------------------------------------------------------
#	Create file list
#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,root,root)
#	%%{_infodir}/*.gz
	%{_mandir}/man1/*.gz
	%{_mandir}/man5/*.gz
	%{_mandir}/man8/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 2.0.4-1
-	Initial build.	First version
