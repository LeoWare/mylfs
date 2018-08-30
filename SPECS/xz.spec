Summary:	Programs for compressing and decompressing files
Name:		xz
Version:	5.0.5
Release:	1
URL:		http://tukaani.org/xz
License:	GPLv2
Group:		Applications/File
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://tukaani.org/xz/%{name}-%{version}.tar.xz
%description
The Xz package contains programs for compressing and
decompressing files
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--docdir=%{_defaultdocdir}/%{name}-%{version} \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} pkgconfigdir=%{_libdir}/pkgconfig install
install -vdm 755 %{buildroot}/{bin,%_lib}
mv -v   %{buildroot}%{_bindir}/{lzma,unlzma,lzcat,xz,unxz,xzcat} %{buildroot}/bin
mv -v %{buildroot}%{_libdir}/liblzma.so.* %{buildroot}%{_lib}
ln -svf "../..%{_lib}/$(readlink %{buildroot}%{_libdir}/liblzma.so)" %{buildroot}%{_libdir}/liblzma.so
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
%{_defaultdocdir}/%{name}-%{version}/*
%{_mandir}/*/*
%{_libdir}/pkgconfig/liblzma.pc
%changelog
*	Sat Aug 24 2013 baho-utot <baho-utot@columbus.rr.com> 5.0.5-1
-	Update version
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 5.0.4-1
-	Initial build.	First version
