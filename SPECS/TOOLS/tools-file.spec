Summary:	The File package contains a utility for determining the type of a given file or files. 
Name:		tools-file
Version:	5.31
Release:	1
License:	GPL
URL:		ftp://ftp.astron.com/pub/file
Group:		LFS/Tools
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source0:	ftp://ftp.astron.com/pub/file/file-%{version}.tar.gz
%description
	The File package contains a utility for determining the type of a given file or files. 
%prep
%setup -q -n file-%{version}
%build
	#	added:  --disable-zlib
	./configure \
		--prefix=%{_prefix} \
		--disable-zlib
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	find %{buildroot} -name '*.la' -delete
	rm -rf %{buildroot}/tools/share/man
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 5.31-1
-	LFS-8.1