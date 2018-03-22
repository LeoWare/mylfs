Summary:	The Glibc package contains the main C library.
Name:		tools-glibc
Version:	2.27
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/glibc
Group:		LFS/Tools
Vendor:		Octothorpe
Source0:	http://ftp.gnu.org/gnu/glibc/glibc-%{version}.tar.xz
%description
	The Glibc package contains the main C library. 
	This library provides the basic routines for allocating memory, 
	searching directories, opening and closing files, 
	reading and writing files, string handling, 
	pattern matching, arithmetic, and so on. 
%prep
%setup -q -n glibc-%{version}
mkdir -v build
%build

	cd       build
	../configure \
		--prefix=%{_prefix} \
		--host=%{_lfs_tgt} \
		--build=$(../scripts/config.guess) \
		--enable-kernel=3.2 \
		--with-headers=%{_includedir} \
		libc_cv_forced_unwind=yes \
		libc_cv_c_cleanup=yes
	make %{?_smp_mflags}
%install
	cd build
	make install_root=%{buildroot} install
	cd -
	find %{buildroot}/tools -name '*.la' -delete
	rm -rf %{buildroot}%{_datarootdir}
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,lfs,lfs)
%changelog
*	Sat Mar 10 2018 baho-utot <baho-utot@columbus.rr.com> 2.27-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 2.26-1
-	LFS-8.1