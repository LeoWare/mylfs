%global debug_package %{nil}
#TARBALL:	http://ftp.gnu.org/gnu/binutils/binutils-2.30.tar.xz
#MD5SUM:	ffc476dd46c96f932875d1b2e27e929f;SOURCES/binutils-2.30.tar.xz
#PATCHES:
#FILE:		binutils-2.30.tar.xz.md5sum
#-----------------------------------------------------------------------------
Summary:	The Binutils package contains a linker, an assembler, and tools
Name:		tools-binutils-pass-1
Version:	2.30
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/binutils
Group:		LFS/Tools
Vendor:	Octothorpe
Source:	binutils-2.30.tar.xz
%description
The Binutils package contains a linker, an assembler,
and other tools for handling object files.
#-----------------------------------------------------------------------------
%prep
%setup -q -n binutils-%{version}
	mkdir -v build
%build
	cd build
	 ../configure --prefix=%{_prefix} \
		--with-sysroot=%{_lfsdir} \
		--with-lib-path=%{_libdir} \
		--target=%{LFS_TGT} \
		--disable-nls \
		--disable-werror
	make %{?_smp_mflags}
%install
	cd build
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}%{_libdir}
	ln -sv lib %{buildroot}%_lib64
	rm -rf %{buildroot}%{_datarootdir}
	cd -
#-----------------------------------------------------------------------------
#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,lfs,lfs)
	%_lib64
#-----------------------------------------------------------------------------
%changelog
*	Sat Mar 10 2018 baho-utot <baho-utot@columbus.rr.com> 2.30-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 2.29-1
-	LFS-8.1
