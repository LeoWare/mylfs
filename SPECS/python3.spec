#-----------------------------------------------------------------------------
Summary:	The Python 3 package contains the Python development environment.
Name:		python3
Version:	3.6.4
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	Python-%{VERSION}.tar.xz
Source1:	python-%{VERSION}-docs-html.tar.bz2
BuildRequires:	openssl
%description
	The Python 3 package contains the Python development environment.
	This is useful for object-oriented programming, writing scripts,
	prototyping large programs or developing entire applications.
#-----------------------------------------------------------------------------
%prep
cd %{_builddir}
%setup -q -n "Python-%{VERSION}"
%setup -q -T -D -a 1  -n Python-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--enable-shared \
		--with-system-expat \
		--with-system-ffi \
		--with-ensurepip=yes
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	chmod -v 755 %{buildroot}/usr/lib/libpython3.6m.so
	chmod -v 755 %{buildroot}/usr/lib/libpython3.so
	install -v -dm755 %{buildroot}/usr/share/doc/python-%{version}/html
	cp -var python-%{version}-docs-html/* %{buildroot}/usr/share/doc/python-%{version}/html
#-----------------------------------------------------------------------------
#	Copy license/copying file 
	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE

	rm "%{buildroot}/usr/lib/python3.6/site-packages/setuptools/command/launcher manifest.xml"
	rm "%{buildroot}/usr/lib/python3.6/site-packages/setuptools/script (dev).tmpl"
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
*	Fri Jul 17 2018 baho-utot <baho-utot@columbus.rr.com> Python-3.6.4-1
-	Initial build.	First version
