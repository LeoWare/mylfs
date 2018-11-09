<<<<<<< HEAD
Summary:	The Zlib package contains compression and decompression routines used by some programs.
Name:		zlib
Version:	1.2.11
Release:	1
License:	Other
URL:		http://zlib.net
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	http://zlib.net/%{name}-%{version}.tar.xz
%description
The Zlib package contains compression and decompression routines used by some programs.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/lib
	install -vdm 755 %{buildroot}/usr/lib
	mv -v %{buildroot}/usr/lib/libz.so.* %{buildroot}/lib
	ln -sfv ../../lib/$(readlink %{buildroot}/usr/lib/libz.so) %{buildroot}/usr/lib/libz.so
	#	Copy license/copying file
	install -vDm644 README %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
	%_mandir/man3/zlib.3.gz
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version
=======
Summary:	Compression and decompression routines
Name:		zlib
Version:	1.2.11
Release:	1
URL:		http://www.zlib.net/
License:	MIT
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
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
%{_lib}/libz.so.1.2.11
%{_includedir}/*.h
%{_libdir}/libz.a
%{_libdir}/libz.so
%{_libdir}/pkgconfig/zlib.pc
%{_mandir}/man3/zlib.3
%changelog
*	Sat Mar 22 2014 baho-utot <baho-utot@columbus.rr.com> 1.2.8-1
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 1.2.7-1
>>>>>>> Initial Commit.
