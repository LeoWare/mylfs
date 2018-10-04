%global debug_package %{nil}
#TARBALL:	ftp://ftp.astron.com/pub/file/file-5.32.tar.gz
#MD5SUM:	4f2503752ff041895090ed6435610435;SOURCES/file-5.32.tar.gz
#PATCHES:
#FILE:		file-5.32.tar.gz.md5sum
#-----------------------------------------------------------------------------
Summary:	The File package contains a utility for determining the type of a given file or files.
Name:		tools-file
Version:	5.32
Release:	1
License:	GPL
URL:		ftp://ftp.astron.com/pub/file
Group:		LFS/Tools
Vendor:	Octothorpe
Source0:	ftp://ftp.astron.com/pub/file/file-%{version}.tar.gz
%description
The File package contains a utility for determining the type of a given file or files.
#-----------------------------------------------------------------------------
%prep
%setup -q -n file-%{version}
%build
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	rm -rf %{buildroot}%{_mandir}
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
*	Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 5.32-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 5.31-1
-	LFS-8.1
