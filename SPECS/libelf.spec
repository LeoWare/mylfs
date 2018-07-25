Summary:	The elfutils package contains a set of utilities and libraries for handling ELF files
Name:		libelf
Version:	0.170
Release:	1
License:	GPLv3
URL:		https://sourceware.org/ftp/elfutils
Group:		LFS/BASE
Vendor:		Octothorpe
Source0:	https://sourceware.org/ftp/elfutils/0.170/elfutils-%{version}.tar.bz2
%description
	The elfutils package contains a set of utilities and libraries for handling ELF
	(Executable and Linkable Format) files.
%prep
%setup -q -n elfutils-%{version}
%build
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	#	make DESTDIR=%{buildroot} install
	make DESTDIR=%{buildroot} -C libelf install
	install -vDm644 config/libelf.pc %{buildroot}%{_libdir}/pkgconfig/libelf.pc
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
%files -f filelist.rpm
   %defattr(-,root,root)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 0.170-1
-	LFS-8.1
