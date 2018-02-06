Summary:	The M4 package contains a macro processor.	
Name:		tools-m4
Version:	1.4.18
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/m4
Group:		LFS/Tools
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source0:	http://ftp.gnu.org/gnu/m4/m4-%{version}.tar.xz
%description
	The M4 package contains a macro processor.
%prep
%setup -q -n m4-%{version}
%build
	./configure \
		--prefix=%{_prefix}	
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	rm -rf %{buildroot}/tools/share/info
	rm -rf %{buildroot}/tools/share/man
	#install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 1.4.18-1
-	LFS-8.1