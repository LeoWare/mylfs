Summary:	Programs for compressing and decompressing files
Name:		xz
Version:	5.2.3
Release:	1
URL:		http://tukaani.org/xz
License:	GPLv2
Group:		Applications/File
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://tukaani.org/xz/%{name}-%{version}.tar.xz
%description
The Xz package contains programs for compressing and
decompressing files
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--docdir=%{_docdir}/%{name}-%{version} \
	--disable-static
make %{?_smp_mflags}
%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT install
install -vdm 755 %{buildroot}{/bin,%{_lib}}
mv -v %{buildroot}%{_bindir}/{lzma,unlzma,lzcat,xz,unxz,xzcat} %{buildroot}/bin
mv -v %{buildroot}%{_libdir}/liblzma.so.* %{buildroot}%{_lib}
ln -svf ../..%{_lib}/$(readlink %{buildroot}%{_libdir}/liblzma.so) %{buildroot}%{_libdir}/liblzma.so
find %{buildroot}%{_libdir} -name '*.la' -delete
%find_lang %{name}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files -f %{name}.lang
%defattr(-,root,root)
/bin/*
%{_lib}/*
%{_bindir}/*
%{_includedir}/*
%{_libdir}/*
%{_docdir}/%{name}-%{version}/*
%{_mandir}/*/*
%{_libdir}/pkgconfig/liblzma.pc
%changelog
*	Sat Aug 24 2013 baho-utot <baho-utot@columbus.rr.com> 5.0.5-1
-	Update version
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 5.0.4-1
-	Initial build.	First version

