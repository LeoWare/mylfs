Summary:	The Diffutils package contains programs that show the differences between files or directories.
Name:	tools-diffutils
Version:	3.6
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/diffutils
Group:	LFS/Tools
Vendor:	Octothorpe
BuildRequires:	tools-coreutils
Source0:	http://ftp.gnu.org/gnu/diffutils/diffutils-%{version}.tar.xz
%description
	The Diffutils package contains programs that show the differences between files or directories.
%prep
%setup -q -n diffutils-%{version}
%build
	./configure \
		--prefix=%{_prefix}
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
*	Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 3.6-2
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 3.6-1
-	LFS-8.1
