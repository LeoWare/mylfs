Summary:	The Glibc package contains the main C library.
Name:		tools-glibc
Version:	2.27
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/glibc
Group:		LFS/Tools
Vendor:		Octothorpe
BuildRequires:	tools-linux-api-headers
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
	cd build
	../configure \
		--prefix=%{_prefix} \
		--host=%{LFS_TGT} \
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
%post
	_log="%_topdir/LOGS/%{NAME}.test"
	> ${_log}
	cd %_topdir >> ${_log} 2>&1
	pwd >> ${_log} 2>&1
	printf "%s\n" "	Running Check: " >> ${_log} 2>&1
	echo 'int main(){}' > dummy.c
	/tools/bin/%LFS_TGT-gcc dummy.c >> ${_log} 2>&1
	readelf -l a.out | grep ': /tools' >> ${_log} 2>&1
	printf "\n" >> ${_log} 2>&1
	printf "%s\n" "Output:	[Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]" >> ${_log} 2>&1
	rm dummy.c a.out || true
	printf "%s\n" "SUCCESS" >> ${_log} 2>&1
	cd - >> ${_log} 2>&1
%files -f filelist.rpm
	%defattr(-,lfs,lfs)
%changelog
*	Sat Mar 10 2018 baho-utot <baho-utot@columbus.rr.com> 2.27-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 2.26-1
-	LFS-8.1
