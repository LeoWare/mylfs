Summary:		The MPC package contains a library for the arithmetic of complex numbers
Name:			mpc
Version:		1.1.0
Release:		1
License:		LGPLv3
URL:			Any
Group:			LFS/Base
Vendor:			Octothorpe
Source0:		http://www.multiprecision.org/%{name}/download/%{name}-%{version}.tar.gz
%description
	The MPC package contains a library for the arithmetic of
	complex numbers with arbitrarily high precision and correct
	rounding of the result.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--disable-static \
		--docdir=%{_docdir}/%{NAME}-%{VERSION}
	make %{?_smp_mflags}
	make %{?_smp_mflags} html
%install
	make DESTDIR=%{buildroot} install
	make DESTDIR=%{buildroot} install-html
	#	Copy license/copying file
	install -D -m644 COPYING.LESSER %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_infodir}/*.gz
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 1.1.0-1
-	Initial build.	First version
