%global debug_package %{nil}
#-----------------------------------------------------------------------------
Summary:	The Sed package contains a stream editor.
Name:		tools-sed
Version:	4.4
Release:	2
License:	GPL
URL:		http://ftp.gnu.org/gnu/sed
Group:		LFS/Tools
Vendor:		Octothorpe
BuildRequires:	tools-perl
Source0:	http://ftp.gnu.org/gnu/sed/sed-%{version}.tar.xz
%description
	The Sed package contains a stream editor.
#-----------------------------------------------------------------------------
%prep
%setup -q -n sed-%{version}
%build
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	rm -rf %{buildroot}%{_infodir}
	rm -rf %{buildroot}%{_mandir}
	rm -rf %{buildroot}%{_datarootdir}/locale
#-----------------------------------------------------------------------------
#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
#-----------------------------------------------------------------------------
%changelog
*	Tue Mar 13 2018 baho-utot <baho-utot@columbus.rr.com> 4.4-2
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 4.4-1
-	LFS-8.1
