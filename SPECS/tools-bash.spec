%global debug_package %{nil}
#TARBALL:	http://ftp.gnu.org/gnu/bash/bash-4.4.18.tar.gz
#MD5SUM:	518e2c187cc11a17040f0915dddce54e;SOURCES/bash-4.4.18.tar.gz
#PATCHES:
#FILE:		bash-4.4.18.tar.gz.md5sum
#-----------------------------------------------------------------------------
Summary:	The Bash package contains the Bourne-Again SHell.
Name:		tools-bash
Version:	4.4.18
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/bash
Group:		LFS/Tools
Vendor:	Octothorpe
Source0:	http://ftp.gnu.org/gnu/bash/bash-%{version}.tar.gz
%description
The Bash package contains the Bourne-Again SHell.
#-----------------------------------------------------------------------------
%prep
%setup -q -n bash-%{version}
%build
	./configure \
		--prefix=%{_prefix} \
		--without-bash-malloc
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	ln -sv bash %{buildroot}%{_bindir}/sh
	find %{buildroot}/tools -name '*.la' -delete
	rm -rf %{buildroot}%{_datarootdir}
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
*	 Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 4.4.18-1
*	 Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 4.4-1
-	LFS-8.1
