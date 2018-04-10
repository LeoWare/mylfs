Summary:	The Patch package contains a program for modifying or creating files
Name:		tools-patch
Version:	2.7.6
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/patch
Group:		LFS/Tools
Vendor:	Octothorpe
BuildRequires:	tools-make
Source0:	http://ftp.gnu.org/gnu/patch/patch-%{version}.tar.xz
%description
	The Patch package contains a program for modifying or creating files
%prep
%setup -q -n patch-%{version}
%build
	./configure --prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	rm -rf %{buildroot}%{_mandir}
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 2.7.6-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 2.7.5-1
-	LFS-8.1
