Summary:	The Binutils package contains a linker, an assembler, and other tools for handling object files. 
Name:		tools-binutils-pass-2
Version:	2.29
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/binutils
Group:		LFS/Tools
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source0:	http://ftp.gnu.org/gnu/binutils/binutils-%{version}.tar.bz2
%description
	The Binutils package contains a linker, an assembler, and other tools for handling object files. 
%prep
%setup -q -n binutils-%{version}
%build
	mkdir -v build
	cd       build
	CC=%{_lfs_tgt}-gcc \
	AR=%{_lfs_tgt}-ar \
	RANLIB=%{_lfs_tgt}-ranlib \
	../configure \
		--prefix=%{_prefix} \
		--disable-nls \
		--disable-werror \
		--with-lib-path=/tools/lib \
		--with-sysroot
	make %{?_smp_mflags}
	make -C ld clean
	make -C ld LIB_PATH=/usr/lib:/lib
	install -vdm 755 %{buildroot}/tools/bin
	cp -v ld/ld-new  %{buildroot}/tools/bin
%install
	cd build
	make DESTDIR=%{buildroot} install
	make -C ld clean
	make -C ld LIB_PATH=/usr/lib:/lib
	cp -v ld/ld-new /tools/bin
	cd -
	rm -rf %{buildroot}/tools/share/info
	rm -rf %{buildroot}/tools/share/man
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 2.29-1
-	LFS-8.1