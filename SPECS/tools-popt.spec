Summary:	The popt package contains the popt libraries which are used by some programs to parse command-line options.
Name:		tools-popt
Version:	1.16
Release:	1
License:	GPL
URL:		http://rpm5.org/files/popt
Group:		LFS/Tools
Vendor:		Octothorpe
BuildRequires:	tools-openssl
Source0:	http://rpm5.org/files/popt/popt-%{version}.tar.gz
%description
	The popt package contains the popt libraries which are used by some programs to parse command-line options.
%prep
%setup -q -n popt-%{version}
%build
	./configure \
		--prefix=%{_prefix} \
		--disable-shared \
		--enable-static
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	find %{buildroot} -name '*.la' -delete
	rm -rf %{buildroot}%{_datarootdir}
	#	Create file list	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 1.16-1
-	LFS-8.1
