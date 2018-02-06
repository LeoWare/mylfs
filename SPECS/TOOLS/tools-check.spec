Summary:	Check is a unit testing framework for C. 
Name:		tools-check
Version:	0.11.0
Release:	1
License:	GPL
URL:		https://github.com/libcheck/check/releases/download/0.11.0
Group:		LFS/Tools
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source0:	https://github.com/libcheck/check/releases/download/%{version}/check-%{version}.tar.gz
%description
	Check is a unit testing framework for C. 
%prep
%setup -q -n check-%{version}
%build
	./configure --prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	rm -rf %{buildroot}/tools/share/doc
	rm -rf %{buildroot}/tools/share/info
	rm -rf %{buildroot}/tools/share/man
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 0.11.0-1
-	LFS-8.1