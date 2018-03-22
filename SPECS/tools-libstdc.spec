Summary:	Libstdc++ is the standard C++ library.
Name:		tools-libstdc
Version:	7.3.0
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/gcc
Group:		LFS/Tools
Vendor:	Octothorpe
Requires:	tools-glibc
Source0:	http://ftp.gnu.org/gnu/gcc/gcc-%{version}/gcc-%{version}.tar.xz
%description
	Libstdc++ is the standard C++ library. It is needed for the correct operation of the g++ compiler.
%prep
%setup -q -n gcc-%{version}
mkdir -v build
%build
	cd build
	../libstdc++-v3/configure \
		--host=%{_lfs_tgt} \
		--prefix=%{_prefix} \
		--disable-multilib \
		--disable-nls \
		--disable-libstdcxx-threads \
		--disable-libstdcxx-pch \
		--with-gxx-include-dir=%{_prefix}/%{_lfs_tgt}/include/c++/%{version}
	make %{?_smp_mflags}
%install
	cd build
	make DESTDIR=%{buildroot} install
	cd -
	find %{buildroot}%{_prefix} -name '*.la' -delete
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,lfs,lfs)
#	/tools/x86_64-lfs-linux-gnu/include/c++/7.3.0/iomanip
#	/tools/x86_64-lfs-linux-gnu/include/c++/7.3.0/tr1/riemann_zeta.tcc
%changelog
*	Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 7.3.0-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 7.2.0-1
-	LFS-8.1
