%global debug_package %{nil}
#TARBALL:	http://ftp.gnu.org/gnu/bison/bison-3.0.4.tar.xz
#MD5SUM:	c342201de104cc9ce0a21e0ad10d4021;SOURCES/bison-3.0.4.tar.xz
#PATCHES:
#FILE:		bison-3.0.4.tar.xz.md5sum
#-----------------------------------------------------------------------------
Summary:	The Bison package contains a parser generator.
Name:		tools-bison
Version:	3.0.4
Release:	2
License:	GPL
URL:		http://ftp.gnu.org/gnu/bison
Group:		LFS/Tools
Vendor:	Octothorpe
Source0:	http://ftp.gnu.org/gnu/bison/bison-%{version}.tar.xz
%description
The Bison package contains a parser generator.
#-----------------------------------------------------------------------------
%prep
%setup -q -n bison-%{version}
%build
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	find %{buildroot}/tools -name '*.la' -delete
	rm -rf %{buildroot}%{_docdir}
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
*	Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 3.0.4-2
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 3.0.4-1
-	LFS-8.1
