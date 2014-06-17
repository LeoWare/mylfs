Summary:	Functions for multiple precision math
Name:		mpfr
Version:	3.1.2
Release:	1
License:	GPLv3
URL:		http://www.mpfr.org
Group:		Applications/System
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://www.mpfr.org/%{name}-%{version}/%{name}-%{version}.tar.xz
%description
The MPFR package contains functions for multiple precision math.
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--enable-thread-safe \
	--docdir=%{_defaultdocdir}/%{name}-%{version} \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
find %{buildroot}%{_libdir} -name '*.la' -delete
rm -rf %{buildroot}%{_infodir}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
%{_includedir}/*.h
%{_libdir}/*.a
%{_libdir}/*.so
%{_libdir}/*.so.*
%{_defaultdocdir}/%{name}-%{version}/*
%changelog
*	Sat Apr 20 2013 baho-utot <baho-utot@columbus.rr.com> 3.1.2-1
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 3.1.1-1
-	Initial build.	First version
