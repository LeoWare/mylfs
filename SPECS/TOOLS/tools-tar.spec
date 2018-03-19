Summary:	The Tar package contains an archiving program. 	
Name:		tools-tar
Version:	1.30
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/tar
Group:		LFS/Tools
Vendor:		Octothorpe
Source0:	http://ftp.gnu.org/gnu/tar/tar-%{version}.tar.xz
%description
	The Tar package contains an archiving program. 
%prep
%setup -q -n tar-%{version}
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
*	Tue Mar 13 2018 baho-utot <baho-utot@columbus.rr.com> 1.30-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 1.29-1
-	LFS-8.1