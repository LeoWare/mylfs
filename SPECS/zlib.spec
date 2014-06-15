Summary:	Compression and decompression routines
Name:		zlib
Version:	1.2.8
Release:	0
URL:		http://www.zlib.net/
License:	MIT
Group:		Applications/System
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://www.zlib.net/%{name}-%{version}.tar.xz
%description
Compression and decompression routines
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix}
make V=1 %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
install -vdm 755 %{buildroot}/%{_lib}
mv -v %{buildroot}/%{_libdir}/libz.so.* %{buildroot}/%{_lib}
ln -sfv ../../lib/$(readlink %{buildroot}%{_libdir}/libz.so) %{buildroot}%{_libdir}/libz.so
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
%{_lib}/libz.so.1
%{_lib}/libz.so.1.2.8
%{_includedir}/*.h
%{_libdir}/libz.a
%{_libdir}/libz.so
%{_libdir}/pkgconfig/zlib.pc
%{_mandir}/man3/zlib.3.gz
%changelog
*	Sat Mar 22 2014 baho-utot <baho-utot@columbus.rr.com> 1.2.8-0
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 1.2.7-1
