Summary:	The Binutils package contains a linker, an assembler, and tools
Name:		tools-binutils-pass-1
Version:	2.29
Release:	1
License:	GPLv2
URL:		http://www.gnu.org/software/binutils
Group:		LFS/Tools
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source:		http://ftp.gnu.org/gnu/binutils/binutils-%{version}.tar.bz2
%description
The Binutils package contains a linker, an assembler,
and other tools for handling object files.
%prep
%setup -q -n binutils-%{version}
	mkdir -v build
%build
	cd build
	 ../configure --prefix=%{_prefix} \
		--with-sysroot=%{_lfs} \
		--with-lib-path=/tools/lib \
		--target=%{_lfs_tgt} \
		--disable-nls \
		--disable-werror
	make %{?_smp_mflags}
%install
	cd build
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/tools/lib
	ln -sv lib %{buildroot}/tools/lib64
	rm -rf %{buildroot}/tools/share
	cd -
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,lfs,lfs)
	%dir	/tools/lib
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 2.29-1
-	LFS-8.1