#TARBALL:	http://prdownloads.sourceforge.net/expat/expat-2.2.5.tar.bz2
#MD5SUM:	789e297f547980fc9ecc036f9a070d49;SOURCES/expat-2.2.5.tar.bz2
#-----------------------------------------------------------------------------
Summary:	The Expat package contains a stream oriented C library for parsing XML.
Name:		expat
Version:	2.2.5
Release:	1
License:	Other
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	http://prdownloads.sourceforge.net/expat/%{name}-%{version}.tar.bz2
%description
The Expat package contains a stream oriented C library for parsing XML.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i 's|usr/bin/env |bin/|' run.sh.in
%build
	./configure \
		--prefix=%{_prefix} \
		--disable-static
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -v -dm755 %{buildroot}%{_docdir}/%{name}-%{version}
	install -v -m644 doc/*.{html,png,css} %{buildroot}%{_docdir}/%{name}-%{version}
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
	%{_mandir}/man1/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 2.2.5-1
-	Initial build.	First version
