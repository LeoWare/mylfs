Summary:	The Binutils package contains a linker, an assembler, and other tools for handling object files
Name:		binutils
Version:	2.30
Release:	1
License:	GPLv3
URL:		http://ftp.gnu.org
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	http://ftp.gnu.org/gnu/%{name}/%{name}-%{version}.tar.xz
%description
	The Binutils package contains a linker, an assembler, and other tools for handling object files
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	mkdir build
	cd build
	../configure \
		--prefix=%{_prefix} \
		--enable-gold \
		--enable-ld=default \
		--enable-plugins \
		--enable-shared \
		--disable-werror \
		--with-system-zlib
	make %{?_smp_mflags} tooldir=/usr
%install
cd ../binutils-build
make DESTDIR=%{buildroot} tooldir=%{_prefix} install
find %{buildroot} -name '*.la' -delete
rm -rf %{buildroot}/%{_infodir}
%check
cd ../binutils-build
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
#	Executables
%{_bindir}/*
#	Includes
%{_includedir}/*.h
#	Libraries
%{_libdir}/*.a
%{_libdir}/*.so
%dir %{_libdir}/ldscripts
%{_libdir}/ldscripts/*
#	Internationalization
%lang(bg)%{_datarootdir}/locale/bg/LC_MESSAGES/*.mo
%lang(ca)%{_datarootdir}/locale/ca/LC_MESSAGES/*.mo
%lang(da)%{_datarootdir}/locale/da/LC_MESSAGES/*.mo
%lang(de)%{_datarootdir}/locale/de/LC_MESSAGES/*.mo
%lang(eo)%{_datarootdir}/locale/eo/LC_MESSAGES/*.mo
%lang(es)%{_datarootdir}/locale/es/LC_MESSAGES/*.mo
%lang(fi)%{_datarootdir}/locale/fi/LC_MESSAGES/*.mo
%lang(fr)%{_datarootdir}/locale/fr/LC_MESSAGES/*.mo
%lang(ga)%{_datarootdir}/locale/ga/LC_MESSAGES/*.mo
%lang(hr)%{_datarootdir}/locale/hr/LC_MESSAGES/*.mo
%lang(hu)%{_datarootdir}/locale/hu/LC_MESSAGES/*.mo
%lang(id)%{_datarootdir}/locale/id/LC_MESSAGES/*.mo
%lang(it)%{_datarootdir}/locale/it/LC_MESSAGES/*.mo
%lang(ja)%{_datarootdir}/locale/ja/LC_MESSAGES/*.mo
%lang(ms)%{_datarootdir}/locale/ms/LC_MESSAGES/*.mo
%lang(nl)%{_datarootdir}/locale/nl/LC_MESSAGES/*.mo
%lang(pt_BR)%{_datarootdir}/locale/pt_BR/LC_MESSAGES/*.mo
%lang(ro)%{_datarootdir}/locale/ro/LC_MESSAGES/*.mo
%lang(ru)%{_datarootdir}/locale/ru/LC_MESSAGES/*.mo
%lang(rw)%{_datarootdir}/locale/rw/LC_MESSAGES/*.mo
%lang(sk)%{_datarootdir}/locale/sk/LC_MESSAGES/*.mo
%lang(sr)%{_datarootdir}/locale/sr/LC_MESSAGES/*.mo
%lang(sv)%{_datarootdir}/locale/sv/LC_MESSAGES/*.mo
%lang(tr)%{_datarootdir}/locale/tr/LC_MESSAGES/*.mo
%lang(uk)%{_datarootdir}/locale/uk/LC_MESSAGES/*.mo
%lang(vi)%{_datarootdir}/locale/vi/LC_MESSAGES/*.mo
%lang(zh_CN)%{_datarootdir}/locale/zh_CN/LC_MESSAGES/*.mo
%lang(zh_TW)%{_datarootdir}/locale/zh_TW/LC_MESSAGES/*.mo
 #	Manpages
%{_mandir}/man1/*
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 2.30-1
-	Initial build.	First version
