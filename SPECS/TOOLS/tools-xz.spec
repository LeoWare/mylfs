Summary:	The Xz package contains programs for compressing and decompressing files.	
Name:		tools-xz
Version:	5.2.3
Release:	1
License:	GPL
URL:		http://tukaani.org/xz
Group:		LFS/Tools
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source0:	http://tukaani.org/xz/xz-%{version}.tar.xz
%description
	The Xz package contains programs for compressing and decompressing files.
	It provides capabilities for the lzma and the newer xz compression formats.
	Compressing text files with xz yields a better compression percentage than
	with the traditional gzip or bzip2 commands. 
%prep
%setup -q -n xz-%{version}
%build
	./configure --prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	rm -rf %{buildroot}/tools/share/doc
	rm -rf %{buildroot}/tools/share/man
	rm -rf %{buildroot}/tools/share/locale
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 5.2.3-1
-	LFS-8.1