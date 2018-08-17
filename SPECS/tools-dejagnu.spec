Summary:	The DejaGNU package contains a framework for testing other programs.
Name:		tools-dejagnu
Version:	1.6.1
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/dejagnu
Group:		LFS/Tools
Vendor:		Octothorpe
BuildRequires:	tools-expect
Source0:	http://ftp.gnu.org/gnu/dejagnu/dejagnu-%{version}.tar.gz
%description
	The DejaGNU package contains a framework for testing other programs.
%prep
%setup -q -n dejagnu-%{version}
%build
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	rm -rf %{buildroot}%{_infodir}
	rm -rf %{buildroot}%{_mandir}
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,lfs,lfs)
%changelog
*	Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 1.6.1-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 1.6-1
-	LFS-8.1
