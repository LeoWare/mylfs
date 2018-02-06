Summary:	pkg-config package contains a tool for passing the include and library paths
Name:		pkg-config
Version:	0.29.2
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
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
		--docdir=/usr/share/doc/pkg-config-0.29.2
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version