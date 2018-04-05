Summary:	The Xz package contains programs for compressing and decompressing files.
Name:	tools-xz
Version:	5.2.3
Release:	2
License:	GPL
URL:		http://tukaani.org/xz
Group:	LFS/Tools
Vendor:	Octothorpe
BuildRequires:	tools-util-linux
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
	rm -rf %{buildroot}%{_infodir}
	rm -rf %{buildroot}%{_mandir}
	rm -rf %{buildroot}%{_datarootdir}/locale
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Tue Mar 13 2018 baho-utot <baho-utot@columbus.rr.com> 5.2.3-2
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 5.2.3-1
-	LFS-8.1
