Summary:	The Patch package contains a program for modifying or creating files	
Name:		tools-patch
Version:	2.7.5
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/patch
Group:		LFS/Tools
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
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
	rm -rf %{buildroot}/tools/share/man
	#install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 2.7.5-1
-	LFS-8.1