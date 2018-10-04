%global debug_package %{nil}
#TARBALL:	http://ftp.gnu.org/gnu/grep/grep-3.1.tar.xz
#MD5SUM:	feca7b3e7c7f4aab2b42ecbfc513b070;SOURCES/grep-3.1.tar.xz
#PATCHES:
#FILE:		grep-3.1.tar.xz.md5sum
#-----------------------------------------------------------------------------
Summary:	The Grep package contains programs for searching through files.
Name:		tools-grep
Version:	3.1
Release:	2
License:	GPL
URL:		http://ftp.gnu.org/gnu/grep
Group:		LFS/Tools
Vendor:	Octothorpe
Source0:	http://ftp.gnu.org/gnu/grep/grep-%{version}.tar.xz
%description
The Grep package contains programs for searching through files.
#-----------------------------------------------------------------------------
%prep
%setup -q -n grep-%{version}
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
*	Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 3.1-2
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 3.1-1
-	LFS-8.1
