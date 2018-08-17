Summary:	Contains the GNU compiler collection
Name:		tools-gcc-pass-1
Version:	7.3.0
Release:	1
License:	GPLv2
Group:		LFS/Tools
Vendor:		Octothorpe
BuildRequires:	tools-binutils-pass-1
Source0:	http://ftp.gnu.org/gnu/gcc/gcc-%{version}/gcc-%{version}.tar.xz
Source1:	http://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz
Source2:	http://www.multiprecision.org/mpc/download/mpc-1.1.0.tar.gz
Source3:	http://www.mpfr.org/mpfr-3.1.5/mpfr-4.0.1.tar.xz
%description
	The GCC package contains the GNU compiler collection, which includes the C and C++ compilers.
%prep
%setup -q -n gcc-%{version}
%setup -q -T -D -a 1 -n gcc-%{version}
%setup -q -T -D -a 2 -n gcc-%{version}
%setup -q -T -D -a 3 -n gcc-%{version}
	mv -v mpfr-4.0.1 mpfr
	mv -v gmp-6.1.2 gmp
	mv -v mpc-1.1.0 mpc
	for file in gcc/config/{linux,i386/linux{,64}}.h; do
		cp -uv $file{,.orig}
		sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' -e 's@/usr@/tools@g' $file.orig > $file
		printf "\n" >> ${file}
		printf "%s\n"	'#undef STANDARD_STARTFILE_PREFIX_1'			>> ${file}
		printf "%s\n"	'#undef STANDARD_STARTFILE_PREFIX_2'			>> ${file}
		printf "%s\n"	'#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"'	>> ${file}
		printf "%s\n"	'#define STANDARD_STARTFILE_PREFIX_2 ""'		>> ${file}
		touch ${file}.orig
	done
%ifarch x86_64
	sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
%endif
	mkdir -v build
%build
	cd       build
	../configure \
		--target=%{LFS_TGT} \
		--prefix=%{_prefix} \
		--with-glibc-version=2.11 \
		--with-sysroot=%{_lfsdir} \
		--with-newlib \
		--without-headers \
		--with-local-prefix=%{_prefix} \
		--with-native-system-header-dir=%{_includedir} \
		--disable-nls \
		--disable-shared \
		--disable-multilib \
		--disable-decimal-float \
		--disable-threads \
		--disable-libatomic \
		--disable-libgomp \
		--disable-libmpx \
		--disable-libquadmath \
		--disable-libssp \
		--disable-libvtv \
		--disable-libstdcxx \
		--enable-languages=c,c++
	make %{?_smp_mflags}
%install
	cd build
	make DESTDIR=%{buildroot} install
	cd -
	find %{buildroot}/tools -name '*.la' -delete
	rm -rf %{buildroot}%{_infodir}
	rm -rf %{buildroot}%{_mandir}
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,lfs,lfs)
%changelog
*	Sat Mar 10 2018 baho-utot <baho-utot@columbus.rr.com> 7.3.0-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 7.2.0-1
-	LFS-8.1
