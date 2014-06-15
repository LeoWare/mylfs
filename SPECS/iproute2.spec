Summary:	Basic and advanced IPV4-based networking
Name:		iproute2
Version:	3.12.0
Release:	0
License:	GPLv2
URL:		http://www.kernel.org/pub/linux/utils/net/iproute2
Group:		Applications/System
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://www.kernel.org/pub/linux/utils/net/iproute2/%{name}-%{version}.tar.xz
%description
The IPRoute2 package contains programs for basic and advanced
IPV4-based networking.
%prep
%setup -q
sed -i '/^TARGETS/s@arpd@@g' misc/Makefile
sed -i /ARPD/d Makefile
sed -i 's/arpd.8//' man/man8/Makefile
%build
make VERBOSE=1 %{?_smp_mflags} DESTDIR= LIBDIR=%{_libdir}
%install
make	DESTDIR=%{buildroot} \
	MANDIR=%{_mandir} \
	LIBDIR=%{_libdir} \
	DOCDIR=%{_defaultdocdir}/%{name}-%{version} install
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
%{_sysconfdir}/%{name}/*
/sbin/*
%{_libdir}/*
%{_defaultdocdir}/%{name}-%{version}/*
%{_mandir}/*/*
%changelog
*	Sun Apr 06 2014 baho-utot <baho-utot@columbus.rr.com> 3.12.0-0
*	Sat Aug 24 2013 baho-utot <baho-utot@columbus.rr.com> 3.10.0-1
*	Fri May 10 2013 baho-utot <baho-utot@columbus.rr.com> 3.9.0-1
*	Wed Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 3.8.0-1
-	Upgrade version
