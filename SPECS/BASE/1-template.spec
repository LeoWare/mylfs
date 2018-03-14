Summary:	
Name:		
Version:	
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	%{name}-%{version}
%description
	
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	CFLAGS='%_optflags ' \
	CXXFLAGS='%_optflags ' \
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	rm -rf %{buildroot}/%{_infodir}
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