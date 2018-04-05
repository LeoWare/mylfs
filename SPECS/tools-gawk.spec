Summary:	The Gawk package contains programs for manipulating text files.
Name:	tools-gawk
Version:	4.2.0
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/gawk
Group:	LFS/Tools
Vendor:	Octothorpe
BuildRequires:	tools-findutils
Source0:	http://ftp.gnu.org/gnu/gawk/gawk-%{version}.tar.xz
%description
	The Gawk package contains programs for manipulating text files.
%prep
%setup -q -n gawk-%{version}
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
*	Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 4.2.0-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 4.1.4-1
-	LFS-8.1
