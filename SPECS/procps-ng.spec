Summary:	Programs for monitoring processes
Name:		procps-ng
Version:	3.3.9
Release:	0
License:	GPLv2
URL:		http://procps.sourceforge.net/
Group:		Applications/System
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://sourceforge.net/projects/procps-ng/files/Production/%{name}-%{version}.tar.xz
%description
The Procps package contains programs for monitoring processes.
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--exec-prefix= \
	--libdir=%{_libdir} \
	--docdir=%{_defaultdocdir}/%{name}-%{version} \
	--disable-static \
	--disable-kill \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
install -vdm 755 %{buildroot}/bin
install -vdm 755 %{buildroot}/%{_lib}
mv -v %{buildroot}/usr/bin/pidof %{buildroot}/bin
mv -v %{buildroot}%{_libdir}/libprocps.so.* %{buildroot}/%{_lib}
ln -sfv ../..%{_lib}/$(readlink %{buildroot}/%{_libdir}/libprocps.so) %{buildroot}/%{_libdir}/libprocps.so
find %{buildroot} -name '*.la' -delete
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
/bin/*
/sbin/*
%{_lib}/*
%{_bindir}/*
%{_includedir}/*
%{_libdir}/*
%{_defaultdocdir}/*
%{_mandir}/*/*
%changelog
*	Sat Apr 05 2014 baho-utot <baho-utot@columbus.rr.com> 3.3.9-0
*	Fri Jun 28 2013 baho-utot <baho-utot@columbus.rr.com> 3.3.8-1
*	Mon Apr 1 2013 baho-utot <baho-utot@columbus.rr.com> 3.3.7-1
*	Wed Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 0:3.3.6-1
