Summary:	The Binutils package contains a linker, an assembler, and other tools for handling object files.
Name:		tools-binutils-pass-2
Version:	2.30
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/binutils
Group:		LFS/Tools
Vendor:		Octothorpe
BuildRequires:	tools-libstdc
Source0:	http://ftp.gnu.org/gnu/binutils/binutils-%{version}.tar.xz
%description
	The Binutils package contains a linker, an assembler, and other tools for handling object files.
%prep
%setup -q -n binutils-%{version}
mkdir -v build
%build
	cd build
	CC=%{LFS_TGT}-gcc \
	AR=%{LFS_TGT}-ar \
	RANLIB=%{LFS_TGT}-ranlib \
	../configure \
		--prefix=%{_prefix} \
		--disable-nls \
		--disable-werror \
		--with-lib-path=%{_libdir} \
		--with-sysroot
	make %{?_smp_mflags}
%install
	cd build
	install -vdm 755 %{buildroot}%{_bindir}
	make DESTDIR=%{buildroot} install
	make -C ld clean
	make -C ld LIB_PATH=/usr/lib:/lib
	cp -v ld/ld-new %{_bindir}
	cd -
	rm -rf %{buildroot}%{_infodir}
	rm -rf %{buildroot}%{_mandir}
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,lfs,lfs)
%changelog
*	Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 2.30-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 2.29-1
-	LFS-8.1
