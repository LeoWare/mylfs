Summary:	Library for manipulating pipelines
Name:		libpipeline
Version:	1.2.6
Release:	1
License:	GPLv3
URL:		http://libpipeline.nongnu.org
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
Source:		 http://download.savannah.gnu.org/releases/libpipeline/%{name}-%{version}.tar.gz
%description
Contains a library for manipulating pipelines of sub processes
in a flexible and convenient way.
%prep
%setup -q
sed -i -e '/gets is a/d' gnulib/lib/stdio.in.h
%build
PKG_CONFIG_PATH=/tools/lib/pkgconfig \
	./configure \
	--prefix=%{_prefix} \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
find %{buildroot}/%{_libdir} -name '*.la' -delete
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
%{_includedir}/*
%{_libdir}/*.so
%{_libdir}/*.so.*
%{_libdir}/pkgconfig/libpipeline.pc
%{_mandir}/*/*
%changelog
*	Sun Apr 06 2014 baho-utot <baho-utot@columbus.rr.com> 1.2.6-1
*	Fri Jun 28 2013 baho-utot <baho-utot@columbus.rr.com> 1.2.4-1
*	Fri May 10 2013 baho-utot <baho-utot@columbus.rr.com> 1.2.3-1
*	Wed Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 1.2.2-1
-	Upgrade version
