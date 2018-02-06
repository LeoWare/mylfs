Summary:	The Bzip2 package contains programs for compressing and decompressing files
Name:		bzip2	
Version:	1.0.6
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source0:	http://www.%{name}.org/%{version}/%{name}-%{version}.tar.gz
Patch0:		http://www.linuxfromscratch.org/patches/lfs/8.1/%{name}-%{version}-install_docs-1.patch	
%description
	The Bzip2 package contains programs for compressing and decompressing files
	Compressing text files with bzip2 yields a much better compression percentage
	than with the traditional gzip. 
%prep
%setup -q -n %{NAME}-%{VERSION}
%patch0 -p1
#	  CFLAGS='%_optflags -fPIC '
#	CXXFLAGS='%_optflags -fPIC '
#	sed -i "s|-O2|${CFLAGS}|g" Makefile
#	sed -i "s|-O2|${CFLAGS}|g" Makefile-libbz2_so
	sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
	sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
%build
	make -f Makefile-libbz2_so
	make clean
	make
%install
	make PREFIX=%{buildroot}/usr install
	install -vdm 755 %{buildroot}/bin
	install -vdm 755 %{buildroot}/lib
	install -vdm 755 %{buildroot}/usr/lib
	install -vdm 755 %{buildroot}/usr/bin
	cp -v bzip2-shared %{buildroot}/bin/bzip2
	cp -av libbz2.so* %{buildroot}/lib
	ln -sv ../../lib/libbz2.so.1.0 %{buildroot}/usr/lib/libbz2.so
	rm -v %{buildroot}/usr/bin/{bunzip2,bzcat,bzip2}
	ln -sv bzip2 %{buildroot}/bin/bunzip2
	ln -sv bzip2 %{buildroot}/bin/bzcat
	#	Copy license/copying file 
	#install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version