Summary:	pkg-config package contains a tool for passing the include and library paths
Name:		pkg-config
Version:	0.29.2
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	https://pkg-config.freedesktop.org/releases/%{name}-%{version}.tar.gz
%description
	The pkg-config package contains a tool for passing the include path and/or
	library paths to build tools during the configure and make file execution.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--with-internal-glib \
		--disable-host-tool \
		--docdir=%{_docdir}/%{NAME}-%{VERSION}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot}%{_infodir} -name 'dir' -delete
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_mandir}/man1/*.gz
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 0.29.2-1
-	Initial build.	First version
