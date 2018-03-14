Summary:	The Expat package contains a stream oriented C library for parsing XML. 
Name:		expat
Version:	2.2.3
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://prdownloads.sourceforge.net/expat/%{name}-%{version}.tar.bz2
%description
	The Expat package contains a stream oriented C library for parsing XML. 
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
	#	install -v -dm755 %{buildroot}/usr/share/doc/%{name}-%{version}
	#	install -v -m644 doc/*.{html,png,css} %{buildroot}/usr/share/doc/%{name}-%{version}
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%clean
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version