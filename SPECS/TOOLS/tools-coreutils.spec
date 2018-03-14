Summary:	The Coreutils package contains utilities for showing and setting the basic system characteristics. 
Name:		tools-coreutils
Version:	8.29
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/coreutils
Group:		LFS/Tools
Vendor:		Octothorpe
Source0:	http://ftp.gnu.org/gnu/coreutils/coreutils-%{version}.tar.xz
%description
	The Coreutils package contains utilities for showing and setting the basic system characteristics. 
%prep
%setup -q -n coreutils-%{version}
%build
	./configure \
		--prefix=%{_prefix} \
		--enable-install-program=hostname
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
*	Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 8.29-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 8.27-1
-	LFS-8.1