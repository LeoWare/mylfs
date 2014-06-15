Summary:	Contains the GNU compiler collection
Name:		gcc
Version:	4.8.2
Release:	0
License:	GPLv2
URL:		http://gcc.gnu.org
Group:		Development/Tools
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://ftp.gnu.org/gnu/gcc/%{name}-%{version}/%{name}-%{version}.tar.bz2
Provides:	libgcc_s.so.1
Provides:       libgcc_s.so.1(GCC_3.0)
Provides:       libgcc_s.so.1(GCC_3.3)
Provides:       libgcc_s.so.1(GCC_3.4)
Provides:       libgcc_s.so.1(GCC_4.2.0)
Provides:       libgcc_s.so.1(GLIBC_2.0)
%ifarch x86_64
Provides:	libgcc_s.so.1()(64bit)
Provides:	libgcc_s.so.1(GCC_3.0)(64bit)
Provides:	libgcc_s.so.1(GCC_3.3)(64bit)
Provides:	libgcc_s.so.1(GCC_3.4)(64bit)
Provides:	libgcc_s.so.1(GCC_4.2.0)(64bit)
%endif
%description
The GCC package contains the GNU compiler collection,
which includes the C and C++ compilers.
%prep
%setup -q
case `uname -m` in
	i?86) sed -i 's/^T_CFLAGS =$/& -fomit-frame-pointer/' gcc/Makefile.in ;;
esac
sed -i -e /autogen/d -e /check.sh/d fixincludes/Makefile.in
mv -v libmudflap/testsuite/libmudflap.c++/pass41-frag.cxx{,.disable}
install -vdm 755 ../gcc-build
%build
cd ../gcc-build
SED=sed \
../%{name}-%{version}/configure \
	--prefix=%{_prefix} \
	--enable-shared \
	--enable-threads=posix \
	--enable-__cxa_atexit \
	--enable-clocale=gnu \
	--enable-languages=c,c++ \
	--disable-multilib \
	--disable-bootstrap \
	--with-system-zlib \
	--disable-silent-rules
make %{?_smp_mflags}
%install
cd ../gcc-build
make DESTDIR=%{buildroot} install
find %{buildroot}%{_libdir} -name '*.la' -delete
install -vdm 755 %{buildroot}/%_lib
ln -sv %{_bindir}/cpp %{buildroot}/%{_lib}
ln -sv gcc %{buildroot}%{_bindir}/cc
install -vdm 755 %{buildroot}%{_datarootdir}/gdb/auto-load%{_lib}
%ifarch x86_64
	mv -v %{buildroot}%{_lib64dir}/*gdb.py %{buildroot}%{_datarootdir}/gdb/auto-load%{_lib}
%else
	mv -v %{buildroot}%{_libdir}/*gdb.py %{buildroot}%{_datarootdir}/gdb/auto-load%{_lib}
%endif
rm -rf %{buildroot}%{_infodir}
%check
cd ../gcc-build
ulimit -s 32768
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
%{_lib}/cpp
#	Executables
%{_bindir}/*
#	Includes
%dir %{_includedir}/c++
%dir %{_includedir}/c++/%{version}
     %{_includedir}/c++/%{version}/*
#	Libraries
%ifarch x86_64
%{_lib64dir}/*
%endif
%{_libdir}/*
#	Library executables
%{_libexecdir}/gcc/*
#	Python files
%dir %{_datarootdir}/gcc-%{version}/python/libstdcxx
     %{_datarootdir}/gcc-%{version}/python/libstdcxx/*
#	Internationalization
%lang(be)%{_datarootdir}/locale/be/LC_MESSAGES/*.mo
%lang(ca)%{_datarootdir}/locale/ca/LC_MESSAGES/*.mo
%lang(da)%{_datarootdir}/locale/da/LC_MESSAGES/*.mo
%lang(de)%{_datarootdir}/locale/de/LC_MESSAGES/*.mo
%lang(el)%{_datarootdir}/locale/el/LC_MESSAGES/*.mo
%lang(eo)%{_datarootdir}/locale/eo/LC_MESSAGES/*.mo
%lang(es)%{_datarootdir}/locale/es/LC_MESSAGES/*.mo
%lang(fi)%{_datarootdir}/locale/fi/LC_MESSAGES/*.mo
%lang(fr)%{_datarootdir}/locale/fr/LC_MESSAGES/*.mo
%lang(hr)%{_datarootdir}/locale/hr/LC_MESSAGES/*.mo
%lang(id)%{_datarootdir}/locale/id/LC_MESSAGES/*.mo
%lang(ja)%{_datarootdir}/locale/ja/LC_MESSAGES/*.mo
%lang(nl)%{_datarootdir}/locale/nl/LC_MESSAGES/*.mo
%lang(ru)%{_datarootdir}/locale/ru/LC_MESSAGES/*.mo
%lang(sr)%{_datarootdir}/locale/sr/LC_MESSAGES/*.mo
%lang(sv)%{_datarootdir}/locale/sv/LC_MESSAGES/*.mo
%lang(tr)%{_datarootdir}/locale/tr/LC_MESSAGES/*.mo
%lang(uk)%{_datarootdir}/locale/uk/LC_MESSAGES/*.mo
%lang(vi)%{_datarootdir}/locale/vi/LC_MESSAGES/*.mo
%lang(zh_CN)%{_datarootdir}/locale/zh_CN/LC_MESSAGES/*.mo
%lang(zh_TW)%{_datarootdir}/locale/zh_TW/LC_MESSAGES/*.mo
#	Man pages
%{_mandir}/man1/*.gz
%{_mandir}/man7/*.gz
%{_datadir}/gdb/*
%changelog
*	Tue Apr 01 2014 baho-utot <baho-utot@columbus.rr.com> 4.8.2-0
*	Fri Jun 28 2013 baho-utot <baho-utot@columbus.rr.com> 4.8.1-1
*	Mon Apr 1 2013 baho-utot <baho-utot@columbus.rr.com> 4.8.0-1
*	Thu Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 4.7.2-1