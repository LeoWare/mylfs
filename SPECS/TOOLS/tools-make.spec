Summary:	The Make package contains a program for compiling packages. 	
Name:		tools-make
Version:	4.2.1
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/make
Group:		LFS/Tools
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source0:	http://ftp.gnu.org/gnu/make/make-%{version}.tar.bz2
%description
	The Make package contains a program for compiling packages. 
%prep
%setup -q -n make-%{version}
%build
	./configure --prefix=%{_prefix} \
		--without-guile 
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	rm -rf %{buildroot}/tools/share/info
	rm -rf %{buildroot}/tools/share/man
	rm -rf %{buildroot}/tools/share/locale
	#install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 4.2.1-1
-	LFS-8.1