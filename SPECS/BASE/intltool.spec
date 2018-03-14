Summary:	The Intltool is an internationalization tool used for extracting translatable strings from source files. 
Name:		intltool
Version:	0.51.0
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://launchpad.net/intltool/trunk/0.51.0/+download/%{name}-%{version}.tar.gz
%description
	The Intltool is an internationalization tool used for extracting translatable strings from source files. 
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i 's:\\\${:\\\$\\{:' intltool-update.in
%build
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	install -v -Dm644 doc/I18N-HOWTO %{buildroot}/usr/share/doc/%{name}-%{version}/I18N-HOWTO
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	#	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version