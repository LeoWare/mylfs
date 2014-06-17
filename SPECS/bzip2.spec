Summary:	Contains programs for compressing and decompressing files
Name:		bzip2
Version:	1.0.6
Release:	1
License:	BSD
URL:		http://www.bzip.org/
Group:		LFS/Base
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://www.bzip.org/%{version}/%{name}-%{version}.tar.gz
Patch0:		http://www.linuxfromscratch.org/patches/lfs/7.2/bzip2-1.0.6-install_docs-1.patch
%description
The Bzip2 package contains programs for compressing and
decompressing files.  Compressing text files with bzip2 yields a much better
compression percentage than with the traditional gzip.
%prep
%setup -q
%patch0 -p1
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
%build
make VERBOSE=1 %{?_smp_mflags} -f Makefile-libbz2_so
make clean
make VERBOSE=1 %{?_smp_mflags}
%install
make PREFIX=%{buildroot}/usr install
install -vdm 0755 %{buildroot}/%{_lib}
install -vdm 0755 %{buildroot}/bin
cp -v bzip2-shared %{buildroot}/bin/bzip2
cp -av libbz2.so* %{buildroot}/%{_lib}
install -vdm 755 %{buildroot}%{_libdir}
ln -sv ../../%{_lib}/libbz2.so.1.0 %{buildroot}%{_libdir}/libbz2.so
rm -v %{buildroot}%{_bindir}/{bunzip2,bzcat}
ln -sv bzip2 %{buildroot}/bin/bunzip2
ln -sv bzip2 %{buildroot}/bin/bzcat
find %{buildroot} -name '*.a'  -delete
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
/bin/*
%{_lib}/*
%{_bindir}/*
%{_libdir}/*
%{_includedir}/*
%{_defaultdocdir}/%{name}-%{version}/*
%{_mandir}/*/*
%changelog
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 1.0.6-1
-	Initial build.	First version
