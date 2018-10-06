%global debug_package %{nil}
#TARBALL:	http://ftp.gnu.org/gnu/findutils/findutils-4.6.0.tar.gz
#MD5SUM:	9936aa8009438ce185bea2694a997fc1;SOURCES/findutils-4.6.0.tar.gz
#-----------------------------------------------------------------------------
Summary:	The Findutils package contains programs to find files
Name:		tools-findutils
Version:	4.6.0
Release:	2
License:	GPL
URL:		http://ftp.gnu.org/gnu/findutils
Group:		LFS/Tools
Vendor:	Octothorpe
Source0:	http://ftp.gnu.org/gnu/findutils/findutils-%{version}.tar.gz
%description
The Findutils package contains programs to find files. These programs are provided
to recursively search through a directory tree and to create, maintain, and search
a database (often faster than the recursive find, but unreliable if the database
has not been recently updated).
#-----------------------------------------------------------------------------
%prep
%setup -q -n findutils-%{version}
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
*	Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 4.6.0-2
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 4.6.0-1
-	LFS-8.1
