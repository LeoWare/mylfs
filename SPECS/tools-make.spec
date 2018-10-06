%global debug_package %{nil}
#TARBALL:	http://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2
#MD5SUM:	15b012617e7c44c0ed482721629577ac;SOURCES/make-4.2.1.tar.bz2
#-----------------------------------------------------------------------------
Summary:	The Make package contains a program for compiling packages.
Name:		tools-make
Version:	4.2.1
Release:	2
License:	GPL
URL:		http://ftp.gnu.org/gnu/make
Group:		LFS/Tools
Vendor:	Octothorpe
Source0:	http://ftp.gnu.org/gnu/make/make-%{version}.tar.bz2
%description
The Make package contains a program for compiling packages.
#-----------------------------------------------------------------------------
%prep
%setup -q -n make-%{version}
sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c
%build
	./configure --prefix=%{_prefix} \
		--without-guile
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
*	Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 4.2.1-2
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 4.2.1-1
-	LFS-8.1
