%global debug_package %{nil}
#TARBALL:	http://ftp.gnu.org/gnu/texinfo/texinfo-6.5.tar.xz
#MD5SUM:	3715197e62e0e07f85860b3d7aab55ed;SOURCES/texinfo-6.5.tar.xz
#PATCHES:
#FILE:		texinfo-6.5.tar.xz.md5sum
#-----------------------------------------------------------------------------
Summary:	The Texinfo package contains programs for reading, writing, and converting info pages.
Name:		tools-texinfo
Version:	6.5
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/texinfo
Group:		LFS/Tools
Vendor:	Octothorpe
Source0:	http://ftp.gnu.org/gnu/texinfo/texinfo-%{version}.tar.xz
%description
The Texinfo package contains programs for reading, writing, and converting info pages.
#-----------------------------------------------------------------------------
%prep
%setup -q -n texinfo-%{version}
%build
	./configure --prefix=%{_prefix}
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
*	Tue Mar 13 2018 baho-utot <baho-utot@columbus.rr.com> 6.5-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 6.4-1
-	LFS-8.1
